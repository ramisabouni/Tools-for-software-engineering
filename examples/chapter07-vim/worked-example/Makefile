CC ?= cc
CFLAGS ?= -std=c11 -Wall -Wextra -Werror -pedantic

.PHONY: all check clean
all: analyzer test_analyzer

analyzer: src/analyzer.c include/analyzer.h
	$(CC) $(CFLAGS) -Iinclude src/analyzer.c -o $@

test_analyzer: tests/test_analyzer.c include/analyzer.h
	$(CC) $(CFLAGS) -Iinclude tests/test_analyzer.c -o $@

check: all
	./test_analyzer

clean:
	$(RM) analyzer test_analyzer
