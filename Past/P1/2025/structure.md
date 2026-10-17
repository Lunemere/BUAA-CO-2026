valid 寄存器，存储该json序列是否有效

pair_num 存储当前json键值对的数目

max_num 存储历史输入的json序列的键值对的最大数



IDLE: 未输入 `{` 或者是空格

INPUT_FORE_BRACKET: 输入了 `{`

INPUT_BACK_BRACKET: 输入了 `{`

KEY_FORE_QUOTE: 输入了 `"`   需要判断中间有没有字符

KEY_MIDDLE_CHARACTER: 中间的字符串

KEY_BACK_QUOTE: 输入了后面的 `"`

INPUT_COLON: 输入了冒号

INPUT_COMMA: 输入了逗号

VALUE_FORE_QUOTE: value中的前面的QUOTE

VALUE_MIDDLE_CHARACTER: valuue中的字符

VALUE_BACK_QUOTE: value中的后面的QUOTE

OTHER: 输入已经无效了