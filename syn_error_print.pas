{   Module of routines for dealing with syntax error messages.
}
module syn_error_print;
define syn_error_syntax;
define syn_error_print;
%include 'syn2.ins.pas';
{
************************************************************************
*
*   Subroutine SYN_ERROR_SYNTAX (SUBSYS, M_NAME, PARMS, N_PARMS)
*
*   Print syntax error and return to the caller.  This routine may only
*   be called after an error re-parse.
}
procedure syn_error_syntax (           {print syntax error message and bomb}
  in      subsys: string;              {subsystem containing error message}
  in      m_name: string;              {name of message within subsystem}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter references for message}
  in      n_parms: sys_int_machine_t); {number of parameters in PARMS}
  val_param;

const
  max_msg_parms = 2;                   {max parameters we can pass to a message}

var
  i: sys_int_machine_t;                {scratch integer}
  lnum: sys_int_machine_t;             {line number of source line within file}
  ichar: sys_int_machine_t;            {character value of error char}
  cnum: sys_int_machine_t;             {number of character within source line}
  char_h: syn_char_t;                  {handle to error character}
  sline: string_var132_t;              {source line containing error character}
  tnam: string_treename_t;             {treename of file containing error char}
  user_msg: boolean;                   {TRUE if caller supplied error message}
  msg_parm:                            {parameter references for messages}
    array[1..max_msg_parms] of sys_parm_msg_t;

begin
  sline.max := sizeof(sline.str);      {init local var strings}
  tnam.max := sizeof(tnam.str);
{
*   Set USER_MSG TRUE if the caller did supply a message.
}
  string_vstring (sline, subsys, sizeof(subsys));
  user_msg := sline.len > 0;
  string_vstring (sline, m_name, sizeof(m_name));
  user_msg := user_msg and (sline.len > 0); {TRUE if user supplied a message}
{
*   Print the caller's message if there is one, otherwise print a
*   generic "syntax error" message.
}
  if user_msg
    then begin                         {the caller did supply a message}
      sys_message_parms (subsys, m_name, parms, n_parms); {write caller's message}
      end
    else begin
      sys_message ('syn', 'syntax_error'); {write generic message}
      end
    ;
{
*   Show the source line and character, if applicable, of the syntax error.
}
  syn_get_err_char (char_h);           {get handle to error character}
  syn_get_char_line (char_h, ichar, cnum, sline, lnum, tnam); {get data about err char}
  sys_msg_parm_int (msg_parm[1], lnum);
  sys_msg_parm_vstr (msg_parm[2], tnam);

  case ichar of                        {handle special character flags}
syn_ichar_eol_k: begin                 {error character was end of line}
      sys_message_parms ('syn', 'syntax_error_eol', msg_parm, 2);
      writeln (sline.str:sline.len);   {print source line containing error character}
      end;
syn_ichar_eof_k: begin                 {error character was end of file}
      sys_message_parms ('syn', 'syntax_error_eof', msg_parm, 2);
      end;
syn_ichar_eod_k: begin                 {error character was end of data}
      sys_message ('syn', 'syntax_error_eod');
      end;
otherwise                              {error on regular printable character}
    sys_message_parms ('syn', 'syntax_error_char', msg_parm, 2);
    writeln (sline.str:sline.len);     {print source line containing error character}
    i := cnum - 1;                     {number of columns before error character}
    writeln ('':i, '^');               {write pointer to error character}
    end;                               {done with error character special cases}
  end;
{
************************************************************************
*
*   Subroutine SYN_ERROR_PRINT (SUBSYS, M_NAME, PARMS, N_PARMS)
*
*   Print syntax error and bomb.  This routine may only be called after
*   an error re-parse.
}
procedure syn_error_print (            {print syntax error message and bomb}
  in      subsys: string;              {subsystem containing error message}
  in      m_name: string;              {name of message within subsystem}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter references for message}
  in      n_parms: sys_int_machine_t); {number of parameters in PARMS}
  options (val_param, noreturn);

begin
  syn_error_syntax (subsys, m_name, parms, n_parms);
  sys_bomb;
  end;
