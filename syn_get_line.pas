{   Subroutine SYN_GET_LINE (CHAR_HANDLE, LNUM, TNAM)
*
*   Get the source line information, given the handle to a particular
*   input stream character.  CHAR_HANDLE is the handle to the input stream
*   character.  LNUM is the input line number within its source file.
*   TNAM is the treename of the input file containing LNUM.
}
module syn_get_line;
define syn_get_line;
%include 'syn2.ins.pas';

procedure syn_get_line (               {get source line info from char handle}
  in      char_handle: syn_char_t;     {handle to character to inquire about}
  out     lnum: sys_int_machine_t;     {line number within file, first = 1}
  in out  tnam: univ string_var_arg_t); {treename of file containing source line}
  val_param;

var
  ichar: sys_int_machine_t;            {character ID}
  cnum: sys_int_machine_t;             {character index into source line}
  sline: string_var4_t;                {source line}

begin
  sline.max := size_char(sline.str);   {init local var string}

  syn_get_char_line (                  {get all the info about this source character}
    char_handle,                       {handle to the source character}
    ichar,                             {character ID}
    cnum,                              {character index into the source line}
    sline,                             {source line containing the character}
    lnum,                              {line number within file}
    tnam);                             {source file treename}
  end;
