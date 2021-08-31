{   Module of routines that set STAT as a result of various error conditions.
}
module syo_stat_set;
define syo_stat_set_syerr;
%include 'syo2.ins.pas';
{
*******************************************************************************
*
*   Subroutine SYO_STAT_SET_SYERR (STAT)
*
*   Set STAT to identify the particular syntax error.  This routine must only
*   be called after an error re-parse when a syntax error has occurred.
}
procedure syo_stat_set_syerr (         {set STAT to syntax error, after err reparse}
  out     stat: sys_err_t);            {set appropriately for syntax error}
  val_param;

var
  i: sys_int_machine_t;                {scratch integer and loop counter}
  char_h: syo_char_t;                  {handle to syntax error character}
  ichar: sys_int_machine_t;            {character value of error char}
  cnum: sys_int_machine_t;             {number of character within source line}
  sline: string_var132_t;              {source line containing error character}
  lnum: sys_int_machine_t;             {line number of source line within file}
  tnam: string_treename_t;             {treename of file containing error char}

begin
  sline.max := size_char(sline.str);   {init local var strings}
  tnam.max := size_char(tnam.str);

  syo_get_err_char (char_h);           {get handle to the syntax error character}
  syo_get_char_line (                  {get data about the offending character}
    char_h,                            {handle to the error character}
    ichar,                             {0-127 char value, or special flag}
    cnum,                              {character column number}
    sline,                             {source line containing character}
    lnum,                              {source line number within file}
    tnam);                             {treename of file containing line}

  case ichar of                        {handle special character flags}
syo_ichar_eol_k: begin                 {error character was end of line}
      sys_stat_set (syo_subsys_k, syo_stat_syerr_eol_k, stat);
      sys_stat_parm_int (lnum, stat);  {line number}
      sys_stat_parm_vstr (tnam, stat); {file name}
      sys_stat_parm_vstr (sline, stat); {source line}
      end;
syo_ichar_eof_k: begin                 {error character was end of file}
      sys_stat_set (syo_subsys_k, syo_stat_syerr_eof_k, stat);
      sys_stat_parm_vstr (tnam, stat); {file name}
      end;
syo_ichar_eod_k: begin                 {error character was end of data}
      sys_stat_set (syo_subsys_k, syo_stat_syerr_eod_k, stat);
      end;
otherwise                              {error on regular printable character}
    sys_stat_set (syo_subsys_k, syo_stat_syerr_at_k, stat);
    sys_stat_parm_int (lnum, stat);    {line number}
    sys_stat_parm_vstr (tnam, stat);   {file name}
    sys_stat_parm_vstr (sline, stat);  {source line}
    sline.len := 0;                    {init pointer line to empty}
    for i := 2 to cnum do begin        {once for each space before the pointer}
      string_append1 (sline, ' ');
      end;
    string_append1 (sline, '^');       {add pointer to err character in line above}
    sys_stat_parm_vstr (sline, stat);  {error pointer line}
    end;                               {done with error character special cases}
  end;
