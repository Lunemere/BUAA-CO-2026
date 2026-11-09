# BUAA CO 2026 P3 题面（二开）

在课下完成的 Logisim 单周期 MIPS CPU 上添加以下新指令，各题互相独立。

## 第一题

### 指令格式

`RBC`-`rs`-`rt`-`immediate`

I型计算类指令，机器码为`110111`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `110111` | `rs` | `rt` | `immediate` |
| 6 | 5 | 5 | 16 |

汇编形式：`rbc rt, rs, immediate`

示例：`rbc $t0, $t1, 5`

### 指令描述

将`GPR[rs]`循环右移`immediate[4:1]`位，得到`temp`。若`immediate[0]`为0，统计`temp`的前导0个数，写入`GPR[rt]`；若`immediate[0]`为1，统计`temp`中1的个数，写入`GPR[rt]`。

### RTL语言

```
n       ← immediate[4:1]
temp    ← rotate_right(GPR[rs], n)
if immediate[0] == 0 then
    GPR[rt] ← count_leading_zeros(temp)
else
    GPR[rt] ← count_ones(temp)
endif
```

### 其他

`rotate_right`对32位数据执行循环右移。移位量仅由`immediate[4:1]`决定，统计方式仅由`immediate[0]`决定。

## 第二题

### 指令格式

`BGTAL`-`rs`-`rt`-`offset`

I型跳转链接类指令，机器码为`011001`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `011001` | `rs` | `rt` | `offset` |
| 6 | 5 | 5 | 16 |

汇编形式：`bgtal rs, rt, offset`

示例：`bgtal $s0, $s1, 0x0010`

### 指令描述

将`GPR[rs]`与`GPR[rt]`按有符号数比较。若`GPR[rs] > GPR[rt]`，将当前`PC + 4`存入`GPR[31]`，并跳转到`PC + 4 + sign_extend(offset || 0^2)`；否则顺序执行，不写`GPR[31]`。

### RTL语言

```
if signed(GPR[rs]) > signed(GPR[rt]) then
    GPR[31] ← PC + 4
    PC ← PC + 4 + sign_extend(offset || 0^2)
else
    PC ← PC + 4
endif
```

### 其他

不考虑加法溢出；本指令无延迟槽。若示例指令位于`0x00400000`，且`$s0`的值大于`$s1`，则目标PC为`0x00400044`。

## 第三题

### 指令格式

`LABN`-`base`-`rt`-`offset`

I型访存、计算与跳转复合指令，机器码为`011011`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `011011` | `base` | `rt` | `offset` |
| 6 | 5 | 5 | 16 |

汇编形式：`labn rt, offset(base)`

示例：`labn $t0, 4($t1)`

### 指令描述

以`GPR[base] + sign_extend(offset)`为地址，从数据存储器读出一个字`memword`。将`memword`与原`GPR[rt]`相加，只保留结果的低32位，并写回`GPR[rt]`。若结果的第31位为1，则跳转到`PC + 4 + sign_extend(offset || 0^2)`；否则顺序执行。不考虑加法溢出。

### RTL语言

```
Addr    ← GPR[base] + sign_extend(offset)
memword ← Memory[Addr]
result  ← (memword + GPR[rt])[31:0]
GPR[rt] ← result
if result[31] == 1 then
    PC ← PC + 4 + sign_extend(offset || 0^2)
else
    PC ← PC + 4
endif
```

