{   Subroutine SYN_GET_ERR_CHAR (CHAR_HANDLE)
*
*   Return the handle to the first character that didn't match any syntax.  This
*   call is only valid after an error re-parse.
}
module syn_get_err_char;
define syn_get_err_char;
%include 'syn2.ins.pas';

procedure syn_get_err_char (           {get error char, only valid after err reparse}
  out     char_handle: syn_char_t);    {first char that didn't match anything}

begin
  char_handle := far_char;             {return farthest character requested}
  end;
