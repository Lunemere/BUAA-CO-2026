这一年好像资料特别少，只能找到 verilog 的部分记忆

# Verilog

`localparam` 表示了局部常量参数，示例：

```verilog
localparam S_IDLE = 3'd0,
           S_C    = 3'd1;
```

它是有作用域的，只会在当前 `module` 中有效，适合状态机常量

<mark>注意</mark>：这个verilog程序并非人类所写，由GPT-6-Astra完成，并通过测试，但仍需注意代码的正确性