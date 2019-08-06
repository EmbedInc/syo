{   SYN_P_TEST_STRING (MFLAG,STR,LEN)
*
*   Test whether the next input stream characters match the string STR.  LEN is
*   the number of characters in STR.  MFLAG is returned to indicate whether the
*   string matched the input or not.  Currently (1990/8/19), possible values
*   for MFLAG are:
*
*   SYN_MFLAG_NO_K - Input did not match string.
*   SYN_MFLAG_YES_K - Input did match string.
}
module syn_p_test_string;
define syn_p_test_string;
%include 'syn2.ins.pas';

procedure syn_p_test_string (          {compare string with input stream}
  out     mflag: syn_mflag_k_t;        {syntax matched yes/no flag}
  in      str: string;                 {the string to compare}
  in      len: sys_int_machine_t);     {number of characters in STR}

var
  i: sys_int_machine_t;                {loop counter}
  c: sys_int_machine_t;                {character from input stream}

begin
  syn_p_start_routine ('$STRING', 7);  {enter syntax check routine}

  for i := 1 to len do begin           {once for each character to test}
    syn_p_get_ichar (c);               {get next character from input stream}
    if error then exit;                {error abort ?}
    if c <> ord(str[i]) then begin     {definately a mismatch ?}
      mflag := syn_mflag_no_k;         {return NO answer}
      syn_p_end_routine (mflag);
      return;
      end;
    end;                               {back and try next character}

  mflag := syn_mflag_yes_k;            {return YES answer}
  syn_p_end_routine (mflag);
  end;
