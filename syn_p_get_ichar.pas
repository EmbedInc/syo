{   SYN_P_GET_ICHAR (ICHAR)
*
*   Return the next input stream character as an integer value.  Normal characters
*   are ASCII and in the range of 0-127.  There are some special flag values that
*   are always negative.  Use the constants SYN_ICHAR_xxx_K to identify the special
*   flag values.  Currently (1990/8/19) these are:
*
*   SYN_ICHAR_EOL_K - End of a line.
*   SYN_ICHAR_EOF_K - End of a file.
*   SYN_ICHAR_EOD_K - End of all input data.
}
module syn_p_get_ichar;
define syn_p_get_ichar;
%include 'syn2.ins.pas';

procedure syn_p_get_ichar (            {get the next input character in an integer}
  out     ichar: sys_int_machine_t);   {0-127 char, or SYN_ICHAR_xxx_K special flags}

var
  cr_p: syn_crange_p_t;                {pointer to new character range descriptor}
  i: sys_int_machine_t;                {character number within line of char fetched}

begin
  if                                   {exhausted current character range ?}
      next_char.ofs >= next_char.crange_p^.n_chars
      then begin
    if next_char.crange_p^.next_p = nil
      then begin                       {this was last char range in chain}
        syn_range_next (cr_p);         {get pointer to next input char range}
        if cr_p = nil then begin       {no more input data at all ?}
          ichar := syn_ichar_eod_k;    {pass back "end of data"}
          return;
          end;
        cr_p^.prev_p := next_char.crange_p; {link new range on end of chain}
        next_char.crange_p^.next_p := cr_p;
        cr_p^.seq_n := next_crange_seq_n; {make unique number for new char range}
        next_crange_seq_n := next_crange_seq_n + 1; {update new seq number to use}
        next_char.crange_p := cr_p;    {make new char range the current char range}
        end
      else begin                       {old crange was not at end of chain}
        next_char.crange_p :=          {make next range in chain current}
          next_char.crange_p^.next_p;
        end
      ;                                {there is now a new current range}
    next_char.ofs := 0;                {new char comes from start of new crange}
    end;                               {done handling end of current crange}

  i :=                                 {char number within input file line}
    next_char.crange_p^.start_pos + next_char.ofs;
  ichar :=                             {fetch raw character from input file line}
    ord(next_char.crange_p^.line_p^.c[i]);
  if ichar > 127                       {make special flags negative in full word}
    then ichar := ichar ! ~127;

  case charcase of
syn_charcase_down_k: begin             {make sure all letters are lower case}
      if (ichar >= 65) and (ichar <= 90) {upper case character ?}
        then ichar := ichar + 32;
      end;
syn_charcase_up_k: begin               {make sure all letters are upper case}
      if (ichar >= 97) and (ichar <= 122) {lower case character ?}
        then ichar := ichar - 32;
      end;
    end;                               {done with charcase cases}

  if err_reparse
{
*   We are doing a re-parse on error.  Check for whether we got to the farthest
*   character that was parsed successfully.  If so, set the ERROR flag.  This tells
*   all syntax routines to exit immediately.
}
    then begin
      if                               {hit farthest point reached}
          (next_char.crange_p = far_char.crange_p) and
          (next_char.ofs = far_char.ofs)
        then error := true;
      end
{
*   We are doing a normal parse.  Update the farthest character parsed so this can be
*   used to terminate an error-reparse, if needed.
}
    else begin
      if                               {did we get farther than before ?}
          (next_char.crange_p^.seq_n > far_char.crange_p^.seq_n) or
          ((next_char.crange_p = far_char.crange_p) and
            (next_char.ofs > far_char.ofs))
          then begin
        far_char := next_char;         {save handle to farthest character}
        end;
      end
    ;

  next_char.ofs := next_char.ofs + 1;  {update offset for next character}
  end;
