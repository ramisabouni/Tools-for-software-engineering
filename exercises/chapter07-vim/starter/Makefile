CC ?= cc
CFLAGS ?= -std=c11 -Wall -Wextra -Werror -pedantic

.PHONY: all check clean
all: metrics_tests

metrics_tests: src/metrics.c tests/test_metrics.c include/metrics.h
	$(CC) $(CFLAGS) -Iinclude src/metrics.c tests/test_metrics.c -o $@

check: metrics_tests
	./metrics_tests

clean:
	$(RM) metrics_tests
