# BUAA CO 2021 P5X 练习题

在课下完成的 Verilog 单周期 MIPS CPU 上添加以下三条新指令。三题互相独立，异常处理沿用 P5X 课下要求。

## 第一题

### 指令格式

`RLB`-`rt`-`rs`-`imm16`

I型计算类指令，机器码为`111111`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `111111` | `rs` | `rt` | `imm16` |

汇编形式：`rlb rt, rs, imm`

### 指令描述

将`imm16`视为16位无符号数。若`imm16`在`[0, 31]`范围内，将`GPR[rs]`的低`imm16`位按位取反，其余位保持不变，结果存入`GPR[rt]`；`imm16`为0时结果即`GPR[rs]`。

若`imm16 > 31`，产生`RI`异常，不写入寄存器。

### RTL语言

```
if (unsigned(imm16) > 31)
    SignalException(RI)
else
    if (imm16 == 0)
        GPR[rt] <- GPR[rs]
    else
        GPR[rt] <- GPR[rs][31:imm16] || ~GPR[rs][imm16-1:0]
    PC <- PC + 4
```

## 第二题

### 指令格式

`BNEZALC`-`rs`-`offset`

I型跳转类指令，`opcode`为`000001`，`20:16`位固定为`10011`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `000001` | `rs` | `10011` | `offset` |

汇编形式：`bnezalc rs, label`

### 指令描述

Branch if Not Equal to Zero and Link

若`GPR[rs]`不为0，则跳转到`PC+4+sign_ext(offset||00)`，并将`PC+4`存入`$ra`；否则顺序执行，不写任何寄存器。不考虑延迟槽，条件判断使用写回前的寄存器值。

`opcode`为`000001`但`20:16`位不为`10011`时，产生`RI`异常。目标地址计算不产生`Ov`异常。

分支成立且目标地址越界时，在下一周期取指时产生`AdEL`，EPC记录目标地址，已经写入的`$ra`保留。分支不成立时不检查分支目标。当前PC取指异常时，不执行分支，也不写`$ra`。

### RTL语言

以下为`opcode = 000001`时的行为。

```
if (instruction[20:16] != 5'b10011)
    SignalException(RI)
else
    old_rs <- GPR[rs]
    next   <- PC + 4
    if (old_rs != 0)
        GPR[31] <- next
        PC <- next + sign_ext(offset||00)
    else
        PC <- next
```

## 第三题

### 指令格式

`LWRR`-`base`-`rt`-`offset`

I型访存类指令，机器码为`110100`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `110100` | `base` | `rt` | `offset` |

汇编形式：`lwrr rt, offset(base)`

### 指令描述

Load Word and Rotate Right

按`lw`的方式计算地址`addr`，读出`addr`所在的字，按`addr[1:0]`的字节数将其循环右移（移出的低位补到高位），结果存入`rt`。

允许`addr`不字对齐，只读取`addr[31:2] || 00`处的一个字。地址加法发生有符号溢出，或所得32位地址超出`0x0000 ~ 0x2fff`时，产生取数`AdEL`，不写入寄存器。该指令不产生`Ov`异常；原有`lw`、`sw`的对齐要求不变。

### RTL语言

```
imm32 <- sign_ext(offset)
sum   <- {GPR[base][31], GPR[base]} + {imm32[31], imm32}
addr  <- sum[31:0]
if (sum[32] != sum[31] || unsigned(addr) > 0x00002fff)
    SignalException(AdEL)
else
    byte    <- addr[1:0]
    memword <- Memory[addr[31:2] || 00]
    if (byte == 0)
        GPR[rt] <- memword
    else
        GPR[rt] <- memword[8*byte-1:0] || memword[31:8*byte]
    PC <- PC + 4
```
