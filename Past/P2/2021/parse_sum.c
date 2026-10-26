
#include <stdio.h>

int n;
int a[20];

void dfs(int sum, int min, int depth) {
    if (sum == n) {
        if (depth == 1) return;

        for (int i = 0; i < depth; i++) {
            if (i > 0) printf("+");
            printf("%d", a[i]);
        }
        printf("\n");
        return;
    }

    for (int i = min; i <= n - sum; i++) {
        a[depth] = i;
        dfs(sum + i, i, depth + 1);
    }
}

int main() {
    scanf("%d", &n);
    dfs(0, 1, 0);
    return 0;
}
