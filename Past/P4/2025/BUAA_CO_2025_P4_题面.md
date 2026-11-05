## 第一题

### 指令描述

`spe`-`rs`-`rt`-`rd`-`zero`-`brc`(brc = 101001)

`special` `$rs` `$rt` `$rd` 0 `funct` 

000000 5位寄存器地址 5位寄存器地址 5位寄存器地址 00000 101001

R型指令

### RTL语言

```
temp <- GPR[rs][4:0]
if temp < 25 && count_ones(GPR[rt][temp+7:temp]) mod 2 == 0
	GPR[rd] <- reverse(GPR[rt])
else
	GPR[rd] <- GPR[rt]
```

## 第二题

### 指令描述

`CABC`-`rs`-`rt`-`offset`（CABC = 111100）

`opcode` `$rs` `$rt` `offset` 

111100 5位寄存器地址 5位寄存器地址 16位立即数

I型指令

### RTL语言

```
cross1 <- GPR[rs][23:16]||GPR[rt][7:0]||GPR[rs][31:24]||GPR[rt][15:8]
cross2 <- GPR[rt][7:0]||GPR[rs][23:16]||GPR[rt][31:24]||GPR[rs][15:8]
xor_result <- cross1 ^ cross2
cnt1 = count_zero(xor_result[31:16])
cnt2 = count_zero(xor_result[15:0])
if cnt1 == cnt2
	PC <- PC + 4 + (sign_ext(offset) << 2)
else
	GRF[rt] <- xor_result
```

## 第三题

### 指令描述

`LHBOC`-`rs(base)`-`rt`-`offset`（LHBOC=101101）

### RTL语言

```
vAddr <- GPR[rs] + sign_ext(offset)
pAddr <- vAddr[31:2]||00
memword <- Memory[pAddr]
temp1 <- count_ones(memword[15:0])
temp2 <- count_ones(memword[31:16])
if temp1 >= temp2
	GPR[rt] <- sign_ext(memword[15:0])
else
	GPR[rt] <- sign_ext(memword[31:16])
```