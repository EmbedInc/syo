{   Subroutine SYN_ERROR (STR_H,SUBSYS,MSG_NAME,MSG_PARM,N_PARMS)
*
*   Print error message associated with a particular input stream string.
*   STR_H is the handle to the input stream string.  It was most likely returned
*   from one of the SYN_GET_TAG routines.
*
*   The remaining call arguments for a standard message specification.
}
module syn_ERROR;
define syn_error;
%include 'syn2.ins.pas';

procedure syn_error (                  {error occurred while reading input}
  in      str_h: syn_string_t;         {handle to input string with error}
  in      subsys: string;              {msg file generic name}
  in      msg_name: string;            {message name}
  in      msg_parm: univ sys_parm_msg_ar_t; {parameter references for the message}
  in      n_parms: sys_int_machine_t); {number of parameters passed to message}
  options (noreturn);

var
  ichar: sys_int_machine_t;            {character value of error char}
  cnum: sys_int_machine_t;             {number of character within source line}
  sline: string_var132_t;              {source line containing error character}
  lnum: sys_int_machine_t;             {line number of source line within file}
  tnam: string_treename_t;             {treename of file containing error char}
  m_parm:                              {parameters for our own messages}
    array[1..2] of sys_parm_msg_t;
  i: sys_int_machine_t;                {scratch integer}

begin
  sline.max := sizeof(sline.str);      {init var strings}
  tnam.max := sizeof(tnam.str);

  string_vstring (sline, subsys, sizeof(subsys));
  string_vstring (sline, msg_name, sizeof(msg_name));

  sys_message_parms (subsys, msg_name, msg_parm, n_parms); {write application message}

  syn_get_char_line (                  {get data about first char of string}
    str_h.first_char,                  {handle to first char of offending string}
    ichar,                             {0-127 char value, or special flag}
    cnum,                              {character column number}
    sline,                             {source line containing character}
    lnum,                              {source line number within file}
    tnam);                             {treename of file containing line}
  sys_msg_parm_int (m_parm[1], lnum);
  sys_msg_parm_vstr (m_parm[2], tnam);

  case ichar of                        {handle special character flags}
syn_ichar_eol_k: begin                 {error character was end of line}
      sys_message_parms ('syn', 'error_eol', m_parm, 2);
      writeln (sline.str:sline.len);   {print source line containing error character}
      end;
syn_ichar_eof_k: begin                 {error character was end of file}
      sys_message_parms ('syn', 'error_eof', m_parm, 2);
      end;
syn_ichar_eod_k: begin                 {error character was end of data}
      sys_message ('syn', 'error_eod');
      end;
otherwise                              {error on regular printable character}
    sys_message_parms ('syn', 'error_char', m_parm, 2);
    writeln (sline.str:sline.len);     {print source line containing error character}
    i := cnum - 1;                     {number of columns before error character}
    writeln ('':i, '^');               {write pointer to error character}
    end;                               {done with error character special cases}
  sys_bomb;                            {abort program with error}
  end;
