{   Subroutine SYO_ERROR_TAG_UNEXP (TAG,STR_H)
*
*   Print error about unexpected syntax tag value.  TAG is the syntax tag value,
*   and STR_H is the string handle associated with that tag.  This routines
*   is intended to be useful in the OTHERWISE section of a case statement for
*   the possible tag values.
}
module syo_ERROR_TAG_UNEXP;
define syo_error_tag_unexp;
%include 'syo2.ins.pas';

procedure syo_error_tag_unexp (        {got unexpected syntax tag value}
  in      tag: sys_int_machine_t;      {value of syntax tag}
  in      str_h: syo_string_t);        {handle to string for this tag}
  options (noreturn);

var
  msg_parm:                            {parameter references for messages}
    array[1..1] of sys_parm_msg_t;

begin
  sys_msg_parm_int (msg_parm[1], tag);
  syo_error (str_h, 'syn', 'tag_unexpected', msg_parm, 1);
  end;
