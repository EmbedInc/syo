{   SYO_INIT
*
*   Initialize the SYO library.  Other SYO_ calls may only be made after the SYN
*   library is initialized.  The SYO library is uninitialized on wakeup and after
*   a call to SYO_CLOSE.
}
module syo_init;
define syo_init;
%include 'syo2.ins.pas';

procedure syo_init;                    {init SYO library.  Must be first call}

begin
  util_mem_context_get (               {create dynamic memory context for us}
    util_top_mem_context,              {parent context}
    mem_context_p);                    {our own new memory context}
  util_stack_alloc (mem_context_p^, pstack); {make parse-time stack}
  util_stack_alloc (mem_context_p^, sytree); {make stack for syntax tree}

  top_fnam.max := sizeof(top_fnam.str); {init var strings}
  top_fnam.len := 0;
  top_fnam_ext.max := sizeof(top_fnam_ext.str);
  top_fnam_ext.len := 0;

  syo_preproc_p := addr(syo_preproc_default); {install default pre-processor}
  next_crange_seq_n := 1;              {init sequence number for next crange created}
  file_p := nil;                       {init to no current input file}
  file_name_p := nil;

  start_char.crange_p := nil;          {init character positions to invalid}
  start_char.ofs := 0;
  next_char := start_char;
  far_char := start_char;
  err_reparse := false;                {init to not in error re-parse mode}

  syo_reset;                           {make state ready for calling parse routines}
  end;
