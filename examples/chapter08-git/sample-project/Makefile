CC ?= cc
CFLAGS ?= -std=c11 -Wall -Wextra -Wpedantic -Werror

.PHONY: all test clean
all: build/analyzer

build/analyzer: src/analyzer.c
	@mkdir -p build
	$(CC) $(CFLAGS) $< -o $@

test: build/analyzer
	sh tests/test_analyzer.sh ./build/analyzer

clean:
	rm -rf build
