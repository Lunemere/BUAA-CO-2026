#include <stdio.h>

int main(void) {
    int m1, n1, m2, n2;

    scanf("%d", &m1);
    scanf("%d", &n1);
    scanf("%d", &m2);
    scanf("%d", &n2);

    int matrix1[11][11];
    int matrix2[11][11];

    for (int m = 0; m < m1; m++) {
        for (int n = 0; n < n1; n++) {
            scanf("%d", &matrix1[m][n]);
        }
    }

    for (int m = 0; m < m2; m++) {
        for (int n = 0; n < n2; n++) {
            scanf("%d", &matrix2[m][n]);
        }
    }


    for (int m = 0; m < m1 - m2 + 1; m++) {
        for (int n = 0; n < n1 - n2 + 1; n++) {
            int result = 0;

            for (int k = 0; k < m2; k++) {
                for (int l = 0; l < n2; l++) {
                    result += matrix1[m + k][n + l] * matrix2[k][l];
                }
            }

            printf("%d ", result);
        }
        printf("\n");
    }
}