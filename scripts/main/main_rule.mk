# SPDX-License-Identifier: GPL-2.0
# ==========================================================================
# Build project
# ==========================================================================

########################################
# OBJ options                          #
########################################

include_file := $(addprefix -I ,$(INCLUDE))

# Backward compatibility
asflags-y  += $(EXTRA_AFLAGS)
ccflags-y  += $(EXTRA_CFLAGS)
cppflags-y += $(EXTRA_CPPFLAGS)
ldflags-y  += $(EXTRA_LDFLAGS)

orig_c_flags   = $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(KBUILD_SUBDIR_CCFLAGS) \
                 $(ccflags-y) $(CFLAGS_$(basetarget).o)


_c_flags       = $(filter-out $(CFLAGS_REMOVE_$(basetarget).o), $(orig_c_flags))
_a_flags       = $(KBUILD_CPPFLAGS) $(KBUILD_AFLAGS) $(KBUILD_SUBDIR_ASFLAGS) \
                 $(asflags-y) $(AFLAGS_$(basetarget).o)
_cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(@F))


c_flags		= -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(include_file)     \
		 	$(_c_flags) $(modkern_cflags)

a_flags		= -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(include_file)     \
		 	$(_a_flags) $(modkern_aflags)

cpp_flags	= -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(include_file)     \
		 	$(_cpp_flags)

ld_flags	= $(LDFLAGS) $(ldflags-y)

########################################
# Start rule                           #
########################################

# Compile C sources (.c)
# ---------------------------------------------------------------------------

quiet_cmd_cc_s_c = $(ECHO_CC) $@
	  cmd_cc_s_c = $(CC) $(c_flags) -fverbose-asm -S -o $@ $<
$(obj)/%.s: $(src)/%.c FORCE
	$(call if_changed_dep,cc_s_c)

	
quiet_cmd_cc_i_c = $(ECHO_CPP) $@
	  cmd_cc_i_c = $(CPP) $(c_flags)   -o $@ $<
$(obj)/%.i: $(src)/%.c FORCE
	$(call if_changed_dep,cc_i_c)

# C (.c) files
# The C file is compiled and updated dependency information is generated.
# (See cmd_cc_o_c + relevant part of rule_cc_o_c)

quiet_cmd_cc_o_c = $(ECHO_CC) $@
	  cmd_cc_o_c = $(CC) $(c_flags) -c -o $@ $<

define rule_cc_o_c
	$(call echo-cmd,cc_o_c) $(cmd_cc_o_c);				  \
	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
	                                              $(dot-target).tmp;  \
	rm -f $(depfile);						  \
	mv -f $(dot-target).tmp $(dot-target).cmd
endef

# Built-in and composite module parts
$(obj)/%.o: $(src)/%.c FORCE
	$(call if_changed_rule,cc_o_c)

quiet_cmd_cc_lst_c = MKLST   $@
      cmd_cc_lst_c = $(CC) $(c_flags) -g -c -o $*.o $< && \
		     $(CONFIG_SHELL) $(srctree)/scripts/makelst $*.o \
				     System.map $(OBJDUMP) > $@

$(obj)/%.lst: $(src)/%.c FORCE
	$(call if_changed_dep,cc_lst_c)

# Compile assembler sources (.S)
# ---------------------------------------------------------------------------

quiet_cmd_as_s_S	= $(ECHO_CPP) $@
	  cmd_as_s_S	= $(CPP) $(a_flags) -o $@ $< 

$(obj)/%.s: $(src)/%.S FORCE
	$(call if_changed_dep,as_s_S)

quiet_cmd_as_o_S = $(ECHO_AS) $@
cmd_as_o_S       = $(AS) $(a_flags) -c -o $@ $<

$(obj)/%.o: $(src)/%.S FORCE
	$(call if_changed_dep,as_o_S)

targets += $(real-objs-y) $(lib-y)
targets += $(extra-y) $(MAKECMDGOALS)

# Linker scripts preprocessor (.lds.S -> .lds)
# ---------------------------------------------------------------------------
quiet_cmd_cpp_lds_S = LDS $@
      cmd_cpp_lds_S = $(CPP) $(cpp_flags) -P -C -U$(ARCH) \
	                     -D__ASSEMBLY__ -DLINKER_SCRIPT -o $@ $<

$(obj)/%.lds: $(src)/%.lds.S FORCE
	$(call if_changed_dep,cpp_lds_S)
	
#
# Rule to compile a set of .o files into one .o file

quiet_cmd_link_o_target = $(ECHO_LD) $@
	  cmd_link_o_target = $(if $(strip $(obj-file-y)$(subdir-y)),\
		      $(LD) $(ld_flags) -r -o $@ $(obj-file-y), \
		      rm -f $@; $(AR) rcs$(KBUILD_ARFLAGS) $@)
$(builtin-target): $(obj-file-y) FORCE
	$(call if_changed,link_o_target)

targets += $(builtin-target)

#
# Rule to compile a set of .o files into one .a file
quiet_cmd_link_l_target = AR	$@
	  cmd_link_l_target = rm -f $@; $(AR) rcs$(KBUILD_ARFLAGS) $@ $(lib-y)
$(lib-target): $(lib-y) FORCE
	$(call if_changed,link_l_target)

targets += $(lib-target)