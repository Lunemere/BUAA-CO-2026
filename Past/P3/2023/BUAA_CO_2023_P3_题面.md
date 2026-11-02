# BUAA CO 2023 P3 题面

在课下完成的 Logisim 单周期 MIPS CPU 上添加以下新指令，各题互相独立。

## P3_L16_lboez_2023

### 指令格式

`LBOEZ`-`base`-`rt`-`offset`

I型访存类指令，机器码为`111110`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `111110` | `base` | `rt` | `offset` |
| 6 | 5 | 5 | 16 |

汇编形式：`lboez rt, offset(base)`

示例：`lboez $t0, 1($t1)`

### 指令描述

`Addr ← GPR[base] + sign_extend(offset)`。若 `memory[Addr]` 对应**字节**的二进制表示中 1 的个数等于 0 的个数（即 8 位中恰有 4 个 1），则将该**字节**符号扩展后存入 `GPR[rt]`，否则将 0 存入 `GPR[rt]`。

### RTL语言

```
Addr    ← GPR[base] + sign_extend(offset)
memword ← Memory[Addr]
byte    ← Addr[1:0]
temp    ← memword[7+8*byte] + memword[6+8*byte] + ... + memword[8*byte]
if temp == 4 then
    GPR[rt] ← sign_extend(memword[7+8*byte : 8*byte])
else
    GPR[rt] ← 0
endif
```

### 其他

注意：需要取出字中相应的字节，而非对整个字进行操作。

## P3_L15_bomez_2023

### 指令格式

`BOMEZ`-`rs`-`rt`-`offset`

I型跳转类指令，机器码为`101100`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `101100` | `rs` | `rt` | `offset` |
| 6 | 5 | 5 | 16 |

汇编形式：`bomez rs, rt, offset`

示例：`bomez $t1, $t2, loop`

### 指令描述

将 `GPR[rs]` 和 `GPR[rt]` 用二进制表示，若 `GPR[rs]` 中 1 的个数与 `GPR[rt]` 中 1 的个数均不为 0，且 `GPR[rs]` 中 1 的个数模 `GPR[rt]` 中 1 的个数等于 0，则跳转；否则顺序执行。

### RTL语言

```
a ← GPR[rs][31] + GPR[rs][30] + ... + GPR[rs][0]
b ← GPR[rt][31] + GPR[rt][30] + ... + GPR[rt][0]
if a != 0 && b != 0 && a % b == 0 then
    PC ← PC + 4 + sign_extend(offset || 0^2)
else
    PC ← PC + 4
endif
```

## P3_L12_lsh_2023

Load Selected Halfword

### 指令格式

`LSH`-`base`-`rt`-`offset`

I型访存类指令，机器码为`101101`

| 31:26 | 25:21 | 20:16 | 15:0 |
| --- | --- | --- | --- |
| `101101` | `base` | `rt` | `offset` |
| 6 | 5 | 5 | 16 |

汇编形式：`lsh rt, offset(base)`

示例：`lsh $t1, 100($t2)`

### 指令描述

将 vAddr 的计算改为 `GPR[base] xor zero_ext(offset)`，其中 xor 指按位异或。以 vAddr 的第 1 位作为半字选择位，第 0 位作为结果符号扩展/零扩展的选择位（0 为零扩展，1 为符号扩展）。

### RTL语言

```
vAddr   ← GPR[base] xor zero_ext(offset)
memWord ← Memory[vAddr & 0xfffffffc]
byte    ← vAddr[1]
sel     ← vAddr[0]
if sel == 1'b0 then
    GPR[rt] ← zero_ext(memWord[15+16*byte : 16*byte])
else
    GPR[rt] ← sign_ext(memWord[15+16*byte : 16*byte])
endif
```

### 其他

从指令操作可知，本指令中 vAddr 无需对齐。
