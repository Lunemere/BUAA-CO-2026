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