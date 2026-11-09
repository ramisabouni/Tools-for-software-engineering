#include <stdio.h>
#include "converter.h"

static int failures = 0;
static void check_close(double actual, double expected, const char *name) {
    double difference = actual - expected;
    if (difference < 0.0) difference = -difference;
    if (difference > 0.000001) {
        fprintf(stderr, "FAIL %s: expected %.6f, got %.6f\n", name, expected, actual);
        ++failures;
    }
}

int main(void) {
    check_close(celsius_to_fahrenheit(20.0), 68.0, "C to F");
    check_close(fahrenheit_to_celsius(68.0), 20.0, "F to C");
    printf("checks=2 failures=%d\n", failures);
    return failures == 0 ? 0 : 1;
}
