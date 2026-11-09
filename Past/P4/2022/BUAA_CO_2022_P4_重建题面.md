# BUAA CO 2022 P4

在课下完成的 Verilog 单周期 MIPS CPU 上添加以下三条新指令。三题互相独立。

## 第一题

### 指令格式

`RAS`-`rt`-`rs`-`imm16`

I型计算类指令，机器码为`011001`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `011001` | `rs` | `rt` | `imm16` |

汇编形式：`ras $t0, $t1, 5`

### 指令描述

Reverse and Arithmetic Shift

将`imm16`视为无符号数。把`GPR[rs]`的高`imm16`位按位取反（`imm16`不小于32时即整个字取反；`imm16`为0时不取反），其余位不变，得到`temp`；再将`temp`**算术**右移`imm16`中1的个数位，结果存入`rt`。

### RTL语言

```
n    <- count_ones(imm16)
if (imm16 == 0)
	temp <- GPR[rs]
else if (imm16 < 32)
	temp <- ~GPR[rs][31:32-imm16] || GPR[rs][31-imm16:0]
else
	temp <- ~GPR[rs]
GPR[rt] <- temp >>> n
PC <- PC + 4
```

（`>>>`为算术右移）

## 第二题

### 指令格式

`BAO`-`rs`-`rt`-`offset`

I型跳转类指令，机器码为`101101`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `101101` | `rs` | `rt` | `offset` |

汇编形式：`bao $t1, $t2, label`

### 指令描述

Branch if Add Overflows

将`GPR[rs]`与`GPR[rt]`作为有符号数相加。若发生有符号溢出，则按`beq`的方式跳转；否则顺序执行。不写任何寄存器。

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

汇编形式：`lboez $t0, 1($t1)`

### 指令描述

Load Byte if the number of Ones Equals Zeros

按`lb`的方式计算地址，取出`addr[1:0]`所指定的字节。若该字节8位二进制表示中1的个数恰为4（即1与0的个数相等），则将该字节符号扩展后存入`rt`；否则向`rt`写入0。

### RTL语言

```
vaddr   <- GPR[base] + sign_ext(offset)
paddr   <- vaddr[31:2] || 00
memword <- Memory[paddr]
byte    <- vaddr[1:0]
temp    <- count_ones(memword[7+8*byte : 8*byte])
if (temp == 4)
	GPR[rt] <- sign_ext(memword[7+8*byte : 8*byte])
else
	GPR[rt] <- 0
PC <- PC + 4
```
