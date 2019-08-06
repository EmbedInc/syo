{   SYN_P_TEST_EOD (MFLAG)
*
*   Return "syntax matched" if the next input character is "end of input data."
}
module syn_p_test_eod;
define syn_p_test_eod;
%include 'syn2.ins.pas';

procedure syn_p_test_eod (             {compare next input char with end of data}
  out     mflag: syn_mflag_k_t);       {syntax matched yes/no, use SYN_MFLAG_xxx_K}

var
  c: sys_int_machine_t;                {next input character}

begin
  syn_p_start_routine ('$EOD', 4);     {start new syntax level}
  syn_p_get_ichar (c);                 {get next input stream character}
  if c = syn_ichar_eod_k
    then mflag := syn_mflag_yes_k
    else mflag := syn_mflag_no_k;
  syn_p_end_routine (mflag);           {close this syntax level}
  end;
