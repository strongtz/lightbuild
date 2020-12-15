# SPDX-License-Identifier: GPL-2.0
# ==========================================================================
# elf rule
# ==========================================================================

########################################
# Always build                         #
########################################

# bin-always-y += foo
# ... is a shorthand for
# bin += foo
# always-y  += foo
elf 		+= $(elf-always-y)
elf-always 	+= $(elf-always-y)

########################################
# Sort files                           #
########################################

elf	:= $(sort $(elf))

########################################
# Filter files                         #
########################################

elf-objs	:= $(sort $(foreach m,$(elf),$($(m)-obj-y)))

########################################
# Add path                             #
########################################

elf			:= $(addprefix $(obj)/,$(elf))
elf-objs	:= $(addprefix $(obj)/,$(elf-objs))
elf-always 	:= $(addprefix $(obj)/,$(elf-always))

########################################
# Always rule                          #
########################################

always-y	+= $(elf-always)

########################################
# clean rule                           #
########################################

clean-files += $(elf) 
