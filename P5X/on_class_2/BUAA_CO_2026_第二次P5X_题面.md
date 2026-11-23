# BUAA CO 2026 第二次 P5X

## 第一题 TFSW（Try to Fix in Save Word）

### 编码

| 31:26    | 25:21  | 20:16 | 15:0     |
| -------- | ------ | ----- | -------- |
| `110100` | `base` | `rt`  | `offset` |

### 格式

`tfsw rt, offset(base)`

### 描述

将 `GPR[base]` 与符号扩展后的 16 位 `offset` 相加，得到有效地址 `vAddr`。若 `vAddr` 没对齐，即最低两位 `vAddr[1:0]` 不为 `2'b00`，则计算 `temp = ~(vAddr[1] & vAddr[0])`，并将 `vAddr[1]` 与 `vAddr[2]` 均赋值为 `temp`。随后再次判断 `vAddr` 是否对齐，即 `vAddr[1:0]` 是否为 `2'b00`：若成立，则将 `GPR[rt]` 的数据写入 `Memory[vAddr]`；否则触发 `AddressError`（AdES）异常，`ExcCode = 5'd5`。

### 操作

```
vAddr <- GPR[base] + sign_ext(offset)
if vAddr[1..0] != 2'b0 then
    temp <- ~(vAddr[1] & vAddr[0])
    vAddr[1] <- temp
    vAddr[0] <- temp
endif
if vAddr[1..0] = 2'b0 then
    Memory[vAddr] <- GPR[rt]
else
    SignalException(AddressError)    // AdES, ExcCode = 5'd5
endif
```

### 示例

`tfsw $t0, 2($s0)`

---

## 第二题 BMAO（Branch on Multiplication Add Overflow）

### 编码

| 31:26    | 25:21 | 20:16 | 15:0     |
| -------- | ----- | ----- | -------- |
| `011011` | `rs`  | `rt`  | `offset` |

### 格式

`bmao rs, rt, offset`

### 描述

将 `GPR[rs]` 与 `GPR[rt]` 相乘得到 64 位结果 `temp`，分别取其高 32 位 `hi` 和低 32 位 `lo`，将两者相加。若未发生有符号加法溢出（即 `result[32] == result[31]`），则跳转到 `PC + 4 + sign_ext(offset || 00)`；否则触发 `Trap` 异常，`ExcCode = 5'd20`。

### 操作

```
temp <- GPR[rs] * GPR[rt]
hi <- temp[63..32]
lo <- temp[31..0]
result <- (hi[31] || hi) + (lo[31] || lo)
if result[32] == result[31] then
    PC <- PC + 4 + sign_ext(offset || 0^2)
else
    SignalException(Trap)    // ExcCode = 5'd20
endif
```

### 示例

`bmao $t1, $t2, label`
