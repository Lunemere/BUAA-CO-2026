#include <stdio.h>
int main(void) {
    int n;
    scanf("%d", &n);

    long long best_area = 0;
    int best_x = 0, best_y = 0;

    for (int i = 0; i < n; i++) {
        int x, y;
        scanf("%d%d", &x, &y);

        if (x == 0 || y == 0) continue;
        if ((x > 0 && y > 0) || (x < 0 && y < 0)) continue;

        int ax = x >= 0 ? x : -x;
        int ay = y >= 0 ? y : -y;
        
        long long area = (long long) ax * ay;

        if (area > best_area) {
            best_area = area;
            best_x = x;
            best_y = y;
        }
    }

    printf("%d %d\n", best_x, best_y);
    return 0;
}