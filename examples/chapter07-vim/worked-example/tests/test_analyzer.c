#define ANALYZER_NO_MAIN
#include "../src/analyzer.c"

#include <assert.h>

int main(void) {
    const int values[] = {-2, 0, 7};
    assert(old_count(values, 3) == 2);
    return 0;
}
