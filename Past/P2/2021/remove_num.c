
#include <stdio.h>

int a[100000];
int stk[100000];

int main() {
    int n, k;
    scanf("%d", &n);

    for (int i = 0; i < n; i++) {
        scanf("%d", &a[i]);
    }

    scanf("%d", &k);

    int len = n - k;
    int top = 0;

    for (int i = 0; i < n; i++) {
        while (top > 0 && k > 0 && stk[top - 1] > a[i]) {
            top--;
            k--;
        }

        stk[top++] = a[i];
    }

    for (int i = 0; i < len; i++) {
        printf("%d", stk[i]);
    }

    printf("\n");
    return 0;
}
