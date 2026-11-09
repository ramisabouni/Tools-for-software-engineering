#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int add(int left, int right) {
    return left + right;
}

int main(int argc, char **argv) {
    if (argc != 4 || strcmp(argv[1], "add") != 0) {
        fprintf(stderr, "usage: %s add LEFT RIGHT\n", argv[0]);
        return 2;
    }

    int left = atoi(argv[2]);
    int right = atoi(argv[3]);
    printf("%d\n", add(left, right));
    return 0;
}
