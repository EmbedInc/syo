{   Subroutine SYO_PREPROC_DEFAULT (LINE_P, START_CHAR, N_CHARS)
*
*   Default pre-processor.  This pre-processor passes thru the top level
*   input file unaltered.
}
module syo_PREPROC_DEFAULT;
define syo_preproc_default;
%include 'syo2.ins.pas';

procedure syo_preproc_default (        {default pre-processor installed by SYO lib}
  out     line_p: syo_line_p_t;        {points to descriptor for line chars are from}
  out     start_char: sys_int_machine_t; {starting char within line, first = 1}
  out     n_chars: sys_int_machine_t); {number of characters returned by this call}

const
  max_msg_parms = 2;                   {max parameters we can pass to a message}

var
  msg_parm:                            {parameter references for messages}
    array[1..max_msg_parms] of sys_parm_msg_t;
  stat: sys_err_t;                     {completion status code}

begin
  syo_infile_read (line_p, stat);      {read next line from input file}
  discard(file_eof(stat));             {end of file condition is not an error}
  if sys_error(stat) then begin        {hard error on trying to read input file ?}
    sys_msg_parm_int (msg_parm[1], line_p^.line_n);
    sys_msg_parm_vstr (msg_parm[2], line_p^.file_p^.conn_p^.tnam);
    sys_error_abort (stat, 'syn', 'syntax_error_msg', msg_parm, 2);
    end;
  start_char := 1;                     {always indicate the whole line}
  n_chars := line_p^.n_chars;
  end;
