#include "metrics.h"

#include <assert.h>
#include <string.h>

int main(void) {
    const int values[] = {-2, 0, 7, 5};
    assert(old_count(values, 4) == 3);
    assert(calculate_average(values, 4) == 2.5);

    const char *serialized_name = "old_count";
    assert(strcmp(serialized_name, "old_count") == 0);
    return 0;
}
