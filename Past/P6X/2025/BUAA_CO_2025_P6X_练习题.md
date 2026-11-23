# BUAA CO 2025 P6X 练习题

在课下完成的 Verilog 流水线 MIPS CPU 上添加以下新指令，各题互相独立。

# P5

## 第一题：CCC

### 指令格式

R 型计算指令，`opcode` 为 `000000`，`funct` 为 `101001`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:11 | 10:6 | 5:0 |
| --- | --- | --- | --- | --- | --- | --- |
| 字段 | `special` | `rs` | `rt` | `rd` | `shamt` | `ccc` |
| 编码 | `000000` | `rs` | `rt` | `rd` | `00000` | `101001` |
| 位宽 | 6 | 5 | 5 | 5 | 5 | 6 |

汇编形式：`ccc rd, rs, rt`

### 指令描述

统计 `GPR[rs]` 的前导 `0` 个数与 `GPR[rt]` 的前导 `1` 个数。当 `GPR[rs]` 的前导 `0` 个数严格大于 `GPR[rt]` 的前导 `1` 个数时，将 `GPR[rs]` 的高 16 位与 `GPR[rt]` 的低 16 位拼接后写入 `GPR[rd]`；否则，将 `GPR[rt]` 的高 16 位与 `GPR[rs]` 的低 16 位拼接后写入 `GPR[rd]`。

### RTL语言

```text
def:
    count_leading_zeros(x): 从 x[31] 向低位连续 0 的个数（全 0 时为 32）
    count_leading_ones(x):  从 x[31] 向低位连续 1 的个数（全 1 时为 32）

temp1 <- count_leading_zeros(GPR[rs])
temp2 <- count_leading_ones(GPR[rt])
if (temp1 > temp2)
    GPR[rd] <- GPR[rs][31:16] || GPR[rt][15:0]
else
    GPR[rd] <- GPR[rt][31:16] || GPR[rs][15:0]
endif
```

## 第二题：CJOC

### 指令格式

I 型分支链接指令，`opcode` 为 `111100`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `cjoc` | `rs` | `rt` | `offset` |
| 编码 | `111100` | `rs` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`cjoc rs, rt, offset`

### 指令描述

计算 `ext_offset = sign_extend(offset || 00)`，取 `id = ext_offset[4:2]`（范围 `0 ~ 7`），从 `GPR[rs]` 中截取 8 位无符号数 `temp = GPR[rs][id+7 : id]`。当 `temp > 21` 时，将本条指令的 `PC + 8` 写入 `GPR[rt]`，并在执行延迟槽指令后跳转到 `PC + 4 + ext_offset`；否则，不写入 `GPR[rt]`、不跳转，并清空（作废）延迟槽指令。

### RTL语言

```text
I:
    ext_offset <- sign_extend(offset || 00)
    id         <- ext_offset[4:2]
    temp       <- GPR[rs][id+7 : id]
    Condition  <- (unsigned(temp) > 8'd21)
    target     <- PC + 4 + ext_offset
    if (Condition)
        GPR[rt] <- PC + 8
    endif

I+1:
    if (Condition)
        PC <- target
    else
        NullifyCurrentInstruction()
    endif
```

### 补充说明

`temp` 按 8 位无符号数与十进制 `21` 比较，`temp == 21` 时条件不成立。仅在条件成立时写入 `GPR[rt]`；当 `rs = rt` 且条件成立时，条件判断使用写回前的 `GPR[rs]` 旧值。

## 第三题：CCS

### 指令格式

I 型访存指令，`opcode` 为 `111111`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `ccs` | `base` | `rt` | `offset` |
| 编码 | `111111` | `base` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`ccs rt, offset(base)`

### 指令描述

从有效地址 `addr = GPR[base] + sign_extend(offset)` 加载一个 32 位字 `data`，分别统计其高 16 位与低 16 位中 `1` 的个数 `high_ones` 和 `low_ones`。若 `high_ones > low_ones`，则目的寄存器编号为 `31`；否则，目的寄存器编号为 `high_ones`。将 `data ^ GPR[rt]` 写入该目的寄存器。

### RTL语言

```text
def:
    count_ones(x): x 中 1 的个数

addr      <- GPR[base] + sign_extend(offset)
data      <- Memory[addr]
high_ones <- count_ones(data[31:16])
low_ones  <- count_ones(data[15:0])
if (high_ones > low_ones)
    dest_reg <- 31
else
    dest_reg <- high_ones
endif
GPR[dest_reg] <- data ^ GPR[rt]
```

