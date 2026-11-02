# BUAA CO 2026 P3 题面

在课下完成的 Logisim 单周期 MIPS CPU 上添加以下新指令，各题互相独立。

## 第一题

### 指令格式

`HAMDIST`-`rs`-`rt`-`rd`

R型计算类指令，机器码为`000000`，功能码为`111101`

| 31:26 | 25:21 | 20:16 | 15:11 | 10:6 | 5:0 |
| --- | --- | --- | --- | --- | --- |
| `000000` | `rs` | `rt` | `rd` | `00000` | `111101` |
| 6 | 5 | 5 | 5 | 5 | 6 |

汇编形式：`hamdist rd, rs, rt`

示例：`hamdist $t0, $t1, $t2`

### 指令描述

将 `GPR[rs]` 与 `GPR[rt]` 按位异或，统计异或结果的二进制表示中 1 的个数，将该个数存入 `GPR[rd]`。

### RTL语言

```
temp    ← GPR[rs] xor GPR[rt]
count   ← temp[31] + temp[30] + ... + temp[0]
GPR[rd] ← count
```

## 第二题

### 指令格式

`LCBEQ`-`rs`-`rt`-`offset`

I型跳转类指令，机器码为`111110`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `111110` | `rs` | `rt` | `offset` |
| 6 | 5 | 5 | 16 |

汇编形式：`lcbeq rs, rt, offset`

示例：`lcbeq $t1, $t2, loop`

### 指令描述

以 `GPR[rs] + sign_extend(offset || 0^2)` 为地址从数据存储器中读出一个字，若该字与 `GPR[rt]` 相等，则跳转到 `PC + 4 + sign_extend(offset || 0^2)`；否则顺序执行。

### RTL语言

```
Addr    ← GPR[rs] + sign_extend(offset || 0^2)
memword ← Memory[Addr]
if memword == GPR[rt] then
    PC ← PC + 4 + sign_extend(offset || 0^2)
else
    PC ← PC + 4
endif
```

### 其他

保证 `Addr` 4 字节对齐。地址计算与跳转目标计算使用同一个 `offset`。

## 第三题

### 指令格式

`LWJZ`-`rs`-`rt`-`rd`

R型访存类指令+跳转类指令，机器码为`000000`，功能码为`111111`

| 31:26 | 25:21 | 20:16 | 15:11 | 10:6 | 5:0 |
| --- | --- | --- | --- | --- | --- |
| `000000` | `rs` | `rt` | `rd` | `00000` | `111111` |
| 6 | 5 | 5 | 5 | 5 | 6 |

汇编形式：`lwjz rd, rs, rt`

示例：`lwjz $t0, $t1, $t2`

### 指令描述

以 `GPR[rs] + GPR[rt]` 为地址从数据存储器中读出一个字 `temp`。若 `temp` 等于 0，则跳转到 `GPR[rd]` 所指地址，且不写寄存器；否则将 `temp` 存入 `GPR[rd]`，并顺序执行。

### RTL语言

```
Addr ← GPR[rs] + GPR[rt]
temp ← Memory[Addr]
if temp == 0 then
    PC ← GPR[rd]
else
    GPR[rd] ← temp
    PC ← PC + 4
endif
```

### 其他

保证 `Addr` 4 字节对齐；保证跳转时 `GPR[rd]` 是合法的指令地址（4 字节对齐且位于指令存储器范围内）。
