#include <stdio.h>
#include <limits.h>

int main(void)
{
    int n;
    int max = 0;

    scanf("%d", &n);
    int altitude = 0;

    for (int i = 0; i < n; i++)
    {
        int temp;
        scanf("%d", &temp);
        altitude += temp;

        if (altitude > max)
        {
            max = altitude;
        }
    }

    printf("%d", max);

    return 0;
}