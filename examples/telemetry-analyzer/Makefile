CC ?= cc
CPPFLAGS := -Iinclude
CFLAGS_COMMON := -std=c11 -Wall -Wextra -Wpedantic -MMD -MP
CFLAGS_DEBUG := $(CFLAGS_COMMON) -O0 -g3
CFLAGS_RELEASE := $(CFLAGS_COMMON) -O2 -DNDEBUG
LDLIBS := -lm

DEBUG_DIR := build/debug
RELEASE_DIR := build/release
DEBUG_BIN := $(DEBUG_DIR)/telemetry-analyzer
RELEASE_BIN := $(RELEASE_DIR)/telemetry-analyzer
DEBUG_OBJECTS := $(DEBUG_DIR)/main.o $(DEBUG_DIR)/telemetry.o
RELEASE_OBJECTS := $(RELEASE_DIR)/main.o $(RELEASE_DIR)/telemetry.o
TEST_BIN := $(DEBUG_DIR)/test-summary

.PHONY: all debug release test analyze diagram plot package clean
all: debug
debug: $(DEBUG_BIN)
release: $(RELEASE_BIN)

$(DEBUG_BIN): $(DEBUG_OBJECTS)
	$(CC) $^ $(LDLIBS) -o $@

$(RELEASE_BIN): $(RELEASE_OBJECTS)
	$(CC) $^ $(LDLIBS) -o $@

$(DEBUG_DIR)/%.o: src/%.c | $(DEBUG_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS_DEBUG) -c $< -o $@

$(RELEASE_DIR)/%.o: src/%.c | $(RELEASE_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS_RELEASE) -c $< -o $@

$(DEBUG_DIR) $(RELEASE_DIR) reports output dist:
	mkdir -p $@

$(TEST_BIN): tests/test-summary.c src/telemetry.c include/telemetry.h | $(DEBUG_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS_DEBUG) tests/test-summary.c src/telemetry.c $(LDLIBS) -o $@

test: $(DEBUG_BIN) $(TEST_BIN)
	$(TEST_BIN)
	tests/run-tests.sh $(DEBUG_BIN)

analyze: | reports
	@set +e; scripts/analyze.sh data/telemetry.csv reports/by-sensor.csv; status=$$?; set -e; \
	  test $$status -eq 1 || { echo "unexpected analyzer status $$status" >&2; exit 1; }; \
	  echo "PASS: expected malformed record was reported"

diagram: | output
	dot -Tsvg docs/architecture.dot -o output/architecture.svg

plot: | output
	@set +e; python3 scripts/plot.py data/telemetry.csv output/telemetry.png; status=$$?; set -e; \
	  test $$status -eq 1 || { echo "unexpected plot status $$status" >&2; exit 1; }; \
	  echo "PASS: plot created and malformed record reported"

package:
	scripts/package-source.sh

clean:
	rm -rf build dist output reports scripts/__pycache__

-include $(DEBUG_OBJECTS:.o=.d) $(RELEASE_OBJECTS:.o=.d)
