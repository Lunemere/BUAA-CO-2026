# BUAA CO 2026 P4

在课下完成的 Verilog 单周期 MIPS CPU 上添加以下新指令，各题互相独立。

## 第一题

### 指令格式

`NIBSRT`-`rd`-`rs`-`rt`

R型计算类指令，`special`为`000000`，`funct`为`001110`。

| 31:26 | 25:21 | 20:16 | 15:11 | 10:6 | 5:0 |
| --- | --- | --- | --- | --- | --- |
| `000000` | `rs` | `rt` | `rd` | `00000` | `001110` |

汇编形式：`nibsrt $s1, $s2, $s3`

### 指令描述

将`GPR[rs]`从高位到低位切成8个4位块，按无符号数比较各块。令`p = count_ones(GPR[rt]) mod 2`。若`p = 0`，将这些块按降序排列；若`p = 1`，按升序排列。排序后依次从高位到低位拼成32位结果，存入`GPR[rd]`。

### RTL语言

```
for (i = 0; i < 8; i++)
    block[i] <- GPR[rs][4*i+3:4*i]
p <- count_ones(GPR[rt]) mod 2
if (p == 0)
    sorted <- sort_descending(block)
else
    sorted <- sort_ascending(block)
GPR[rd] <- sorted[0] || sorted[1] || ... || sorted[7]
PC <- PC + 4
```

## 第二题

### 指令格式

`BLEZAL`-`rs`-`imm16`

I型跳转类指令，机器码为`011000`。口述未指定`rt`字段，此处按`00000`整理。

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `011000` | `rs` | `00000` | `imm16` |

汇编形式：`blezal $t1, 0xFE03`

### 指令描述

按有符号数比较`GPR[rs]`与0。若小于0，将`imm16[15:8]`作为8位有符号数符号扩展后左移2位，加到`PC + 4`上；若等于0，则对`imm16[7:0]`执行同样操作。这两种情况下均将原`PC + 4`存入`GPR[31]`。若大于0，仅顺序执行，不写`GPR[31]`。

### RTL语言

```
if (signed(GPR[rs]) < 0)
    GPR[31] <- PC + 4
    PC <- PC + 4 + (sign_ext(imm16[15:8]) << 2)
else if (GPR[rs] == 0)
    GPR[31] <- PC + 4
    PC <- PC + 4 + (sign_ext(imm16[7:0]) << 2)
else
    PC <- PC + 4
```

## 第三题

### 指令格式

`LWSEL`-`rs`-`rt`-`imm16`

I型访存类指令，机器码选为`101100`。

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `101100` | `rs` | `rt` | `imm16` |

汇编形式：`lwsel $t1, $t2, 4`

### 指令描述

直接以`sign_ext(imm16)`为地址，从Memory读出一个字，记为`memword`；地址不加`GPR[rs]`。若`memword[31] = 0`，则将`memword`写入`GPR[rs]`；若`memword[31] = 1`，则写入`GPR[rt]`。

### RTL语言

```
addr <- sign_ext(imm16)
memword <- Memory[addr]
if (memword[31] == 0)
    GPR[rs] <- memword
else
    GPR[rt] <- memword
PC <- PC + 4
```

