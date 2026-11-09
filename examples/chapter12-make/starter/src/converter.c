#include "converter.h"
#include "converter_internal.h"

double celsius_to_fahrenheit(double celsius) {
    return scale(celsius, 9.0, 5.0) + 32.0;
}

double fahrenheit_to_celsius(double fahrenheit) {
    return scale(fahrenheit - 32.0, 5.0, 9.0);
}
