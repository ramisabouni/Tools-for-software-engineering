#ifndef CONVERTER_INTERNAL_H
#define CONVERTER_INTERNAL_H

static inline double scale(double value, double numerator, double denominator) {
    return value * numerator / denominator;
}

#endif
