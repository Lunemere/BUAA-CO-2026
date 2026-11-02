# BUAA CO 2022 P3

在课下完成的 Logisim 单周期 MIPS CPU 上添加新指令。

## 第一题

### 指令格式

`LWA`-`base`-`rt`-`offset`

I型访存类指令，机器码为`011000`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `011000` | `base` | `rt` | `offset` |

### 指令描述

带对齐判断的 Load Word

按`lw`的方式计算地址`addr`。若`addr`最低两位为`00`，将读出的字存入`rt`；否则向`rt`写入0。

### RTL语言

```
addr <- GPR[base] + sign_ext(offset)
if (addr[1:0] == 2'b00)
	GPR[rt] <- memory[addr]
else
	GPR[rt] <- 0
PC <- PC + 4
```

## 第二题

找不到题面，保持空缺

## 第三题

### 指令格式

`BOAL`-`rs`-`rt`-`rd`-`imm`

I型跳转类指令，机器码为`011001`

| 31:26 | 25:21 | 20:16 | 15:11 | 10:0 |
| --- | --- | --- | --- | --- |
| `011001` | `rs` | `rt` | `rd` | `imm` |

### 指令描述

比较`rs`、`rt`中数值二进制表示里1的个数。若相等，则跳转到`PC+4+(imm<<2)`，并将`PC+4+0x3000`存入`rd`；否则顺序执行，不写任何寄存器。

### RTL语言

```
temp1 <- count_ones(GPR[rs])
temp2 <- count_ones(GPR[rt])
if (temp1 == temp2)
	PC <- PC + 4 + sign_ext(imm||00)
	GPR[rd] <- PC + 4 + 0x3000
else
	PC <- PC + 4
```

（RTL 中两处`PC`均为本条指令的地址）
