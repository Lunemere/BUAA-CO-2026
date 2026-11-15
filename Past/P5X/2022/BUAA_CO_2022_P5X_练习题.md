# BUAA CO 2022 P5X 练习题

在课下完成的 Verilog 单周期 MIPS CPU 上添加以下三条新指令。三题互相独立，异常处理沿用 P5X 课下要求。

## 第一题

### 指令格式

`RAS`-`rt`-`rs`-`imm16`

I型计算类指令，机器码为`011001`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `011001` | `rs` | `rt` | `imm16` |

汇编形式：`ras rt, rs, imm`

### 指令描述

Reverse and Arithmetic Shift

将`imm16`视为16位无符号数。若`imm16`在`[0, 32]`范围内，将`GPR[rs]`的高`imm16`位按位取反，其余位不变，再将所得结果算术右移`imm16`的16位二进制表示中1的个数位，结果存入`GPR[rt]`。`imm16`为0时原样复制，为32时整个字取反后算术右移1位。

若`imm16 > 32`，产生`RI`异常，不写入寄存器。

### RTL语言

```
if (unsigned(imm16) > 32)
    SignalException(RI)
else
    n <- count_ones(imm16)
    if (imm16 == 0)
        temp <- GPR[rs]
    else if (imm16 == 32)
        temp <- ~GPR[rs]
    else
        temp <- ~GPR[rs][31:32-imm16] || GPR[rs][31-imm16:0]
    GPR[rt] <- signed(temp) >>> n
    PC <- PC + 4
```

## 第二题

### 指令格式

`BAO`-`rs`-`rt`-`offset`

I型跳转类指令，机器码为`101101`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `101101` | `rs` | `rt` | `offset` |

汇编形式：`bao rs, rt, label`

### 指令描述

Branch if Add Overflows

将`GPR[rs]`与`GPR[rt]`作为32位有符号数相加。若发生有符号溢出，则跳转到`PC+4+sign_ext(offset||00)`；否则顺序执行。不考虑延迟槽，不写任何寄存器。

操作数相加的溢出只用于判断分支是否成立。操作数相加及目标地址计算均不产生`Ov`异常。分支成立且目标地址超出`0x3000 ~ 0x6ffc`时，在下一周期取指时产生`AdEL`，EPC记录目标地址。分支不成立时不检查分支目标。

### RTL语言

```
sum <- {GPR[rs][31], GPR[rs]} + {GPR[rt][31], GPR[rt]}
if (sum[32] != sum[31])
    PC <- PC + 4 + sign_ext(offset||00)
else
    PC <- PC + 4
```

## 第三题

### 指令格式

`LBOEZ`-`base`-`rt`-`offset`

I型访存类指令，机器码为`111110`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `111110` | `base` | `rt` | `offset` |

汇编形式：`lboez rt, offset(base)`

### 指令描述

Load Byte if the number of Ones Equals Zeros

将16位`offset`符号扩展后与`GPR[base]`相加得到地址`addr`，从`addr[31:2] || 00`处的字中取出`addr[1:0]`指定的字节，编号0对应最低8位。若该字节中1的个数恰为4，则将该字节符号扩展后存入`GPR[rt]`；否则向`GPR[rt]`写入0。

允许`addr`不字对齐。地址加法发生有符号溢出，或所得32位地址超出`0x0000 ~ 0x2fff`时，产生取数`AdEL`，不写入寄存器。该指令不产生`Ov`异常。

### RTL语言

```
imm32 <- sign_ext(offset)
sum   <- {GPR[base][31], GPR[base]} + {imm32[31], imm32}
addr  <- sum[31:0]
if (sum[32] != sum[31] || unsigned(addr) > 0x00002fff)
    SignalException(AdEL)
else
    memword  <- Memory[addr[31:2] || 00]
    lane     <- addr[1:0]
    selected <- memword[8*lane+7:8*lane]
    if (count_ones(selected) == 4)
        GPR[rt] <- sign_ext(selected)
    else
        GPR[rt] <- 0
    PC <- PC + 4
```
