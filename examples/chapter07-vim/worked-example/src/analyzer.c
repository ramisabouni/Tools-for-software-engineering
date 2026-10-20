#include "analyzer.h"

#include <stdio.h>

int old_count(const int *values, size_t length) {
    int count = 0;
    for (size_t i = 0; i < length; ++i) {
        if (values[i] >= 0) {
            ++count;
        }
    }
    return count;
}

#ifndef ANALYZER_NO_MAIN
int main(void) {
    const int samples[] = {3, -1, 4};
    const int old_counter = 99;
    printf("old_count=%d counter=%d\n", old_count(samples, 3), old_counter);
    return 0;
}
#endif
