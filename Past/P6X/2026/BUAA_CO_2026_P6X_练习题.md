# BUAA CO 2026 P6 题面

## 第一题：REVCLZ

### 指令格式

I 型计算指令，练习用 `opcode` 为 `011000`；`revclz rs, rt, imm16`

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `opcode` | `rs` | `rt` | `imm16` |

### 指令描述

当立即数最低位为 0 时，将 `GPR[rs]` 的 32 个二进制位按相反顺序写入 `GPR[rt]`。当最低位为 1 时，统计 `GPR[rt]` 原值的前导零个数，并将计数写回 `GPR[rt]`。全零字的前导零个数为 32。

### RTL语言

```text
if imm16[0] == 0
    for i = 0 to 31
        result[i] <- GPR[rs][31-i]
    endfor
    GPR[rt] <- result
else
    GPR[rt] <- clz32(GPR[rt])
endif
```

## 第二题：BGEAL

### 指令格式

I 型分支指令，练习用 `opcode` 为 `011001`。 `bgeal rs, rt, imm16`

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `opcode` | `rs` | `rt` | `imm16` |

### 指令描述

设本条指令的地址为 `PC`。将两个寄存器的值按有符号数比较，若 `GPR[rs] >= GPR[rt]`，则将 `PC + 8` 写入 31 号寄存器。执行延迟槽后，条件成立时跳转到 `PC + 4 + sign_extend(imm16)`，条件不成立时跳转到 `PC + 4`。

### RTL语言

```text
target <- PC + 4 + sign_extend(imm16 <<)
Condition <- signed(GPR[rs]) >= signed(GPR[rt])
fallthrough <- PC + 4
if Condition
	GPR[31] <- PC + 8
	PC <- target
else
	PC <- fallthrough
endif
```

## 第三题：LWDX

### 指令格式

I 型访存指令，练习用 `opcode` 为 `011010`。`lwdx base, idx, offset`

| 位段 | 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- | --- |
| 字段 | `opcode` | `base` | `idx` | `offset` |

### 指令描述

将 `GPR[base]` 加上符号扩展后的偏移量，得到有效地址。从该地址所在的对齐字读取 32 位数据。将有效地址的第 6 至 2 位与数据的低 5 位异或，结果与 `0x1E` 按位与，再加上指令字段 `idx` 的值。取和的低 5 位作为目的寄存器编号，将读出的整个字写入该寄存器。

### RTL语言

```text
vaddr <- GPR[base] + sign_extend(offset)
paddr <- vaddr[31:2] || 00
memword <- Memory[paddr]
target <- (((vaddr[6:2] ^ memword[4:0]) & 0x1E) + idx) mod 32
GPR[target] <- memword
```
