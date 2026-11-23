# BUAA CO 2026 P6X 题面

> 会考三道题，此处暂时不收录第二题（主要因为我室友 [Dsr](https://mikedsr.top/) 没有记录）推测和大类的 P5 第二场是相同的

## 第一题 ASBJ

### 指令格式

I 型分支类指令，操作码为 `110111`。

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `110111` | `rs` | `rt` | `imm16` |

汇编形式：`asbj rs, rt, imm16`

### 指令描述

设本条指令的地址为 `PC`，`offset = imm16`。取 `imm16` 的低 5 位作为移位量 `shamt`，将 `offset` 符号扩展为 32 位，得到 `limit`。将 `GRF[rs]` 算术右移 `shamt` 位，得到 32 位结果 `shifted`。算术右移时，高位填充原操作数的符号位。

将 `shifted` 与 `limit` 按 32 位有符号数比较：

- 若 `shifted < limit`，将 `shifted` 写入 `GRF[rt]`，执行延迟槽指令后，跳转至 `PC + 4 + (sign_extend(offset) << 2)`。
- 若 `shifted == limit`，不写通用寄存器，清空延迟槽，不执行位于 `PC + 4` 的指令，从 `PC + 8` 继续执行。
- 若 `shifted > limit`，将 `GRF[rs]` 左移 `shamt` 位的结果写入 `GRF[rt]`，执行延迟槽指令后，跳转至 `PC + 4 - (sign_extend(offset) << 2)`。左移时低位补零，结果保留低 32 位。

### RTL语言

```text
offset <- imm16
shamt <- imm16[4:0]
limit <- sign_extend_32(offset)
shifted <- arithmetic_right_shift_32(GRF[rs], shamt)
displacement <- limit << 2

if signed(shifted) < signed(limit)
    GRF[rt] <- shifted
    PC <- PC + 4 + displacement
else if signed(shifted) == signed(limit)
    清空延迟槽
    PC <- PC + 8
else
    GRF[rt] <- (GRF[rs] << shamt)
    PC <- PC + 4 - displacement
endif
```

## 第二题 LWDR

### 指令格式

I 型加载类指令，操作码为 `011011`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `opcode` | `rs` | `rt` | `imm16` |

汇编形式：`lwdr rt, imm16(rs)`

### 指令描述

将 `GRF[rs]` 与符号扩展为 32 位的 `imm16` 相加，得到有效地址 `vAddr`。从数据存储器中该地址处读取一个 32 位字，记为 `data`。

将指令中 `rt` 字段的无符号数值与 `data[4:0]` 的无符号数值相加，对和取模 16，再加 16，得到目的寄存器编号 `dest`。将完整的 32 位数据 `data` 写入 `GRF[dest]`。

其中，参与目的寄存器编号计算的是 `rt` 字段本身，而非 `GRF[rt]` 的内容；`dest` 的取值范围为 16～31。

### RTL语言

```text
vAddr <- GRF[rs] + sign_extend_32(imm16)
data <- Memory[vAddr]    // 读取一个 32 位字
dest <- (rt + data[4:0]) mod 16) + 16
GRF[dest] <- data
```
