#include <stdio.h>

void swap(int* i, int* j);

int main(void) {
    int n;
    scanf("%d", &n);
    int array[1000];

    for (int i = 0; i < n; i++) {
        scanf("%d", &array[i]);
    }

    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            if (array[i] > array[j]) {
                swap(&array[i], &array[j]);
            }
        }
    }

    for (int i = 0; i < n; i++) {
        printf("%d ", array[i]);
    }

    return 0;
}

void swap(int* i, int* j) {
    int temp = *i;
    *i = *j;
    *j = temp;
}