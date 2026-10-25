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
