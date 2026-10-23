#include <stdio.h>

int main(void) {
    int n;
    scanf("%d", &n);

    // 每个数组元素保存一位十进制数字，低位在前
    int a[1000] = {0};
    int len = 1;

    a[0] = 1;

    for (int i = 2; i <= n; i++) {
        int carry = 0;

        for (int j = 0; j < len; j++) {
            int temp = a[j] * i + carry;
            a[j] = temp % 10;
            carry = temp / 10;
        }

        while (carry > 0) {
            a[len] = carry % 10;
            carry /= 10;
            len++;
        }
    }

    // 逆序输出，因为数组低位在前
    for (int i = len - 1; i >= 0; i--) {
        printf("%d", a[i]);
    }

    printf("\n");

    return 0;
}
