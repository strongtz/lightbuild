# SPDX-License-Identifier: GPL-2.0
# ==========================================================================
# Build elf
# ==========================================================================

########################################
# Sort file                            #
########################################

elf	:= $(sort $(elf))
elf	:= $(addprefix $(obj)/,$(elf))

$(elf): $(builtin-target) FORCE