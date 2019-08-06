{   Subroutine SYN_GET_CHAR_FLEVEL (CHAR_HANDLE,LEVEL)
*
*   Return the input file nesting level for a source character.  CHAR_HANDLE
*   is the handle to the source character.  LEVEL is the returned nesting level.
*   0 indicates the character came from the top level input file.
}
module syn_GET_CHAR_FLEVEL;
define syn_get_char_flevel;
%include 'syn2.ins.pas';

procedure syn_get_char_flevel (        {get file nesting level from char handle}
  in      char_handle: syn_char_t;     {handle to character to inquire about}
  out     level: sys_int_machine_t);   {nesting level, 0 = top file}

begin
  level := char_handle.crange_p^.line_p^.file_p^.nest_level;
  end;
