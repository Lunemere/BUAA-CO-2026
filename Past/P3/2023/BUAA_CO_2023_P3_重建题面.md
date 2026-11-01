# BUAA CO 2023 P3

在课下完成的 Logisim 单周期 MIPS CPU（支持`addu`、`subu`、`ori`、`lui`、`lw`、`sw`、`beq`、`nop`）上添加以下三条新指令。三题互相独立。

## 第一题

### 指令格式

`QAQ`-`rd`-`rs`-`rt`

R型计算类指令，`OpCode` 为`000000`，`funct` 为`101000`

| 31:26 | 25:21 | 20:16 | 15:11 | 10:6 | 5:0 |
| --- | --- | --- | --- | --- | --- |
| `000000` | `rs` | `rt` | `rd` | `00000` | `101000` |

汇编形式：`qaq $s1, $s2, $s3`

### 指令描述

分别计算`rs`、`rt`中数值的平方并只保留低32位，再将两个结果按位与，存入`rd`。

### RTL语言

```
temp1 <- (GPR[rs] * GPR[rs])[31:0]
temp2 <- (GPR[rt] * GPR[rt])[31:0]
GPR[rd] <- temp1 & temp2
```

## 第二题

### 指令格式

`BOOEZ`-`rs`-`rt`-`offset`

I型跳转类指令，机器码为`011000`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `011000` | `rs` | `rt` | `offset` |

汇编形式：`booez $t1, $t2, label`

### 指令描述

若`rs`低16位中1的个数为奇数，且`rt`高16位中0的个数为偶数，则按`beq`的方式跳转到`label`；否则顺序执行。

### RTL语言

```
ones  <- count_ones(GPR[rs][15:0])
zeros <- count_zeros(GPR[rt][31:16])
if (ones mod 2 == 1 && zeros mod 2 == 0)
	PC <- PC + 4 + sign_ext(offset||00)
else
	PC <- PC + 4
```

## 第三题

### 指令格式

`CSWS`-`base`-`rt`-`offset`

I型访存类指令，机器码为`011001`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `011001` | `base` | `rt` | `offset` |

汇编形式：`csws $t0, 0($t1)`

### 指令描述

按`sw`的方式计算地址。若`rt`中数值最高位为1，将`rt`中数值存入该地址；否则向该地址存入0。

### RTL语言

```
addr <- GPR[base] + sign_ext(offset)
if (GPR[rt][31] == 1)
	memory[addr] <- GPR[rt]
else
	memory[addr] <- 0
```
