# 题面复原

## T1.Factory

**任务** 
假设你正在为一款城市规划软件编写核心功能。软件中，城市设施被表示为地图上的坐标点 $(x, y)$。现在需要实现一个功能：在给出的被考察坐标中选择一个点，用于建造新的工厂。该点需要满足：

1. 位于地图的**第二象限内或第四象限内**（不含坐标轴）。
2. 过该点分别向两坐标轴作垂线，与坐标轴原点 $(0,0)$ 所构成的矩形面积是最大的。

**输入格式**

1. 第一行，输入一个整数 $n$，代表被考察坐标的总个数。
2. 随后的 $2n$ 行，表示被考察坐标的信息。第 $2i$ 行和第 $2i+1$ 行分别输入两个整数 $x_i$ 和 $y_i$，共同构成第 $i$ 个坐标。

**约束条件**

- $n \le 1000$
- $0 \le |x_i|, |y_i| \le 10^9$
- **注意**：不保证输入的坐标都位于第二象限内或第四象限内，当遇到位于坐标轴上、第一象限内或第三象限内的点时，忽略即可。

**输出格式**

- 输出所选坐标，用一个空格分隔。
- 保证被考察坐标中存在满足题意的点。如果有多个点产生相同的最大面积，输出第一组满足题意的坐标。

**示例**

- **输入**：

 ```text
4
16
-4
7
-9
-1
1
8
-8
 ```
- **输出**：

 ```text
16 -4
 ```

**提交要求**

- 请勿使用 `.globl main`
- 不考虑延迟槽
- 只需要提交 `.asm` 文件

**C语言代码**

```c
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
```

---

## T2 K\_Increasing

**任务**  
使用 MIPS 汇编语言编写程序，计算使数组成为 K 递增数组所需的最少操作次数（不考虑延迟槽）。

**K 递增定义**  
给定一个下标从 0 开始包含 $n$ 个正整数的数组 `arr`，和一个正整数 $k$。  
如果对于每个满足 $k \le i \le n-1$ 的下标 $i$，都有 $arr[i-k] \le arr[i]$，那么我们称 `arr` 是 K 递增 的。

- 例如，`arr = [4, 1, 5, 2, 6, 2]` 对于 $k=2$ 是 K 递增的。

**输入格式**

1. 第 1 行输入一个整数 $n$，为数组 `arr` 的大小 ($1 \le n \le 20$)。
2. 第 2 行至第 $n+1$ 行，每行输入一个数字，为数组 `arr` 的一个元素。
3. 第 $n+2$ 行输入一个整数 $k$，为 K 递增的参数值 ($1 \le k \le n-1$)。

**输出格式**

- 输出使数组成为 K 递增数组所需的最少操作次数（一次操作指修改数组中一个元素的值）。

**规定**

- 步数限制为 200,000
- 使用 `syscall 10` 结束程序
- 程序的初始地址设置 (Mars->Settings->Memory Configuration) 为 **Compact, Data at Address 0**。

**示例 1**

- **输入**：

 ```text
5
5
4
3
2
1
1
 ```
- **期望输出**：

 ```text
4
 ```

**示例 2**

- **输入**：

 ```text
6
5
3
4
2
6
1
2
 ```
- **期望输出**：

 ```text
3
 ```

**C语言代码**

```c
#include <stdio.h>
#define MAX_N 20

int computeLIS(int *subseq, int m) {
    if (m == 0) return 0;

    int dp[MAX_N];
    int maxLen = 1;

    for (int i = 0; i < m; i++) {
        dp[i] = 1;
    }

    for (int i = 1; i < m; i++) {
        for (int j = 0; j < i; j++) {
            if (subseq[i] >= subseq[j]) {
                if (dp[j] + 1 > dp[i]) {
                    dp[i] = dp[j] + 1;
                }
            }
        }
        maxLen = maxLen > dp[i] ? maxLen : dp[i];
    }

    return maxLen;
}

int kIncreasing(int* arr, int arrSize, int k) {
    int ans = 0;

    for (int i = 0; i < k; i++) {
        int subseq[MAX_N];
        int m = 0;
        for (int j = i; j < arrSize; j += k) {
            subseq[m++] = arr[j];
        }
        int lisLen = computeLIS(subseq, m);
        ans += (m - lisLen);
    }
    return ans;
}

int main() {
    int n, k;
    scanf("%d", &n);
    int arr[MAX_N];
    for (int i = 0; i < n; i++) {
        scanf("%d", &arr[i]);
    }
    scanf("%d", &k);
    printf("%d", kIncreasing(arr, n, k));
    
    return 0; 
}
```