### 补充说明

`high_ones <= low_ones` 时，`dest_reg` 取值范围为 `0 ~ 16`；当 `dest_reg = 0` 时，对 `$zero` 的写入被忽略。地址计算与按位异或均使用写回前的寄存器值。

## 第四题：DSC

### 指令格式

I 型计算指令，练习用 `opcode` 为 `011000`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `dsc` | `rs` | `rt` | `immediate` |
| 编码 | `011000` | `rs` | `rt` | `immediate` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`dsc rs, rt, immediate`

### 指令描述

取 `immediate[15:11]` 作为左移位数 `left_shift`，取 `immediate[4:0]` 作为右移位数 `right_shift`。将 `GPR[rt]` 逻辑左移 `left_shift` 位得到 `left_result`，将 `GPR[rt]` 算术右移 `right_shift` 位得到 `right_result`，再将两者按位异或的结果写入 `GPR[rs]`。

### RTL语言

```text
left_shift   <- immediate[15:11]
right_shift  <- immediate[4:0]
left_result  <- GPR[rt] << left_shift     // 逻辑左移
right_result <- GPR[rt] >>> right_shift   // 算术右移
result       <- left_result ^ right_result
GPR[rs]      <- result
```

### 补充说明

写入的目的寄存器为 `GPR[rs]`，源操作数为 `GPR[rt]`；`immediate[10:5]` 不参与运算。移位量均按 5 位无符号数处理。

## 第五题：BLOC

### 指令格式

I 型分支链接指令，练习用 `opcode` 为 `011001`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `bloc` | `rs` | `rt` | `offset` |
| 编码 | `011001` | `rs` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`bloc rs, rt, offset`

### 指令描述

统计 `GPR[rs]` 的前导 `1` 个数 `leading_ones`，取 `GPR[rt][5:0]` 作为 6 位无符号阈值 `threshold`。无论分支条件是否成立，均将本条指令的 `PC + 8` 写入 31 号寄存器。当 `leading_ones > threshold` 时，在执行延迟槽指令后跳转到 `PC + 4 + sign_extend(offset || 00)`；否则顺序执行。两种情况下均正常执行延迟槽指令。

### RTL语言

```text
def:
    count_leading_ones(x): 从 x[31] 向低位连续 1 的个数（全 1 时为 32）

I:
    leading_ones <- count_leading_ones(GPR[rs])
    threshold    <- GPR[rt][5:0]
    Condition    <- (leading_ones > unsigned(threshold))
    GPR[31]      <- PC + 8
    target       <- PC + 4 + sign_extend(offset || 00)

I+1:
    if (Condition)
        PC <- target
    endif
```

### 补充说明

`threshold` 取 `GPR[rt]` 的低 6 位（范围 `0 ~ 63`），当 `threshold >= 32` 时分支条件恒为假。当 `rs = 31` 或 `rt = 31` 时，条件判断使用链接写回前的 `GPR[31]` 旧值。

## 第六题：LHP

### 指令格式

I 型访存指令，练习用 `opcode` 为 `011010`。

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `lhp` | `rs` | `rt` | `offset` |
| 编码 | `011010` | `rs` | `rt` | `offset` |
| 位宽 | 6 | 5 | 5 | 16 |

汇编形式：`lhp rt, offset(rs)`

### 指令描述

计算有效地址 `addr = GPR[rs] + sign_extend(offset || 00)` 并从内存加载一个 32 位字 `data`，计算 `temp = GPR[rt] ^ data`。若 `temp` 的高 16 位等于低 16 位，则从第 31 位向低位查找 `temp` 中最高位 `1` 所在的位号作为目的寄存器编号 `dst`（若 `temp` 全为 `0`，则 `dst = 0`）；否则，令 `dst = 31`。最后将从内存读出的 `data` 写入 `GPR[dst]`。

### RTL语言

```text
addr <- GPR[rs] + sign_extend(offset || 00)
data <- Memory[addr]
temp <- GPR[rt] ^ data
if (temp[31:16] == temp[15:0])
    highest <- 31
    while (temp[highest] == 0 and highest > 0)
        highest <- highest - 1
    endwhile
    dst <- highest
else
    dst <- 31
endif
GPR[dst] <- data
```

### 补充说明

写入目的寄存器的是内存读出值 `data`，而非异或结果 `temp`。`offset` 在符号扩展前左移 2 位。当 `temp == 0` 时 `dst = 0`，对 `$zero` 的写入被忽略。
