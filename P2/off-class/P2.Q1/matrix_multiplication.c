#include <stdio.h>

int main(void) {
    int edge;
    

    scanf("%d", &edge);

    int matrix1[8][8];
    int matrix2[8][8];

    int result = 0;


    for (int row = 0; row < edge; row++) {
        for (int column = 0; column < edge; column++) {
            scanf("%d", &matrix1[row][column]);
        }
    }

    for (int row = 0; row < edge; row++) {
        for (int column = 0; column < edge; column++) {
            scanf("%d", &matrix2[row][column]);
        }
    }

    for (int row = 0; row < edge; row++) {
        for (int column = 0; column < edge; column++) {
            result = 0;
            for (int k = 0; k < edge; k++) {
                result += matrix1[row][k] * matrix2[k][column];
            }
            printf("%d ", result);
        }
    }
}