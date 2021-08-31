{   Subroutine SYO_INFILE_READ (LINE_P, STAT)
*
*   Read the next line from the current input files.  LINE_P will be returned
*   pointing to the descriptor for this input line.  When an end of file is
*   encountered, input will automatically be popped to the previous input file.
*   and EOF (end of file) character will be returned at the end of each file.
*   EOD (end of data) characters will be returned continuously after the end of
*   the top input file.
*
*   STAT is the completion status code.  STAT will indicate end of file whenever
*   a line is returned that contains an end of file.  Only the FILE_P field
*   of LINE_P^ will be valid when STAT is indicating a real error.
}
module syo_INFILE_READ;
define syo_infile_read;
%include 'syo2.ins.pas';

procedure syo_infile_read (            {read next line from current input file}
  out     line_p: syo_line_p_t;        {will point to descriptor for line from file}
  out     stat: sys_err_t);            {completion status code}

var
  buf: string_var8192_t;               {one line input buffer}
  f_p: syo_file_p_t;                   {pnt to real source file descriptor}
  f_name_p: syo_file_p_t;              {pnt to "pretend" source file descriptor}
  n_spec: sys_int_machine_t;           {number of special chars needed at line end}
  sz: sys_int_adr_t;                   {amount of memory needed}
  i: sys_int_machine_t;                {loop counter}
  eol, eof, eod: boolean;              {TRUE if associated char needed at line end}

label
  loop_file;

begin
  sys_error_none (stat);               {init to no error}
  buf.max := sizeof(buf.str);          {init local var string}
  buf.len := 0;                        {init number of chars to return}
  eol := false;                        {init to special chars not needed at line end}
  eof := false;
  eod := false;
  n_spec := 0;

loop_file:                             {back here after popping to old input file}
  f_p := file_p;                       {save pointer to source file descriptor}
  f_name_p := file_name_p;             {save pointer to logical source file desc}

  if file_p = nil
    then begin                         {no current input file exists}
      eod := true;                     {pass back end of data}
      n_spec := n_spec + 1;            {one more special char needed at end of line}
      end
    else begin                         {there is a current input file}
      if file_p^.eof then begin        {already got to end of current file ?}
        syo_infile_pop;                {pop back to previous input file}
        goto loop_file;                {try again with new input file}
        end;
      file_read_text (file_p^.conn_p^, buf, stat); {read next line from input file}
      if file_eof(stat)
        then begin                     {we just hit end of this file}
          buf.len := 0;                {no line contents to pass back}
          eof := true;                 {indicate to pass back EOF character}
          n_spec := n_spec + 1;        {one more special char needed at end of line}
          syo_infile_pop;              {close this file and pop back to previous}
          end
        else begin                     {not hit end of this file}
          if sys_error(stat) then begin {encountered a hard error ?}
            sz := sizeof(line_p^) - sizeof(line_p^.c); {size of line descriptor}
            util_mem_grab (sz, mem_context_p^, false, line_p); {alloc mem}
            line_p^.file_p := file_p;  {fill in just enough to return error info}
            return;
            end;
          eol := true;                 {we need EOL character at end of line}
          n_spec := n_spec + 1;        {one more special char needed at end of line}
          end
        ;
      end                              {done handling input file exists}
    ;
{
*   BUF, EOL, EOF, EOD, N_SPEC, F_P, and F_NAME_P are all set.  Use this
*   information to build the line descriptor to pass back.
}
  sz := sizeof(line_p^) - sizeof(line_p^.c) + {size of line descriptor}
    (sizeof(line_p^.c[1]) * (buf.len + n_spec));
  util_mem_grab (sz, mem_context_p^, false, line_p); {alloc mem for line desc}

  for i := 1 to buf.len do begin       {once for each character from input file}
    line_p^.c[i] := chr(ord(buf.str[i]) & 127); {save character with parity bit off}
    end;                               {back and copy next character from file}
  i := buf.len;                        {set number of characters in line descriptor}

  if eol then begin                    {need end of line character ?}
    i := i + 1;
    line_p^.c[i] := chr(syo_ichar_eol_k);
    end;

  if eof then begin                    {need end of file character ?}
    i := i + 1;
    line_p^.c[i] := chr(syo_ichar_eof_k);
    sys_stat_set (file_subsys_k, file_stat_eof_k, stat); {indicate end of file status}
    end;

  if eod then begin                    {need end of data character ?}
    i := i + 1;
    line_p^.c[i] := chr(syo_ichar_eod_k);
    end;

  line_p^.n_chars := i;                {set final number of chars in line descriptor}
  if f_name_p = nil
    then begin                         {logical file is real input file}
      line_p^.file_p := f_p;           {indicate real source file}
      if f_p = nil
        then line_p^.line_n := 0       {no file, set arbitrary line number}
        else line_p^.line_n := f_p^.conn_p^.lnum; {use real line number}
      end
    else begin                         {logical input file is in use}
      line_p^.file_p := f_name_p;      {indicate logical source file}
      f_name_p^.conn_p^.lnum := f_name_p^.conn_p^.lnum + 1; {update logical src line number}
      line_p^.line_n := f_name_p^.conn_p^.lnum;
      end
    ;
  end;
