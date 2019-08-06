{   Subroutine SYN_GET_NAME (NAME)
*
*   Return the name of the current syntax level.  The name will be returned as
*   the null string when in a non-existant level.  This can happen when
*   SYN_LEVEL_DOWN was called more times than there were levels.
}
module syn_get_name;
define syn_get_name;
%include 'syn2.ins.pas';

procedure syn_get_name (               {get name of current syntax level}
  in out  name: univ string_var_arg_t); {will be empty if at non-existant level}

begin
  name.len := 0;                       {init name string length}
  if fake_levels > 0 then return;      {in non-existant level ?}
  string_appendn (                     {append specific num of characters to NAME}
    name,                              {string to append to}
    level_header_p^.name_p^,           {characters to append}
    level_header_p^.name_len);         {number of characters to append}
  end;
