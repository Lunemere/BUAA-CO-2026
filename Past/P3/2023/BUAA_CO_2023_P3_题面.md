## P3_L16_lboez_2023

| 编码         | 31 26                                                        | 25 21 | 20 16  | 15 0 |
| ------------ | ------------------------------------------------------------ | ----- | ------ | ---- |
| LBOEZ 111110 | base                                                         | rt    | offset |      |
| 6            | 5                                                            | 5     | 16     |      |
| 格式         | lboez rt, offset(base)                                       |       |        |      |
| 描述         | Addr  ←  GPR[base] + sign_extend(offset)，若memory[Addr]的对应**字节**数据的二进制1的个数等于0的个数，则将该**字节**符号扩展存入GPR[rt]，否则将0存入GPR[rt]。 |       |        |      |
| 操作         | Addr  ←  GPR[base] + sign_extend(offset)memword  ←  Memory[Addr]byte  ←  Addr1..0temp ← memword7+8*byte + memword7+8*byte-1 + ... + memword8*byteif temp == 4 thenGPR[rt]  ←  sign_extend(memword7+8*byte..8*byte)elseGPR[rt]  ←  0endif |       |        |      |
| 示例         | lboez $t0, 1($t1)                                            |       |        |      |
| 其他         | 注意：需要取出字中相应的字节，而非对整个字进行操作。         |       |        |      |

## P3_L15_bomez_2023

| 编码         | 31 26                                                        | 25 21 | 20 16  | 15 0 |
| ------------ | ------------------------------------------------------------ | ----- | ------ | ---- |
| BOMEZ 101100 | rs                                                           | rt    | offset |      |
| 6            | 5                                                            | 5     | 16     |      |
| 格式         | bomez rs, rt offset                                          |       |        |      |
| 描述         | GPR[rs] 和 GPR[rt] 用二进制表示后，如果GPR[rs]的1的数量和GPR[rt]的1的数量均不为0，且GPR[rs]的1的数量模GPR[rt]的1的数量等于0，则跳转。 |       |        |      |
| 操作         | a ← GPR[rs]31+GPR[rs]30+...+GPR[rs]0b ← GPR[rt]31+GPR[rt]30+...+GPR[rt]0if a != 0 && b != 0 && a % b == 0 thenPC ← PC + 4 + sign_extend(offset\|\|02)elsePC ← PC + 4endif |       |        |      |
| 示例         | bomez $t1, $t2, loop                                         |       |        |      |
| 其他         | 无                                                           |       |        |      |

# P3_L12_lsh_2023

## Load Selected Halfword

| 编码       | 31 26                                                        | 25 21 | 20 16  | 15 0 |
| ---------- | ------------------------------------------------------------ | ----- | ------ | ---- |
| lsh 101101 | base                                                         | rt    | offset |      |
| 6          | 5                                                            | 5     | 16     |      |
| 格式       | lsh rt, offset(base)                                         |       |        |      |
| 描述       | 将 vAddr 的计算改成 GPR[base] xor zero_ext(offset)，其中 xor 指按位异或。将 vAddr 的第 1 位作为半字选择位，第 0 位作为结果符号拓展和零拓展的选择位 |       |        |      |
| 操作       | vAddr ← GPR[base] xor zero_ext(offset)memWord ← Memory[vAddr & 0xfffffffc]byte ← vAddr1sel ← vAddr0if sel = 1'b0:GPR[rt] ← zero_ext(memWord15 + 16*byte..16*byte)else:GPR[rt] ← sign_ext(memWord15 + 16*byte..16*byte) |       |        |      |
| 示例       | lsh $t1, 100($t2)                                            |       |        |      |
| 其他       | 从指令操作可知，本指令中 vAddr 无需对齐                      |       |        |      |