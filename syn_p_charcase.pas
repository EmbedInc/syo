{   SYN_P_CHARCASE (CC)
*
*   Set how the case of the input stream characters are handled for the purposes
*   of checking for match with the syntax.  CC should be one of the values
*   of mnemonics SYN_CHARCASE_xxx_K.  Currently (1990/8/19) the choices are:
*
*   SYN_CHARCASE_DOWN_K - Convert input characters to lower case before checking
*     syntax match.
*
*   SYN_CHARCASE_UP_K - Convert input characters to upper case before checking
*     syntax match.
*
*   SYN_CHARCASE_ASIS_K - Do not modify the case of input characters before
*     checking syntax match.
*
*   The new setting stays in effect until the next call to SYN_P_CHARCASE, or until
*   the end of the current syntax level.  The character case flag is popped when
*   the syntax level is popped to the parent's.
}
module syn_p_charcase;
define syn_p_charcase;
%include 'syn2.ins.pas';

procedure syn_p_charcase (             {set how to handle input character case}
  in      cc: syn_charcase_k_t);       {use SYN_CHARCASE_xxx_K constants}

begin
  charcase := cc;                      {save new flag value in common block}
  end;
