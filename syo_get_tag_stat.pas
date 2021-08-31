{   Subroutine SYO_GET_TAG_STAT (TAG, STRING_HANDLE, STAT)
*
*   Get the next tag from the syntax tree at the current level, and the
*   handle to its associated string.  STAT is returned as no error if
*   TAG contains an application tag (> 0) or SYO_TAG_END_k.  STAT is
*   set to an apporpriate error status on syntax error.
}
module syo_get_tag_stat;
define syo_get_tag_stat;
%include 'syo2.ins.pas';

procedure syo_get_tag_stat (           {get next tag, STAT set on syntax error}
  out     tag: sys_int_machine_t;      {app tag value or END or ERR}
  out     string_handle: syo_string_t; {handle to string for this tag}
  out     stat: sys_err_t);            {OK for app or END tag, error for ERR tag}
  val_param;

var
  char_h: syo_char_t;                  {handle to error character}
  ichar: sys_int_machine_t;            {character value of error char}
  cnum: sys_int_machine_t;             {number of character within source line}
  sline: string_var132_t;              {source line containing error character}
  lnum: sys_int_machine_t;             {line number of source line within file}
  tnam: string_treename_t;             {treename of file containing error char}
  i: sys_int_machine_t;                {scratch integer}

begin
  sys_error_none (stat);               {init to no error}
  syo_get_tag (tag, string_handle);    {get the tag}
  if                                   {not an error ?}
      (tag >= 1) or                    {app tag ?}
      (tag = syo_tag_end_k)            {end of this syntax level ?}
    then return;                       {return with no error}
{
*   This tag is indicating a syntax error.  The end of the error re-parse
*   syntax tree has been reached.
}
  sline.max := size_char(sline.str);   {init local var strings}
  tnam.max := size_char(tnam.str);

  syo_get_err_char (char_h);           {get handle to error character}
  syo_get_char_line (                  {get info about the error character}
    char_h,                            {handle to source character}
    ichar,                             {character code}
    cnum,                              {character index into the source line}
    sline,                             {raw source line containing the character}
    lnum,                              {source line number within its file}
    tnam);                             {source file treename}

  case ichar of                        {handle special character flags}
syo_ichar_eol_k: begin                 {error character was end of line}
      sys_stat_set (syo_subsys_k, syo_stat_syerr_eol_k, stat);
      sys_stat_parm_int (lnum, stat);
      sys_stat_parm_vstr (tnam, stat);
      sys_stat_parm_vstr (sline, stat);
      end;
syo_ichar_eof_k: begin                 {error character was end of file}
      sys_stat_set (syo_subsys_k, syo_stat_syerr_eof_k, stat);
      sys_stat_parm_vstr (tnam, stat);
      end;
syo_ichar_eod_k: begin                 {error character was end of data}
      sys_stat_set (syo_subsys_k, syo_stat_syerr_eod_k, stat);
      end;
otherwise                              {error on regular printable character}
    sys_stat_set (syo_subsys_k, syo_stat_syerr_at_k, stat);
    sys_stat_parm_int (lnum, stat);
    sys_stat_parm_vstr (tnam, stat);
    sys_stat_parm_vstr (sline, stat);
    sline.len := 0;                    {reset string to empty}
    for i := 2 to cnum do begin        {once for each blank before pointer}
      string_append1 (sline, ' ');
      end;
    string_append1 (sline, '^');       {up arrow pointing to offending character}
    sys_stat_parm_vstr (sline, stat);
    end;
  end;
