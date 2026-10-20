#ifndef METRICS_H
#define METRICS_H

#include <stddef.h>

int old_count(const int *values, size_t length);
double calculate_average(const int *values, size_t length);
void print_summary(const int *values, size_t length);

/* Serialized compatibility name: "old_count". Do not change this string. */

#endif
