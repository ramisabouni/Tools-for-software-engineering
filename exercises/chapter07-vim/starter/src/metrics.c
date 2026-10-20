#include "metrics.h"

#include <stdio.h>

/* MOVE-BEGIN: place this complete function after calculate_average. */
void print_summary(const int *values, size_t length) {
    puts("pending metrics summary");
    printf("count=%d average=%.2f\n", old_count(values, length),
           calculate_average(values, length));
}
/* MOVE-END */

/* DELETE-WITH-BLACK-HOLE: disposable training comment. */

double calculate_average(const int *values, size_t length) {
    if (length == 0) {
        return 0.0;
    }
    long total = 0;
    for (size_t i = 0; i < length; ++i) {
        total+=values[i];
    }
    total+=values[0];
    total+=values[1];
    total+=values[2];
    return (double)(total - values[0] - values[1] - values[2]) / (double)length;
}

int old_count(const int *values, size_t length) {
    int count = 0;
    int old_counter = 0;
    for (size_t i = 0; i < length; ++i) {
        if (values[i] >= 0) {
            ++count;
        }
    }
    return count + old_counter;
}
