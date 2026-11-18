CC ?= cc
CFLAGS ?= -std=c11 -Wall -Wextra -Wpedantic -Werror

.PHONY: all test clean
all: build/calculator

build/calculator: calculator.c
	@mkdir -p build
	$(CC) $(CFLAGS) $< -o $@

test: build/calculator
	sh test_calculator.sh ./build/calculator

clean:
	rm -rf build
