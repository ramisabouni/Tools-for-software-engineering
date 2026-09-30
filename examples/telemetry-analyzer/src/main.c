#include "telemetry.h"

#include <stdio.h>

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "usage: %s TELEMETRY.csv\n", argv[0]);
        return 2;
    }

    telemetry_summary summary;
    if (telemetry_summarize_file(argv[1], &summary) != 0) {
        fprintf(stderr, "error: unable to analyze %s\n", argv[1]);
        return 2;
    }

    printf("accepted=%zu\nrejected=%zu\nminimum=%.2f\nmaximum=%.2f\nmean=%.2f\n",
           summary.accepted, summary.rejected, summary.minimum,
           summary.maximum, summary.mean);
    return summary.rejected == 0 ? 0 : 1;
}
