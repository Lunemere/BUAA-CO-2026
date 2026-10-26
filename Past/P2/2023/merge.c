#include <stdio.h>

int nums1[64], nums2[64], nums[128];

int main() {
    int n1, n2;
    scanf("%d", &n1);
    for (int i = 0; i < n1; i++) {
        scanf("%d", &nums1[i]);
    }

    scanf("%d", &n2);
    for (int i = 0; i < n2; i++) {
        scanf("%d", &nums2[i]);
    }

    int i = 0, j = 0, k = 0;

    while (i < n1 && j < n2) {
        if (nums1[i] <= nums2[j]) {
            nums[k++] = nums1[i++];
        } else {
            nums[k++] = nums2[j++];
        }
    }

    while (i < n1) {
        nums[k++] = nums1[i++];
    }

    while (j < n2) {
        nums[k++] = nums2[j++];
    }

    for (int t = 0; t < k; t++) {
        printf("%d ", nums[t]);
    }

    return 0;
}