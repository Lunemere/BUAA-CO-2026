# BUAA CO 2024 P3

在课下完成的 Logisim 单周期 MIPS CPU 上添加以下三条新指令。三题互相独立，均不需要新增数据通路。

## 第一题

### 指令格式

`CWP`-`rs`-`rt`-`imm16`

I型计算类指令，机器码为`011000`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `011000` | `rs` | `rt` | `imm16` |

### 指令描述

将`imm16`零扩展为32位后逻辑左移8位，与当前`PC`作无符号比较。若大于`PC`，将`imm16`零扩展的结果存入`rs`；否则存入`rt`。（写入的是左移前的零扩展值）

### RTL语言

```
temp <- zero_ext(imm16)
if ((temp << 8) > PC)
	GPR[rs] <- temp
else
	GPR[rt] <- temp
PC <- PC + 4
```

## 第二题

### 指令格式

`BGC`-`rs`-`rt`-`offset`

I型跳转类指令，机器码为`011001`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `011001` | `rs` | `rt` | `offset` |

### 指令描述

将`rs`中数值按位划分为16个2位二进制数，把每个2位数转换为其格雷码，统计所有格雷码中1的个数之和。若该总和大于`rt`中数值（无符号比较），则按`beq`的方式跳转；否则`PC`正常自增。

### RTL语言

```
sum <- 0
for i in 0..15
	b <- GPR[rs][2i+1:2i]
	grey <- b ^ (b >> 1)
	sum <- sum + count_ones(grey)
if (sum > GPR[rt])
	PC <- PC + 4 + sign_ext(offset||00)
else
	PC <- PC + 4
```

## 第三题

### 指令格式

`LWSO`-`rs`-`rt`-`imm16`

I型访存类指令，机器码为`011010`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `011010` | `rs` | `rt` | `imm16` |

### 指令描述

从`GPR[rs]+sign_ext(imm16)`处读出一个字。由`rt`中数值动态计算两个寄存器编号：若读出的字为奇数，存入`reg_left`；否则存入`reg_right`。

### RTL语言

```
h_temp     <- GPR[rt] & 0xf
reg_right  <- (GPR[rt] >> h_temp) & 0x1f
reg_left   <- (GPR[rt] << h_temp) & 0x1f
write_data <- memory[GPR[rs] + sign_ext(imm16)]
if (write_data mod 2 == 1)
	GPR[reg_left] <- write_data
else
	GPR[reg_right] <- write_data
```

（`>>`为逻辑右移）
