#ifndef TELEMETRY_H
#define TELEMETRY_H

#include <stddef.h>

typedef struct {
    size_t accepted;
    size_t rejected;
    double minimum;
    double maximum;
    double mean;
} telemetry_summary;

int telemetry_summarize_file(const char *path, telemetry_summary *summary);

#endif
