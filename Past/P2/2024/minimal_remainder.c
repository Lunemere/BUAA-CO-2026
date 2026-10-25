#include <stdio.h>

int main(void)
{
    int b, m, n;
    scanf("%d%d%d", &b, &m, &n);
    int result = b;

    for (int i = m; i <= n; i++) {
        int remainder = i % b;
        if (result > remainder) {
            result = remainder;
        }
    }

    printf("%d", result);

    return 0;
}