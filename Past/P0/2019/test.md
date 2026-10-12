# Vending Machine

下面一行为一个周期，若仅一个数，则为money，且所有输出为0，若共有5个数，则从左至右分别为money, dispense, return1, return2, return4，reset会特意注明，注意每次投完币有一个不接受投币的周期，不要忽略diao'le

00

11，1，0，0，0

01

11，1，1，0，0

10

11，1，0，1，0

10

10

reset = 1

10

10

11，1， 0，0，1

01

10

11，1，1，1，0

10

01

10，1，0，0，0

# Arithmetic Right Shifter

这里不给出测试用例，可以直接用shifter进行验证。特别要注意尾数为1的情况