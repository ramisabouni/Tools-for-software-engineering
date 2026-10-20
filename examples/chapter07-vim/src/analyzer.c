#include <stdio.h>

int old_count(const int *values, int length) {
    int count = 0;
    for (int i = 0; i < length; ++i) {
        if (values[i] >= 0) {
            ++count;
        }
    }
    return count;
}

int main(void) {
    const int values[] = {3, -1, 4};
    printf("%d\n", old_count(values, 3));
    return 0;
}
