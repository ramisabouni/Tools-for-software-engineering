#include "telemetry.h"

#include <math.h>
#include <stdio.h>

int main(void) {
    telemetry_summary summary;
    if (telemetry_summarize_file("data/telemetry.csv", &summary) != 0) {
        fputs("FAIL: analyzer could not read the fixture\n", stderr);
        return 1;
    }
    if (summary.accepted != 6 || summary.rejected != 1 ||
        fabs(summary.minimum - 18.70) > 0.001 ||
        fabs(summary.maximum - 24.10) > 0.001 ||
        fabs(summary.mean - 21.483333) > 0.001) {
        fputs("FAIL: unexpected summary\n", stderr);
        return 1;
    }
    puts("PASS: telemetry summary matches the expected fixture");
    return 0;
}
