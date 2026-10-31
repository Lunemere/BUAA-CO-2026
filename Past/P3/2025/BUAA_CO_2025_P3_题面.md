# BUAA CO 2025 P3

## 第一题

### 指令格式

`REVI`-`rs`-`rt`-`imm16`

I型计算类指令，机器码为`101101`

### 指令描述

将`rs`中数值高imm16位翻转置于低位，剩余位置不变置于高位，将结果存入`rt`中。（保证`imm16`严格小于32）

### RTL语言

```
temp <- GRR[rs]
result <- temp[31-imm16:0]||reverse(temp[31:32-imm16])
GPR[rt] <- result
```

## 第二题

### 指令格式

`BLZ`-`rs`-`rt`-`offset`

I型跳转类指令+I型计算类指令，机器码为`011000`

### 指令描述

比较`rs`、`rt`中数据先导零的个数，决定跳转方式与存储数据。

### RTL语言

```
temp1 <-count_leading_zeros(GPR[rs])
temp2 <-count_leading_zeros(GPR[rt])
if (temp1 == temp2) 
	PC <- PC + 4 + sign_ext(offset||00)
else if (temp1 > temp2)
	PC <- PC + 4
	rs <- temp1
else
	PC <- PC + 4
	rs <- temp2
```

## 第三题

### 指令格式

`LWF`-`base`-`rt`-`offset`

I型访存类指令，机器码为 `111011`

### 指令描述

Load Word with Filter

根据`filter`1的个数决定访存所得数据存入`rt`还是`(rt+1)mod32`中。

### RTL语言

```
vaddr <- GPR[base] + sign(offset)
paddr <- vaddr[31:2]||00
memword <- memory[paddr]
filter <- memword And GPR[rt]
ones <- count_ones(filter)
if (ones mod 2 == 0)
	GPR[rt] <- memword
else
	GPR[(rt+1)mod32] <- memword
```