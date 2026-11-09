#include <stdio.h>
#include "converter.h"

int main(void) {
    printf("20 C = %.1f F\n", celsius_to_fahrenheit(20.0));
    printf("68 F = %.1f C\n", fahrenheit_to_celsius(68.0));
    return 0;
}
