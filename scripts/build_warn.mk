# SPDX-License-Identifier: GPL-2.0
# ==========================================================================
#
# make W=... settings
#
# W=1 - warnings that may be relevant and does not occur too often
# W=2 - warnings that occur quite often but may still be relevant
# W=3 - the more obscure warnings, can most likely be ignored
#
# $(call cc-option, -W...) handles gcc -W.. options which
# are not supported by all versions of the compiler
# ==========================================================================

ifdef BUILD_ENABLE_EXTRA_GCC_CHECKS
warning-  := $(empty)

warning-1 := -Wextra -Wunused -Wno-unused-parameter
warning-1 += -Wmissing-declarations
warning-1 += -Wmissing-format-attribute
warning-1 += $(call cc-option, -Wmissing-prototypes)
warning-1 += -Wold-style-definition
warning-1 += $(call cc-option, -Wmissing-include-dirs)
warning-1 += $(call cc-option, -Wunused-but-set-variable)
warning-1 += $(call cc-disable-warning, missing-field-initializers)

warning-2 := -Waggregate-return
warning-2 += -Wcast-align
warning-2 += -Wdisabled-optimization
warning-2 += -Wnested-externs
warning-2 += -Wshadow
warning-2 += $(call cc-option, -Wlogical-op)
warning-2 += $(call cc-option, -Wmissing-field-initializers)

warning-3 := -Wbad-function-cast
warning-3 += -Wcast-qual
warning-3 += -Wconversion
warning-3 += -Wpacked
warning-3 += -Wpadded
warning-3 += -Wpointer-arith
warning-3 += -Wredundant-decls
warning-3 += -Wswitch-default
warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
warning-3 += $(call cc-option, -Wvla)

warning := $(warning-$(findstring 1, $(BUILD_ENABLE_EXTRA_GCC_CHECKS)))
warning += $(warning-$(findstring 2, $(BUILD_ENABLE_EXTRA_GCC_CHECKS)))
warning += $(warning-$(findstring 3, $(BUILD_ENABLE_EXTRA_GCC_CHECKS)))

ifeq ("$(strip $(warning))","")
        $(error W=$(KBUILD_ENABLE_EXTRA_GCC_CHECKS) is unknown)
endif

KBUILD_CFLAGS += $(warning)

endif #BUILD_ENABLE_EXTRA_GCC_CHECKS
 
