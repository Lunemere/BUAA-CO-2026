# BUAA CO P6X 杂题整理

## 第一题：LBGET

### 指令格式

I 型访存指令，`opcode` 为 `110101`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `lbget` | `base` | `rt` | `offset` |
| 编码 | `110101` | `base` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`lbget rt, offset(base)`

### 指令描述

计算有效地址 `vAddr = GPR[base] + sign_extend(offset)`，取出该地址对应的 8 位字节数据。将该字节视为有符号数，如果大于或等于 `0`，则符号扩展为 32 位后存入 `GPR[rt]`；如果小于 `0`，则符号扩展为 32 位后存入 `GPR[base]`。

### RTL语言

```text
vAddr <- sign_extend(offset) + GPR[base]
pAddr <- vAddr[31:2] || 00
memword <- Memory[pAddr]
byte <- vAddr[1:0]
Condition <- (memword[7+8*byte] == 0)

if (Condition)
    GPR[rt] <- sign_extend(memword[7+8*byte : 8*byte])
else
    GPR[base] <- sign_extend(memword[7+8*byte : 8*byte])
endif
```

### 示例

```mips
lbget $t5, 8($s1)
```

## 第二题：LHOGEZ

### 指令格式

I 型访存指令，`opcode` 为 `110011`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `lhogez` | `base` | `rt` | `offset` |
| 编码 | `110011` | `base` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`lhogez rt, offset(base)`

### 指令描述

计算有效地址 `vAddr = GPR[base] + sign_extend(offset)`，取出该地址对应的 16 位半字。如果该半字中 1 的个数不少于 0 的个数，则将该半字符号扩展为 32 位后存入 `GPR[rt]`；否则，将 `PC + 4` 存入 31 号寄存器。

### RTL语言

```text
vAddr <- sign_extend(offset) + GPR[base]
pAddr <- vAddr[31:2] || 00
memword <- Memory[pAddr]
bit <- vAddr[1]

def:
    countOne(x): x 中 1 的个数
    countZero(x): x 中 0 的个数

memHalf <- memword[15+16*bit : 16*bit]
Condition <- (countZero(memHalf) <= countOne(memHalf))

if (Condition)
    GPR[rt] <- sign_extend(memHalf)
else
    GPR[31] <- PC + 4
endif
```

### 示例

```mips
lhogez $t5, 8($s1)
```

## 第三题：ADDEI

### 指令格式

I 型计算指令，`opcode` 为 `110011`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `addei` | `rs` | `rt` | `offset` |
| 编码 | `110011` | `rs` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`addei rt, rs, offset`

### 指令描述

将 16 位立即数的高位补 1，扩展为 32 位后与 `GPR[rs]` 进行有符号加法。如果未发生有符号溢出，则将相加得到的结果写入 `GPR[rt]`；如果发生溢出，则将高位补 1 扩展后的立即数写入 `GPR[rt]`。

### RTL语言

```text
def:
    one_extend(offset): 0xffff || offset[15:0]

imm <- one_extend(offset)
temp <- (imm[31] || imm[31:0]) + (GPR[rs][31] || GPR[rs][31:0])

if (temp[32] != temp[31])
    GPR[rt] <- imm
else
    GPR[rt] <- temp[31:0]
endif
```

### 示例

```mips
addei $t0, $t1, 1
```

## 第四题：BLZTAL

### 指令格式

I 型分支链接指令，`opcode` 为 `100111`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `blztal` | `rs` | `rt` | `offset` |
| 编码 | `100111` | `rs` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`blztal rs, rt, offset`

### 指令描述

将 `GPR[rs]` 视为 32 位有符号数。当其小于 `0` 时，以本条指令的 `PC + 4` 为基准，跳转 `sign_extend(offset) × 2^(GPR[rt][1:0])` 条指令的距离，并将本条指令的 `PC + 8` 存入 31 号寄存器。

仅在需要跳转时链接；条件不成立时不链接。该指令具有延迟槽。

### RTL语言

```text
I:
    target_offset <- sign_extend(offset || 0^(2+GPR[rt][1:0]))
    Condition <- (signed(GPR[rs]) < 0)

    if (Condition)
        GPR[31] <- PC + 8
    endif

I+1:
    if (Condition)
        PC <- PC + target_offset
    endif
```

### 示例

```mips
blztal $t0, $t1, 1
```

## 第五题：BONALL

### 指令格式

I 型分支链接指令，`opcode` 为 `011001`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `bonall` | `rs` | `rt` | `offset` |
| 编码 | `011001` | `rs` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`bonall rs, rt, offset`

### 指令描述

将本条指令的 `PC + 8` 存入 31 号寄存器。当 `GPR[rs]` 与 `GPR[rt]` 表示的 32 位有符号数互为相反数时，跳转到本条指令的 `PC + 4 + sign_extend(offset || 00)`，并执行延迟槽指令；否则，清空延迟槽指令。

`32'h8000_0000` 与 `32'h8000_0000` 不互为相反数。

### RTL语言

```text
I:
    target_offset <- sign_extend(offset || 00)
    Condition <- (GPR[rs] + GPR[rt] == 0^32)
                 and not (GPR[rs] == 0x80000000 and GPR[rt] == 0x80000000)
    GPR[31] <- PC + 8

I+1:
    if (Condition)
        PC <- PC + target_offset
    else
        NullifyCurrentInstruction()
    endif
```

### 示例

```mips
bonall $t0, $t1, label
```
