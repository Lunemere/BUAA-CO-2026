# BUAA CO 2025 P5X 练习题

在课下完成的 Verilog 单周期 MIPS CPU 上添加以下三条新指令。三题互相独立，异常处理沿用 P5X 课下要求。

## 第一题

### 指令格式

`BRC`-`rs`-`rt`-`rd`

R型计算类指令，`opcode`为`000000`，`funct`为`101001`，`10:6`位固定为`00000`

| 31:26 | 25:21 | 20:16 | 15:11 | 10:6 | 5:0 |
| --- | --- | --- | --- | --- | --- |
| `000000` | `rs` | `rt` | `rd` | `00000` | `101001` |

汇编形式：`brc rd, rs, rt`

### 指令描述

将`GPR[rs][4:0]`视为无符号数`temp`。若`temp < 25`且`GPR[rt][temp+7:temp]`中1的个数为偶数，将`GPR[rt]`的32位按位逆序后存入`GPR[rd]`；否则将`GPR[rt]`原样存入`GPR[rd]`。按位逆序指结果的第`i`位等于原数的第`31-i`位。

`opcode`为`000000`且`funct`为`101001`，但`10:6`位不为`00000`时，产生`RI`异常，不写入寄存器。`temp >= 25`时正常复制，不产生异常，也不截取越界位段。

### RTL语言

以下为`opcode = 000000`且`funct = 101001`时的行为。

```
if (instruction[10:6] != 5'b00000)
    SignalException(RI)
else
    temp   <- unsigned(GPR[rs][4:0])
    result <- GPR[rt]
    if (temp < 25)
        if (count_ones(GPR[rt][temp+7:temp]) mod 2 == 0)
            result <- reverse(GPR[rt])
    GPR[rd] <- result
    PC <- PC + 4
```

## 第二题

### 指令格式

`CABC`-`rs`-`rt`-`offset`

I型条件跳转及写回指令，机器码为`111100`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `111100` | `rs` | `rt` | `offset` |

汇编形式：`cabc rs, rt, label`

### 指令描述

按下列RTL将`GPR[rs]`与`GPR[rt]`中的字节拼接成`cross1`、`cross2`，并计算两者按位异或的结果`xor_result`。若结果的高16位与低16位中0的个数相等，则跳转到`PC+4+sign_ext(offset||00)`，不写寄存器；否则将`xor_result`存入`GPR[rt]`，顺序执行。

所有运算使用写回前的寄存器值。目标地址计算不产生`Ov`异常。分支成立且目标地址越界时，在下一周期取指时产生`AdEL`，EPC记录目标地址；分支不成立时不检查分支目标。当前PC取指异常时，不执行分支，也不写入`GPR[rt]`。

### RTL语言

```
cross1 <- GPR[rs][23:16] || GPR[rt][7:0] || GPR[rs][31:24] || GPR[rt][15:8]
cross2 <- GPR[rt][7:0] || GPR[rs][23:16] || GPR[rt][31:24] || GPR[rs][15:8]
xor_result <- cross1 ^ cross2
cnt1 <- count_zero(xor_result[31:16])
cnt2 <- count_zero(xor_result[15:0])
if (cnt1 == cnt2)
    PC <- PC + 4 + sign_ext(offset||00)
else
    GPR[rt] <- xor_result
    PC <- PC + 4
```

## 第三题

### 指令格式

`LHBOC`-`base`-`rt`-`offset`

I型访存类指令，机器码为`101101`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `101101` | `base` | `rt` | `offset` |

汇编形式：`lhboc rt, offset(base)`

### 指令描述

按`lw`的方式计算地址`addr`，读取`addr`所在的字。比较该字低16位与高16位中1的个数，若低16位中1的个数不少于高16位，则将低16位符号扩展后存入`GPR[rt]`；否则将高16位符号扩展后存入`GPR[rt]`。

允许`addr`不字对齐，只读取`addr[31:2] || 00`处的一个字，半字的选择与`addr[1:0]`无关。地址加法发生有符号溢出，或所得32位地址超出`0x0000 ~ 0x2fff`时，产生取数`AdEL`，不写入寄存器。该指令不产生`Ov`异常；原有`lw`、`sw`的对齐要求不变。

### RTL语言

```
imm32 <- sign_ext(offset)
sum   <- {GPR[base][31], GPR[base]} + {imm32[31], imm32}
addr  <- sum[31:0]
if (sum[32] != sum[31] || unsigned(addr) > 0x00002fff)
    SignalException(AdEL)
else
    memword <- Memory[addr[31:2] || 00]
    temp1   <- count_ones(memword[15:0])
    temp2   <- count_ones(memword[31:16])
    if (temp1 >= temp2)
        GPR[rt] <- sign_ext(memword[15:0])
    else
        GPR[rt] <- sign_ext(memword[31:16])
    PC <- PC + 4
```
