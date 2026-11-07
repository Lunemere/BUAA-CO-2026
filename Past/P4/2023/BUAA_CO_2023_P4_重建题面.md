# BUAA CO 2023 P4

在课下完成的 Verilog 单周期 MIPS CPU 上添加以下三条新指令。三题互相独立。

## 第一题

### 指令格式

`HMO`-`rd`-`rs`-`rt`

R型计算类指令，`OpCode` 为`000000`，`funct` 为`101101`

| 31:26 | 25:21 | 20:16 | 15:11 | 10:6 | 5:0 |
| --- | --- | --- | --- | --- | --- |
| `000000` | `rs` | `rt` | `rd` | `00000` | `101101` |

汇编形式：`hmo $s1, $s2, $s3`

### 指令描述

比较`rs`、`rt`中数值二进制表示里1的个数。若`rs`中1的个数严格大于`rt`中1的个数，将寄存器**编号**`rs`存入`rd`；否则将寄存器**编号**`rt`存入`rd`。（写入的是指令中的5位编号，零扩展为32位，不是寄存器中的数值）

### RTL语言

```
temp1 <- count_ones(GPR[rs])
temp2 <- count_ones(GPR[rt])
if (temp1 > temp2)
	GPR[rd] <- zero_ext(rs)
else
	GPR[rd] <- zero_ext(rt)
PC <- PC + 4
```

## 第二题

### 指令格式

`OFBAL`-`rs`-`rt`-`offset`

I型跳转类指令，机器码为`011010`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `011010` | `rs` | `rt` | `offset` |

汇编形式：`ofbal $t1, $t2, label`

### 指令描述

将`rs`、`rt`中数值视为有符号数，分别计算二者的和与差（`rs+rt`、`rs-rt`）。若加法与减法均不发生有符号溢出，则按`beq`的方式跳转到`label`，并将`PC+4`存入`$ra`；否则顺序执行，**不写任何寄存器**（`$ra`保持不变）。

### RTL语言

```
sum  <- {GPR[rs][31], GPR[rs]} + {GPR[rt][31], GPR[rt]}
diff <- {GPR[rs][31], GPR[rs]} - {GPR[rt][31], GPR[rt]}
if (sum[32] == sum[31] && diff[32] == diff[31])
	PC <- PC + 4 + sign_ext(offset||00)
	GPR[31] <- PC + 4
else
	PC <- PC + 4
```

## 第三题

### 指令格式

`GSB`-`base`-`rt`-`offset`

I型访存类指令，机器码为`111010`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `111010` | `base` | `rt` | `offset` |

汇编形式：`gsb $t0, 4($t1)`

### 指令描述

Gray Store Byte

按`sw`的方式计算地址`addr`，其低两位`addr[1:0]`选出所在字中的一个字节通道，只修改该字节通道，其余三个字节保持不变。

定义`gray(x)`：输入一个字节，将其从高到低切成4个2位数，分别转换为对应的2位格雷码（`00→00`，`01→01`，`10→11`，`11→10`），再按原顺序拼回一个字节。例如`gray(11101110) = 10111011`。

设`m`为`addr`所在字中被选中的那个字节（原内存内容）。若`gray(GPR[rt])`的四个字节（分别对`GPR[rt]`的四个字节作`gray`）中**任意一个**等于`m`，则将`gray(GPR[rt]`中字节编号`addr[1:0]`的那个字节`)`写入被选中的字节通道；否则向被选中的字节通道写入`8'hFF`。

### RTL语言

```
addr  <- GPR[base] + sign_ext(offset)
b     <- addr[1:0]
word  <- memory[addr[31:2]]
m     <- word[8*b+7 : 8*b]
g3    <- gray(GPR[rt][31:24])
g2    <- gray(GPR[rt][23:16])
g1    <- gray(GPR[rt][15:8])
g0    <- gray(GPR[rt][7:0])
if (g3 == m || g2 == m || g1 == m || g0 == m)
	word[8*b+7 : 8*b] <- gray(GPR[rt][8*b+7 : 8*b])
else
	word[8*b+7 : 8*b] <- 8'hFF
memory[addr[31:2]] <- word
PC <- PC + 4
```
