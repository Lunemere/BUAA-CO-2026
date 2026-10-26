
#include <stdio.h>

int a[10000], b[10000];

int main() {
    int n;
    scanf("%d", &n);

    for (int i = 0; i < n; i++) {
        scanf("%d%d", &a[i], &b[i]);
    }

    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - 1 - i; j++) {
            if (a[j] > a[j + 1] ||
                (a[j] == a[j + 1] && b[j] > b[j + 1])) {

                int temp = a[j];
                a[j] = a[j + 1];
                a[j + 1] = temp;

                temp = b[j];
                b[j] = b[j + 1];
                b[j + 1] = temp;
            }
        }
    }

    for (int i = 0; i < n; i++) {
        printf("%d %d\n", a[i], b[i]);
    }

    return 0;
}
