{   Module of routines that add parameters to STAT.
}
module syn_addstat;
define syn_addstat_line;
define syn_addstat_char;
%include 'syn2.ins.pas';
{
*******************************************************************************
*
*   Subroutine SYN_ADDSTAT_LINE (CHAN_HANDLE, STAT)
*
*   Add line number and file name parameters to STAT, in that order.  STAT
*   must have been previously set to a particular status code with SYS_STAT_SET.
}
procedure syn_addstat_line (           {add line number and file name to STAT}
  in      char_handle: syn_char_t;     {handle to character to inquire about}
  in out  stat: sys_err_t);            {will have LNUM and FNAM parameters added}
  val_param;

var
  fnam: string_treename_t;             {file name}
  lnum: sys_int_machine_t;             {line number within the file}

begin
  fnam.max := size_char(fnam.str);     {init local var string}

  syn_get_line (char_handle, lnum, fnam); {get line number and file name}
  sys_stat_parm_int (lnum, stat);      {add line number parameter}
  sys_stat_parm_vstr (fnam, stat);     {add file name parameter}
  end;
{
*******************************************************************************
*
*   Subroutine SYN_ADDSTAT_CHAR (CHAR_H, STAT)
*
*   Add two string parameters to STAT to indicate a particular source
*   character.  The first parameter will the the source line containing the
*   character, and the second parameter will be a line with an up arrow
*   pointing to the selected character in the line above.  Both these
*   lines are intended to be displayed in fixed format (.NFILL) mode.
}
procedure syn_addstat_char (           {add STAT parms to show line and pnt to char}
  in      char_handle: syn_char_t;     {handle to character to show}
  in out  stat: sys_err_t);            {will have two string parms added}
  val_param;

var
  i: sys_int_machine_t;                {scratch integer and loop counter}
  ichar: sys_int_machine_t;            {character value of error char}
  cnum: sys_int_machine_t;             {number of character within source line}
  sline: string_var132_t;              {source line containing error character}
  lnum: sys_int_machine_t;             {line number of source line within file}
  tnam: string_treename_t;             {treename of file containing error char}

begin
  sline.max := size_char(sline.str);   {init local var strings}
  tnam.max := size_char(tnam.str);

  syn_get_char_line (                  {get data about the offending character}
    char_h,                            {handle to the error character}
    ichar,                             {0-127 char value, or special flag}
    cnum,                              {character column number}
    sline,                             {source line containing character}
    lnum,                              {source line number within file}
    tnam);                             {treename of file containing line}

  sys_stat_parm_vstr (sline, stat);    {add source line text as parameter}
  sline.len := 0;                      {init pointer line to empty}
  for i := 2 to cnum do begin          {once for each space before the pointer}
    string_append1 (sline, ' ');
    end;
  string_append1 (sline, '^');         {add pointer to err character in line above}
  sys_stat_parm_vstr (sline, stat);    {add line with pointer to indicated char}
  end;
