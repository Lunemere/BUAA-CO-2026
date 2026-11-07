# BUAA CO P4 杂题整理

## 第一题：BAO

### 指令格式

I 型分支指令，`opcode` 为 `101101`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `bao` | `rs` | `rt` | `offset` |
| 编码 | `101101` | `rs` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`bao rs, rt, offset`

### 指令描述

如果 `GPR[rs]` 和 `GPR[rt]` 相加发生有符号溢出，则分支。溢出判断参考 `add` 指令。

### RTL语言

```text
temp <- (GPR[rs][31] || GPR[rs]) + (GPR[rt][31] || GPR[rt])
if (temp[32] != temp[31])
    PC <- PC + 4 + sign_extend(offset || 00)
else
    PC <- PC + 4
endif
```

### 示例

```mips
bao $t1, $t2, label
```

### 其他

`temp` 是 33 位计算结果，`temp[32] != temp[31]` 表示计算结果溢出。

## 第二题：SB

### 指令格式

汇编形式：`sb rt, offset(base)`

编码及指令语义请参考中文或英文指令集中的 `sb` 指令。原版 MARS 支持该指令。

### 指令描述

添加 `sb` 指令，并按以下要求输出写内存信息。

### 输出要求

输出方式与 `sw` 保持一致：需要输出更新后整个字的内容，输出地址必须字对齐。

例如，地址 `0x00000000` 处原来的字为 `0x12345678`，寄存器 `$t0` 的值为 `0x0000ffff`。执行：

```mips
sb $t0, 1($0)
```

需要输出：

```text
*00000000 <= 0x1234ff78
```

## 第三题：TFTC

### 指令格式

R 型计算指令，`special` 为 `000000`，`funct` 为 `011101`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:11 | 10:6 | 5:0 |
| --- | --- | --- | --- | --- | --- | --- |
| 字段 | `special` | `rs` | 固定值 | `rd` | 固定值 | `TFTC` |
| 编码 | `000000` | `rs` | `00000` | `rd` | `00000` | `011101` |
| 位宽 | 6 | 5 | 5 | 5 | 5 | 6 |

汇编形式：`tftc rd, rs`

### 指令描述

`GPR[rs]` 是用原码表示的 32 位有符号数，将其转换成补码后存入 `GPR[rd]`。

### RTL语言

```text
def:
    f(x): 将 x 由原码形式转换为补码形式

GPR[rd] <- f(GPR[rs])
```

### 示例

```mips
tftc $t1, $t2
```

### 其他

`GPR[rs]` 为 `+0` 或 `-0` 时，转换成补码后都应为 `0`。

## 第四题：LBOEZ

### 指令格式

I 型访存指令，`opcode` 为 `111110`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `LBOEZ` | `base` | `rt` | `offset` |
| 编码 | `111110` | `base` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`lboez rt, offset(base)`

### 指令描述

计算地址 `Addr = GPR[base] + sign_extend(offset)`。若该地址对应字节的二进制表示中，1 的个数等于 0 的个数，则将该字节符号扩展后存入 `GPR[rt]`；否则将 `0` 存入 `GPR[rt]`。

### RTL语言

```text
vaddr <- GPR[base] + sign_extend(offset)
paddr <- vaddr[31:2] || 00
memword <- Memory[paddr]
byte <- vaddr[1:0]
temp <- memword[7+8*byte] + memword[6+8*byte] + ... + memword[8*byte]

if (temp == 4)
    GPR[rt] <- sign_extend(memword[7+8*byte : 8*byte])
else
    GPR[rt] <- 0
endif
```

### 示例

```mips
lboez $t0, 1($t1)
```

### 其他

需要取出字中相应的字节，而非对整个字进行操作。RTL 中 `temp` 是所选字节各位数值之和，即该字节中 1 的个数。

## 第五题：BNEZALC

### 指令格式

I 型分支链接指令，`regimm` 为 `000001`，`rt` 字段固定为 `10011`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `regimm` | `rs` | `BNEZALC` | `offset` |
| 编码 | `000001` | `rs` | `10011` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`bnezalc rs, offset`

### 指令描述

如果 `GPR[rs]` 不等于 `0`，则跳转到目标地址，并将执行该指令时的 `PC + 4` 存入 31 号寄存器；否则顺序执行。

### RTL语言

```text
if (GPR[rs] != 0)
    PC <- PC + 4 + sign_extend(offset || 00)
    GPR[31] <- PC + 4
else
    PC <- PC + 4
endif
```

### 示例

```mips
bnezalc $t0, label
```

### 其他

不考虑延迟槽。

## 第六题：SSZE

### 指令格式

R 型计算指令，`SPECIAL` 为 `000000`，`funct` 为 `001111`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:11 | 10:6 | 5:0 |
| --- | --- | --- | --- | --- | --- | --- |
| 字段 | `SPECIAL` | `rs` | `rt` | `rd` | 固定值 | `SSZE` |
| 编码 | `000000` | `rs` | `rt` | `rd` | `00000` | `001111` |
| 位宽 | 6 | 5 | 5 | 5 | 5 | 6 |

汇编形式：`ssze rd, rs, rt`

### 指令描述

当 `GPR[rs]` 和 `GPR[rt]` 的二进制后缀 0 的个数相同时，将 `GPR[rd]` 置 `1`；否则置 `0`。

### RTL语言

```text
def:
    count_suffix_zeros(x): 返回 x 后缀 0 的个数

temp1 <- count_suffix_zeros(GPR[rs])
temp2 <- count_suffix_zeros(GPR[rt])
GPR[rd] <- (temp1 == temp2) ? (0^31 || 1) : 0^32
```

### 示例

```mips
ssze $t0, $t1, $t2
```

### 其他

无。

## 第七题：LWRR

### 指令格式

I 型访存指令，`opcode` 为 `110100`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `LWRR` | `base` | `rt` | `offset` |
| 编码 | `110100` | `base` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`lwrr rt, offset(base)`

### 指令描述

计算地址 `vAddr = GPR[base] + sign_extend(offset)`，读取该地址所在的字，将读出的字循环右移 `vAddr[1:0]` 个字节后存入 `GPR[rt]`。

### RTL语言

```text
vAddr <- GPR[base] + sign_extend(offset)
pAddr <- vAddr[31:2] || 00
memword <- Memory[pAddr]
byte <- vAddr[1:0]

if (byte == 0)
    GPR[rt] <- memword
else
    GPR[rt] <- memword[8*byte-1:0] || memword[31:8*byte]
endif
```

### 示例

```mips
lwrr $s0, 3($0)
```

### 其他

地址不对齐时强制对齐，指令表现以 `.class` 指令扩展在 MARS 中的行为为准。
