#include <stdio.h>
#include <string.h>

static const char *classify(const char *message) {
    if (strncmp(message, "ERROR", 5) == 0) return "ERROR";
    if (strncmp(message, "WARNING", 7) == 0) return "WARNING";
    if (strncmp(message, "INFO", 4) == 0) return "INFO";
    return "OTHER";
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "usage: %s MESSAGE\n", argv[0]);
        return 2;
    }
    puts(classify(argv[1]));
    return 0;
}
