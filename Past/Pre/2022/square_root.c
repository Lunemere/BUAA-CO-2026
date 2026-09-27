#include <stdio.h>

int main(void)
{
    int n;

    scanf("%d", &n);

    
    int upper = n;
    int lower = 0;

    int temp = (lower + upper) / 2;

    while (lower <= upper)
    {
        if (temp * temp < n)
        {
            lower = temp + 1;
            temp = (lower + upper) / 2;
        }
        else if (temp * temp > n)
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