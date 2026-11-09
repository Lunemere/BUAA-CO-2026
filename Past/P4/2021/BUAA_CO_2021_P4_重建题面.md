# BUAA CO 2021 P4

在课下完成的 Verilog 单周期 MIPS CPU 上添加新指令。共两套题，每套三题，三题互相独立。

# 第一套

## 第一题

### 指令格式

`RLB`-`rt`-`rs`-`imm16`

I型计算类指令，机器码为`111111`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `111111` | `rs` | `rt` | `imm16` |

汇编形式：`rlb rt, rs, imm`

### 指令描述

将`GPR[rs]`的低`imm16`位按位取反，其余位保持不变，结果存入`GPR[rt]`。保证`imm16`在`[0, 31]`范围内；`imm16`为0时结果即`GPR[rs]`。

### RTL语言

```
if (imm16 == 0)
	GPR[rt] <- GPR[rs]
else
	GPR[rt] <- GPR[rs][31:imm16] || ~GPR[rs][imm16-1:0]
PC <- PC + 4
```

## 第二题

### 指令格式

`BNEZALC`-`rs`-`offset`

I型跳转类指令，`regimm`字段为`000001`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `000001` | `rs` | `10011` | `offset` |

汇编形式：`bnezalc $t0, label`

### 指令描述

Branch if Not Equal to Zero and Link

若`GPR[rs]`不为0，则跳转到`PC+4+sign_ext(offset||00)`，并将`PC+4`存入`$ra`；否则顺序执行，不写任何寄存器。不考虑延迟槽。

### RTL语言

```
if (GPR[rs] != 0)
	PC <- PC + 4 + sign_ext(offset||00)
	GPR[31] <- PC + 4
else
	PC <- PC + 4
```

## 第三题

### 指令格式

`LWRR`-`base`-`rt`-`offset`

I型访存类指令，机器码为`110100`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `110100` | `base` | `rt` | `offset` |

汇编形式：`lwrr $t0, 4($t1)`

### 指令描述

Load Word and Rotate Right

按`lw`的方式计算地址`addr`，读出`addr`所在的字，按`addr[1:0]`的字节数将其循环右移（移出的低位补到高位），结果存入`rt`。

### RTL语言

```
addr    <- GPR[base] + sign_ext(offset)
byte    <- addr[1:0]
memword <- Memory[addr[31:2] || 00]
if (byte == 0)
	GPR[rt] <- memword
else
	GPR[rt] <- memword[8*byte-1:0] || memword[31:8*byte]
PC <- PC + 4
```

# 第二套

## 第一题

### 指令格式

`BOMEZ`-`rs`-`rt`-`offset`

I型跳转类指令，机器码为`101100`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `101100` | `rs` | `rt` | `offset` |

汇编形式：`bomez $t1, $t2, label`

### 指令描述

分别统计`GPR[rs]`、`GPR[rt]`二进制表示中1的个数`a`、`b`。若`a`与`b`均不为0，且`a`能被`b`整除，则按`beq`的方式跳转；否则顺序执行。

### RTL语言

```
a <- count_ones(GPR[rs])
b <- count_ones(GPR[rt])
if (a != 0 && b != 0 && a % b == 0)
	PC <- PC + 4 + sign_ext(offset||00)
else
	PC <- PC + 4
```

## 第二题

### 指令格式

`SSZE`-`rd`-`rs`-`rt`

R型计算类指令，`special` 为`000000`，`funct` 为`001111`

| 31:26 | 25:21 | 20:16 | 15:11 | 10:6 | 5:0 |
| --- | --- | --- | --- | --- | --- |
| `000000` | `rs` | `rt` | `rd` | `00000` | `001111` |

汇编形式：`ssze $s1, $s2, $s3`

### 指令描述

分别统计`GPR[rs]`、`GPR[rt]`从最低位起连续0的个数（数值为0时为32）。若二者相同，则`rd`置为1；否则将`GPR[rs]-GPR[rt]`存入`rd`。

### RTL语言

```
tmp1 <- count_trailing_zeros(GPR[rs])
tmp2 <- count_trailing_zeros(GPR[rt])
if (tmp1 == tmp2)
	GPR[rd] <- 1
else
	GPR[rd] <- GPR[rs] - GPR[rt]
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
addr    <- GPR[base] + sign_ext(offset)
memword <- Memory[addr[31:2] || 00]
byte    <- addr[1:0]
temp    <- count_ones(memword[7+8*byte : 8*byte])
if (temp == 4)
	GPR[rt] <- sign_ext(memword[7+8*byte : 8*byte])
else
	GPR[rt] <- 0
PC <- PC + 4
```
