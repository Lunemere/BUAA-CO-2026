#include <stdio.h>

int main(void)
{
    int n;

    scanf("%d", &n);

    if (n == 0)
        printf("0");

    int upper = n;
    int lower = 1;

    int temp = (lower + upper) / 2;

    while (lower <= upper)
    {
        if (temp < n / temp)
        {
            lower = temp + 1;
            temp = (lower + upper) / 2;
        }
        else if (temp > n / temp)
        {
            upper = temp - 1;
            temp = (upper + lower) / 2;
        }
        else
            break;
    }

    printf("%d", temp);

    return 0;
}