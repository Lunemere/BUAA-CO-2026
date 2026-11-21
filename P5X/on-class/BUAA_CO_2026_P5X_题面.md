# BUAA CO 2026 P5X

## 第一题 SWEP

### 指令格式

I型存储类指令，操作码为 `101100`。

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `101100` | `base` | `rt` | `offset` |

汇编形式：`swep rt, offset(base)`

### 指令描述

将 `GPR[base]` 与符号扩展后的 `offset` 相加，得到有效地址 `vAddr`。将 `GPR[rt]` 从高位到低位分为四个8位数 `a`、`b`、`c`、`d`。

若 `unsigned(a) * unsigned(d) == unsigned(b) * unsigned(c)`，则将 `GPR[rt]` 的32位数据写入 `Memory[vAddr]`；否则触发 Trap 异常，`ExcCode = 5'd22`。

无论乘积等式是否成立，均优先检查 AdES 异常。若发生 AdES，则触发 AdES 异常，也不触发本指令的 Trap 异常。

### RTL语言

```
vAddr <- GPR[base] + sign_extend(offset)
temp <- GPR[rt]
a <- temp[31:24]
b <- temp[23:16]
c <- temp[15:8]
d <- temp[7:0]
if unsigned(a) * unsigned(d) == unsigned(b) * unsigned(c)
    Memory[vAddr] <- temp
else
    Signal Exception(Trap)    // ExcCode = 5'd22
endif
```

## 第二题 BHSE

### 指令格式

I型分支类指令，操作码为 `011010`。

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `011010` | `rs` | `rt` | `offset` |

汇编形式：`bhse rs, rt, offset`

### 指令描述

将 `GPR[rs]` 的高、低16位交换，得到 `temp`。若 `temp` 等于 `GPR[rt]`，则分支目标地址为 `PC + 4 + sign_extend(offset || 00)`；否则触发 Trap 异常，`ExcCode = 5'd20`。

### RTL语言

```
temp <- GPR[rs][15:0] || GPR[rs][31:16]
if temp == GPR[rt]
    target <- PC + 4 + sign_extend(offset || 00)
else
    SignalException(Trap)    // ExcCode = 5'd20
endif
```