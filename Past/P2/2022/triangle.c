#include <stdio.h>

void triangle(int line, int d);

int main(void) {
    int n;
    scanf("%d", &n);

    triangle(n, 1);

    return 0;
}

void triangle(int line, int d) {
    if (d > line) {
        return;
    }

    for (int i = 0; i < line - d; i++) {
        printf(" ");
    }
    
    for (int j = 0; j < 2 * d - 1; j++) {
        printf("A");
    }
    printf("\n");

    triangle(line, d + 1);
}