---

## T3.Folder Size

**任务**  
给定一个项目的目录树，每个节点要么是文件，要么是文件夹。请实现一个 MIPS 程序，支持多次查询：对给定的节点编号，输出其“子树总大小”（该文件夹内所有文件大小之和，包含所有子文件夹内的文件）。

**输入格式**

1. 第一行：整数 $n$，表示节点总数（节点编号为 $1, 2, \dots, n$）。
2. 接下来 $n$ 段节点描述（按编号顺序从小到大给出，即第 $i$ 段节点描述对应第 $i$ 个节点）：
  - **若为文件**：第一行为 `0`，第二行一个整数 `size`，表示文件大小。
  - **若为文件夹**：第一行为 `1`，第二行一个整数 `k`。接下来依次给出 $k$ 个整数，为该文件夹的子节点编号。
3. 然后一行输入一个整数 $q$，表示查询次数。
4. 接下来 $q$ 行：每行一个整数 $id$，表示查询该节点为根的子树总大小（保证 $id$ 合法）。

**约束条件**

- $1 \le n \le 150$
- 文件大小 $size$ 满足 $0 \le size \le 10^6$
- 所有文件大小总和 $\le 10^9$
- 输入保证形成一个或多个有根树（无环）
- 总边数 $\le 800$
- 查询次数 $\le 60$

**输出格式**  
对每个查询输出一行：若查询的节点为文件，直接输出其大小；若为文件夹，输出其子树总大小（目录本身大小视为零）。

**示例**

- **输入**：

 ```text
5
1
2
2
3
0
100
1
1
4
0
20
0
1
3
1
3
5
 ```

 *(解释：节点1是文件夹有子节点2和3；节点2是文件大小100；节点3是文件夹有子节点4；节点4是文件大小20；节点5是文件大小1)*
- **输出**：

 ```text
120
20
1
 ```

**提交要求**

- 请勿使用 `.globl main`
- 不考虑延迟槽
- 只需要提交 `.asm` 文件
- 程序的初始地址设置 (Mars->Settings->Memory Configuration) 为 **Compact, Data at Address 0**。

**C语言代码**

```c
#include <stdio.h>

#define MAXN 155
#define MAXE 805

int n;
int nodeType[MAXN];     // 0: 文件, 1: 文件夹
int fileSizeVal[MAXN];  // 文件大小(文件夹为0)
int headAdj[MAXN];      // 邻接表头
int toEdge[MAXE], nextEdge[MAXE];
int edgeCnt;

void add_edge(int u, int v) {
    toEdge[edgeCnt] = v;
    nextEdge[edgeCnt] = headAdj[u];
    headAdj[u] = edgeCnt++;
}

int dfs_sum(int u) {
    if (nodeType[u] == 0) {
        return fileSizeVal[u];
    }

    int size = 0;
    for (int e = headAdj[u]; e != -1; e = nextEdge[e]) {
        int v = toEdge[e];
        size += dfs_sum(v);
    }
    return size;
}

int main() {
    for(int i=0; i<MAXN; i++) headAdj[i] = -1; 
    
    edgeCnt = 0;

    scanf("%d", &n);
    
    for (int i = 1; i <= n; i++) {
        int t, x;
        scanf("%d", &t); 
        
        if (t == 0) {
            nodeType[i] = 0;
            scanf("%d", &x); 
            fileSizeVal[i] = x;
        } else {
            nodeType[i] = 1;
            int k;
            scanf("%d", &k); 
            for (int j = 0; j < k; j++) {
                int v;
                scanf("%d", &v);
                add_edge(i, v);
            }
        }
    }

    int q;
    scanf("%d", &q);
    while (q--) {
        int id;
        scanf("%d", &id);
        int ans = dfs_sum(id);
        printf("%d\n", ans);
    }

    return 0;
}
```