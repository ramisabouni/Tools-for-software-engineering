#include "telemetry.h"

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int telemetry_summarize_file(const char *path, telemetry_summary *summary) {
    if (path == NULL || summary == NULL) {
        return -1;
    }

    FILE *stream = fopen(path, "r");
    if (stream == NULL) {
        return -1;
    }

    *summary = (telemetry_summary){0};
    char line[512];
    double total = 0.0;
    int first = 1;

    if (fgets(line, sizeof line, stream) == NULL) {
        fclose(stream);
        return -1;
    }

    while (fgets(line, sizeof line, stream) != NULL) {
        char timestamp[64];
        char sensor[64];
        char value_text[128];
        int consumed = 0;

        if (sscanf(line, " %63[^,],%63[^,],%127[^,\n]%n", timestamp, sensor,
                   value_text, &consumed) != 3) {
            summary->rejected++;
            continue;
        }
        while (line[consumed] == ' ' || line[consumed] == '\t' ||
               line[consumed] == '\r' || line[consumed] == '\n') {
            consumed++;
        }
        if (line[consumed] != '\0') {
            summary->rejected++;
            continue;
        }

        errno = 0;
        char *end = NULL;
        double value = strtod(value_text, &end);
        while (end != NULL && (*end == ' ' || *end == '\t' || *end == '\r')) {
            end++;
        }
        if (errno != 0 || end == value_text || end == NULL || *end != '\0') {
            summary->rejected++;
            continue;
        }

        if (first || value < summary->minimum) summary->minimum = value;
        if (first || value > summary->maximum) summary->maximum = value;
        first = 0;
        total += value;
        summary->accepted++;
    }

    if (ferror(stream) || fclose(stream) != 0 || summary->accepted == 0) {
        return -1;
    }
    summary->mean = total / (double)summary->accepted;
    return 0;
}
