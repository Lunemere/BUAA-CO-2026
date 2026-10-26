#include <stdio.h>

int main(void) {
    int m, n;
    scanf("%d%d", &n, &m);

    char S[5001], P[101];
    getchar();                  // skip the enter
    for (int i = 0; i < n; i++) {
        scanf("%c", &S[i]);
    }

    getchar();                  // skip the enter
    for (int i = 0; i < m; i++) {
        scanf("%c", &P[i]);
    }

    int location = -1;

    for (int i = 0; i <= n - m; i++) {
        int j;
        for (j = 0; j < m; j++) {
            if (S[i + j] != P[j]) {
                break;
            }
        }

        if (j == m) {
            location = i;
            break;
        }
    }

    printf("%d", location);
    return 0;
}