#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "usage: %s TOTAL COUNT\n", argv[0]);
        return 2;
    }
    int total = atoi(argv[1]);
    int count = atoi(argv[2]);
    printf("%d\n", total / count);
    return 0;
}
