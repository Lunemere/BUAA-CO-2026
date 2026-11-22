# BUAA CO 2024 P6X 重建题面

在课下完成的 Verilog 流水线 MIPS CPU 上添加以下新指令（整理自 2024 年 P5/P6 上机题），各题互相独立。

# P5

## 第一题：ADDOI

### 指令格式

I 型计算指令，`opcode` 为 `111110`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `addoi` | `rs` | `rt` | `imm` |
| 编码 | `111110` | `rs` | `rt` | `imm` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`addoi rt, rs, imm`

### 指令描述

将 16 位立即数符号扩展后与 `GPR[rs]` 相加并取低 32 位（按补码解释），将该和的相反数转换为 32 位原码（1 位符号位 + 31 位幅值）后写入 `GPR[rt]`。

### RTL语言

```text
temp <- GPR[rs] + sign_extend(imm)
sum  <- temp[31:0]
if (signed(sum) > 0)
    GPR[rt] <- 1 || sum[30:0]
else
    magnitude <- -sum
    GPR[rt]   <- 0 || magnitude[30:0]
endif
```

### 补充说明

- 加法先取低 32 位回绕，再按 32 位补码解释，溢出不触发异常。
- 输入保证回绕后的 `sum != 0x80000000`，确保其相反数可用 1 位符号 + 31 位幅值表示。
- `sum == 0` 时写入唯一的正零 `0x00000000`；`sum > 0` 时相反数符号位为 1、幅值为 `sum`；`sum < 0` 时符号位为 0、幅值为 `|sum|`。

## 第二题：AE

### 指令格式

I 型计算指令（`20:16` 固定为 `00000`）。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `OpCode` | `rs` | 固定值 | `imm` |
| 编码 | ``111110`` | `rs` | `00000` | `imm` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`ae rs, imm`

### 指令描述

将 16 位立即数放入结果的低 16 位。结果的第 16 位等于立即数最低位（即 `imm[0] ^ 0`），其余高位依次为立即数当前位与前一位的异或。将 32 位结果写入 `GPR[rs]`。

### RTL语言

```text
temp[15:0] <- imm[15:0]
temp[16]   <- imm[0] ^ 0
for i = 1 to 15
    temp[16+i] <- imm[i] ^ imm[i-1]
endfor
GPR[rs] <- temp
```

### 补充说明

立即数按 16 位位串使用，不先作符号扩展；`GPR[rs]` 的旧值不参与运算。例如 `imm = 0xFFFF` 时，结果为 `0x0001FFFF`。

## 第三题：XE

### 指令格式

R 型计算指令，`opcode` 为 `000000`，`funct` 为 `101000`，`10:6` 位不参与计算。

| 位段 | 31:26 | 25:21 | 20:16 | 15:11 | 10:6 | 5:0 |
| --- | --- | --- | --- | --- | --- | --- |
| 字段 | `special` | `rs` | `rt` | `rd` | 忽略 | `xe` |
| 编码 | `000000` | `rs` | `rt` | `rd` | `xxxxx` | `101000` |
| 位宽 | 6 | 5 | 5 | 5 | 5 | 6 |

汇编形式：`xe rd, rs, rt`

### 指令描述

将 `GPR[rs]` 与 `GPR[rt]` 均按低位到高位划分为 16 个 2 位组，依次取每组的高位（即奇数位 `2*i+1`）作按位异或，按原组序压缩放入结果的低 16 位，高 16 位补 0，写入 `GPR[rd]`。

### RTL语言

```text
result <- 0^32
for i = 0 to 15
    result[i] <- GPR[rs][2*i+1] ^ GPR[rt][2*i+1]
endfor
GPR[rd] <- result
```

### 补充说明

源操作数均取写回前的 32 位值，结果零扩展到 32 位写入 `GPR[rd]`；位 `10:6` 不参与计算。

## 第四题：BMOAL

### 指令格式

I 型分支链接指令，`opcode` 为 `011110`，`20:16` 固定为 `00000`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `bmoal` | `rs` | 固定值 | `offset` |
| 编码 | `011110` | `rs` | `00000` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`bmoal rs, offset`

### 指令描述

统计 `GPR[rs]` 的 32 位中 1 与 0 的数量。仅当 1 的数量严格大于 0 的数量时进行相对分支，并将本条指令的 `PC + 8` 写入 31 号寄存器；否则不分支、不链接。延迟槽指令在两种情况下均执行。

### RTL语言

```text
I:
    count <- 0
    for i = 0 to 31
        if (GPR[rs][i] == 1)
            count <- count + 1
        endif
    endfor
    Condition     <- (count > 16)
    target_offset <- sign_extend(offset || 00)
    if (Condition)
        GPR[31] <- PC + 8
    endif

I+1:
    if (Condition)
        PC <- PC + target_offset
    endif
```

### 补充说明

至少有 17 个 1 时分支并链接。符号位参与计数。

## 第五题：JTL

### 指令格式

I 型跳转指令，`opcode` 为 `011101`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `jtl` | `rs` | `rt` | `offset` |
| 编码 | `011101` | `rs` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`jtl rs, rt, label`

### 指令描述

分别计算候选地址 `A = (GPR[rs] + GPR[rt])[31:0]` 与 `B = (PC + 4 + sign_extend(offset || 00))[31:0]`，按 32 位无符号数比较：若 `A > B`，则跳转到 `B`；否则跳转到 `A`。无论选择哪条路径，均清空（作废）延迟槽指令，且不写任何通用寄存器。

### RTL语言

```text
I:
    temp <- GPR[rs] + GPR[rt]
    A    <- temp[31:0]
    temp <- PC + 4 + sign_extend(offset || 00)
    B    <- temp[31:0]
    if (unsigned(A) > unsigned(B))
        target <- B
    else
        target <- A
    endif

I+1:
    NullifyCurrentInstruction()
    PC <- target
```

### 补充说明

- 两个候选地址均先取低 32 位回绕，再按无符号数比较；`offset` 为 16 位补码字偏移。
- 无论是否相等或选择哪条路径，均作废紧随本指令的一条延迟槽指令，不链接也不写通用寄存器。
- 输入保证最终目标字对齐且位于指令区内。

## 第六题：LWOC

### 指令格式

I 型访存指令，`opcode` 为 `111110`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `lwoc` | `base` | `rt` | `offset` |
| 编码 | `111110` | `base` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`lwoc rt, offset(base)`

### 指令描述

将 16 位 `offset` 末尾补两位 0 后符号扩展，与 `GPR[base]` 相加，取结果高 30 位（字对齐地址）读取内存字。若读出字按无符号数解释严格小于 `0x80000000`，则写入该字低 4 位指定的寄存器（`0..15`）；否则写入 `GPR[rt]`。两种情况写回的数据均为完整读出字。

### RTL语言

```text
vAddr   <- GPR[base] + sign_extend(offset || 00)
memword <- Memory[vAddr[31:2] || 00]
if (unsigned(memword) < 0x80000000)
    mem_reg <- 0 || memword[3:0]
else
    mem_reg <- rt
endif
GPR[mem_reg] <- memword
```

### 补充说明

读出字等于 `0x80000000` 时写入 `GPR[rt]`；当目的寄存器编号为 0 时丢弃写入；`offset` 为 1 时对有效地址的贡献为 4。
