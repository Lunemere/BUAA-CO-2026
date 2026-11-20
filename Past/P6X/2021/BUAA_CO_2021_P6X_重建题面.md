# BUAA CO 2021 P6X 重建题面

在课下完成的 Verilog 流水线 MIPS CPU 上添加以下新指令（整理自 2021 年 P5/P6 上机题），各题互相独立。

# P5

## 第一题：SWC

### 指令格式

R 型计算指令，`opcode` 为 `000000`，`funct` 为 `001010`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:11 | 10:6 | 5:0 |
| --- | --- | --- | --- | --- | --- | --- |
| 字段 | `special` | `rs` | `rt` | `rd` | `shamt` | `swc` |
| 编码 | `000000` | `rs` | `rt` | `rd` | `00000` | `001010` |
| 位宽 | 6 | 5 | 5 | 5 | 5 | 6 |

汇编形式：`swc rd, rs, rt`

### 指令描述

根据 `GPR[rt]` 二进制表示中 0 的个数的奇偶性，将 `GPR[rs]` 循环左移或循环右移后写入 `GPR[rd]`：含奇数个 0 时向左循环移位，含偶数个 0 时向右循环移位，移位量取 `GPR[rt]` 的低 5 位。当 `GPR[rt]` 整个值为 0 时不写回。

### RTL语言

```text
A <- GPR[rs]
B <- GPR[rt]
n <- B[4:0]
count <- 0
for i = 0 to 31
    if (B[i] == 0)
        count <- count + 1
    endif
endfor

if (B != 0)
    if (n == 0)
        GPR[rd] <- A
    else if (count mod 2 != 0)
        GPR[rd] <- A[31-n:0] || A[31:32-n]
    else
        GPR[rd] <- A[n-1:0] || A[31:n]
    endif
endif
```

### 补充说明

`GPR[rt]` 整个值为 0 与低 5 位为 0 不等价：前者不写回；后者在 `GPR[rt]` 非零时仍将 `GPR[rs]` 原样写入 `GPR[rd]`。

## 第二题：BEZAL

### 指令格式

R 型跳转链接指令，`opcode` 为 `000000`，`funct` 为 `110001`（位 `15:11` 忽略）。

| 位段 | 31:26 | 25:21 | 20:16 | 15:11 | 10:6 | 5:0 |
| --- | --- | --- | --- | --- | --- | --- |
| 字段 | `special` | `rs` | `rt` | 忽略 | `shamt` | `bezal` |
| 编码 | `000000` | `rs` | `rt` | `xxxxx` | `00000` | `110001` |
| 位宽 | 6 | 5 | 5 | 5 | 5 | 6 |

汇编形式：`bezal rs, rt`

### 指令描述

当 `GPR[rt]` 为 0 时，将本条指令的 `PC + 8` 写入 31 号寄存器，并在执行延迟槽指令后跳转到 `GPR[rs]` 指定的地址；否则不跳转、不链接。两种情况下均正常执行延迟槽指令。

### RTL语言

```text
I:
    target    <- GPR[rs]
    Condition <- (GPR[rt] == 0)
    if (Condition)
        GPR[31] <- PC + 8
    endif

I+1:
    if (Condition)
        PC <- target
    endif
```

### 补充说明

当 `rs = 31` 时，跳转目标取链接写回前的 `GPR[31]` 旧值。

## 第三题：LWMX

### 指令格式

I 型访存指令，`opcode` 为 `101010`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `OpCode` | `base` | `rt` | `offset` |
| 编码 | `101010` | `base` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`lwmx rt, offset(base)`

### 指令描述

从有效地址 `GPR[base] + sign_extend(offset)` 加载一个 32 位字。将e加载字与写回前的 `GPR[rt]` 按 32 位有符号补码比较：若加载字严格大于 `GPR[rt]`，则将加载字写入 5 号寄存器；否则写入 4 号寄存器。

### RTL语言

```text
vAddr   <- GPR[base] + sign_extend(offset)
memword <- Memory[vAddr]
if (signed(memword) > signed(GPR[rt]))
    GPR[5] <- memword
else
    GPR[4] <- memword
endif
```

### 补充说明

加载字与 `GPR[rt]` 相等时写入 4 号寄存器；未被选中的另一个目的寄存器保持不变。
