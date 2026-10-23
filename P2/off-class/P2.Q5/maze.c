#include <stdio.h>

int n, m;
int maze[7][7];
int visited[7][7];

int dx[] = {-1, 1, 0, 0};
int dy[] = {0, 0, -1, 1};

int sx, sy, ex, ey;
int ans = 0;

void dfs(int x, int y) {
    if (x == ex && y == ey) {
        ans++;
        return;
    }

    visited[x][y] = 1;

    for (int i = 0; i < 4; i++) {
        int nx = x + dx[i];
        int ny = y + dy[i];

        if (nx < 0 || nx >= n ||
            ny < 0 || ny >= m)
            continue;

        if (maze[nx][ny] == 1 || visited[nx][ny])
            continue;

        dfs(nx, ny);
    }

    visited[x][y] = 0;
}

int main(void) {
    scanf("%d%d", &n, &m);

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            scanf("%d", &maze[i][j]);
        }
    }

    scanf("%d%d%d%d", &sx, &sy, &ex, &ey);

    // 题目中的行列坐标从 1 开始，转换为 C 的下标
    sx--; sy--;
    ex--; ey--;

    if (maze[sx][sy] == 0 && maze[ex][ey] == 0) {
        dfs(sx, sy);
    }

    printf("%d\n", ans);

    return 0;
}