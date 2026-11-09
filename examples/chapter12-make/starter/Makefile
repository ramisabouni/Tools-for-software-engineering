CC ?= cc
MODE ?= debug

REQUIRED_CPPFLAGS := -Iinclude
REQUIRED_CFLAGS := -std=c11 -Wall -Wextra -Wpedantic -Werror
CPPFLAGS += $(REQUIRED_CPPFLAGS)
CFLAGS += $(REQUIRED_CFLAGS)

# TODO: validate MODE and add mode-specific flags.
# TODO: derive mode-specific object, dependency, binary, and test paths.
# TODO: add default, action targets, link rules, one compilation pattern rule,
#       order-only directories, automatic header dependencies, config/help, and
#       bounded cleanup.
