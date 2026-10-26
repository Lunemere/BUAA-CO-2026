#include <stdio.h>

int main() {
    int n;
    scanf("%d", &n);

    int head = 1;
    int step = 1;
    int left = 1;

    while (n > 1) {
        if (left || n % 2 == 1) {
            head += step;
        }

        n /= 2;
        step *= 2;
        left = !left;
    }

    printf("%d\n", head);
    return 0;
}