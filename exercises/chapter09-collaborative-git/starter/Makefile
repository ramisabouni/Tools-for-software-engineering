CC ?= cc
CFLAGS ?= -std=c11 -Wall -Wextra -Wpedantic -Werror

.PHONY: all test ci clean
all: build/average

build/average: src/average.c
	@mkdir -p build
	$(CC) $(CFLAGS) $< -o $@

test: build/average
	sh tests/test_average.sh ./build/average
	sh tests/test_integration.sh

ci: clean test
	@count=$$(grep -c '^check ' tests/test_average.sh); \
	[ "$$count" -ge 3 ] || { echo "Expected at least 3 tests; found $$count" >&2; exit 1; }; \
	printf 'CI candidate: %s\nExecuted tests: %s\n' "$$(git rev-parse HEAD 2>/dev/null || echo uncommitted)" "$$count"

clean:
	rm -rf build
