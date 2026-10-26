#include <stdio.h>

int st[64];
int asteroids[64];
int returnSize;
int asteroidsSize;

int main() {
    scanf("%d", &asteroidsSize);
    for (int i = 0; i < asteroidsSize; i++) {
        scanf("%d", &asteroids[i]);
    }

    int pos = 0;
    for (int i = 0; i < asteroidsSize; i++) {
        int alive = 1;
        while (alive && asteroids[i] < 0 && pos > 0 && st[pos - 1] > 0) {
            alive = st[pos - 1] < -asteroids[i];
            if (st[pos - 1] <= -asteroids[i]) {
                pos--;
            }
        }
        if (alive) {
            st[pos++] = asteroids[i];
        }
    }

    returnSize = pos;
    printf("%d\n", returnSize);
    for (int i = 0; i < returnSize; i++) {
        printf("%d ", st[i]);
    }
    return 0;
}