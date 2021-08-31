{   SYO_P_TEST_EOF (MFLAG)
*
*   Return "syntax matched" if the next input character is an end of file.
}
module syo_p_test_eof;
define syo_p_test_eof;
%include 'syo2.ins.pas';

procedure syo_p_test_eof (             {compare next input char with end of file}
  out     mflag: syo_mflag_k_t);       {syntax matched yes/no, use SYO_MFLAG_xxx_K}

var
  c: sys_int_machine_t;                {next input character}

begin
  syo_p_start_routine ('$EOF', 4);     {start new syntax level}
  syo_p_get_ichar (c);                 {get next input stream character}
  if c = syo_ichar_eof_k
    then mflag := syo_mflag_yes_k
    else mflag := syo_mflag_no_k;
  syo_p_end_routine (mflag);           {close this syntax level}
  end;
