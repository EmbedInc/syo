{   Subroutine SYO_ERROR_ABORT (STAT,STR_H,SUBSYS,MSG_NAME,MSG_PARM,N_PARMS)
*
*   Print error messages and abort is STAT is indicating an abnormal condition.
*   STR_H is the handle to the input string related to the error.  The remaining
*   arguments identify a standard message with parameters.
}
module syo_ERROR_ABORT;
define syo_error_abort;
%include 'syo2.ins.pas';

procedure syo_error_abort (            {abort and print messages on error status}
  in      stat: sys_err_t;             {error status code}
  in      str_h: syo_string_t;         {handle to input string related to error}
  in      subsys: string;              {msg file generic name}
  in      msg_name: string;            {message name}
  in      msg_parm: univ sys_parm_msg_ar_t; {parameter references for the message}
  in      n_parms: sys_int_machine_t); {number of parameters passed to message}

begin
  if not sys_error(stat) then return;  {no error condition ?}

  sys_error_print (stat, '', '', nil, 0); {print error message from STAT}
  syo_error (str_h, subsys, msg_name, msg_parm, n_parms); {print other err messages}
  end;
