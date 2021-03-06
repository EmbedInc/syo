{   SYO_RESET
*
*   Reset the SYO library state so that a parse routine can be called next.
*   This subroutine is called from SYO_INIT and SYO_TREE_CLEAR to do common reset.
}
module syo_reset;
define syo_reset;
%include 'syo2.ins.pas';

procedure syo_reset;                   {set up for parsing from INIT state}

begin
  tframe_p := nil;                     {init to above all syntax levels}
  charcase := syo_charcase_asis_k;     {reset character case conversion flag}
  made_tag := false;                   {reset to no tags in syntax tree}
  error := false;                      {not reached error char in error re-parse}

  if err_reparse
    then begin                         {re-parsing because got syntax error earlier}
      next_char := start_char;         {reset starting input stream character}
      end
    else begin                         {parsing new syntax}
      start_char := next_char;         {remember where this parse started}
      end
    ;
  end;
