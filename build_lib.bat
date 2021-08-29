@echo off
rem
rem   BUILD_LIB [-dbg]
rem
rem   Build the SYO library.
rem
setlocal
call build_pasinit

call src_insall %srcdir% %libname%

call src_get %srcdir% syo_syn.ins.pas
copya syo_syn.ins.pas (cog)lib/syo_syn.ins.pas

call src_pas %srcdir% %libname%_addstat %1
call src_pas %srcdir% %libname%_close %1
call src_pas %srcdir% %libname%_comblock %1
call src_pas %srcdir% %libname%_error %1
call src_pas %srcdir% %libname%_error_abort %1
call src_pas %srcdir% %libname%_error_print %1
call src_pas %srcdir% %libname%_error_tag_unexp %1
call src_pas %srcdir% %libname%_get_char_flevel %1
call src_pas %srcdir% %libname%_get_char_line %1
call src_pas %srcdir% %libname%_get_err_char %1
call src_pas %srcdir% %libname%_get_line %1
call src_pas %srcdir% %libname%_get_name %1
call src_pas %srcdir% %libname%_get_tag %1
call src_pas %srcdir% %libname%_get_tag_msg %1
call src_pas %srcdir% %libname%_get_tag_msg_none %1
call src_pas %srcdir% %libname%_get_tag_stat %1
call src_pas %srcdir% %libname%_get_tag_string %1
call src_pas %srcdir% %libname%_inconn_top_set %1
call src_pas %srcdir% %libname%_infile_name %1
call src_pas %srcdir% %libname%_infile_pop %1
call src_pas %srcdir% %libname%_infile_push %1
call src_pas %srcdir% %libname%_infile_read %1
call src_pas %srcdir% %libname%_infile_top_set %1
call src_pas %srcdir% %libname%_init %1
call src_pas %srcdir% %libname%_level_down %1
call src_pas %srcdir% %libname%_level_down_cond %1
call src_pas %srcdir% %libname%_level_up %1
call src_pas %srcdir% %libname%_level_up_cond %1
call src_pas %srcdir% %libname%_mem_alloc_pool %1
call src_pas %srcdir% %libname%_mem_context_alloc %1
call src_pas %srcdir% %libname%_next_tree_pos %1
call src_pas %srcdir% %libname%_pop1 %1
call src_pas %srcdir% %libname%_pos %1
call src_pas %srcdir% %libname%_preproc_default %1
call src_pas %srcdir% %libname%_preproc_set %1
call src_pas %srcdir% %libname%_push1 %1
call src_pas %srcdir% %libname%_p_charcase %1
call src_pas %srcdir% %libname%_p_cpos_pop %1
call src_pas %srcdir% %libname%_p_cpos_push %1
call src_pas %srcdir% %libname%_p_end_routine %1
call src_pas %srcdir% %libname%_p_get_ichar %1
call src_pas %srcdir% %libname%_p_start_routine %1
call src_pas %srcdir% %libname%_p_tag_end %1
call src_pas %srcdir% %libname%_p_tag_start %1
call src_pas %srcdir% %libname%_p_test_eod %1
call src_pas %srcdir% %libname%_p_test_eof %1
call src_pas %srcdir% %libname%_p_test_string %1
call src_pas %srcdir% %libname%_range_next %1
call src_pas %srcdir% %libname%_reset %1
call src_pas %srcdir% %libname%_stack_alloc %1
call src_pas %srcdir% %libname%_stat_set %1
call src_pas %srcdir% %libname%_tree_clear %1
call src_pas %srcdir% %libname%_tree_err %1
call src_pas %srcdir% %libname%_tree_setup %1

call src_lib %srcdir% %libname%
call src_msg %srcdir% %libname%
