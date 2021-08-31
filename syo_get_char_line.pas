{   Subroutine SYO_GET_CHAR_LINE (CHAR_HANDLE, ICHAR, CNUM, SLINE, LNUM, TNAM)
*
*   Get the source line and some other information, given the handle to a particular
*   input stream character.  CHAR_HANDLE is the handle to the input stream
*   character.  ICHAR is returned the character value.  Normal characters are
*   positive, and special flag values are negative.  Use constants SYO_ICHAR_xxx_K
*   for the special flag values.  CNUM is the number of the character within the
*   source line.  SLINE is returned as the raw input line the
*   character came from.  LNUM is the input line number within its source file.
*   TNAM is the treename of the input file containing LNUM.
}
module syo_get_char_line;
define syo_get_char_line;
%include 'syo2.ins.pas';

procedure syo_get_char_line (          {get source line and context for a character}
  in      char_handle: syo_char_t;     {handle to character to inquire about}
  out     ichar: sys_int_machine_t;    {0-127 char, or SYO_ICHAR_xxx_K special flags}
  out     cnum: sys_int_machine_t;     {character index into source line}
  in out  sline: univ string_var_arg_t; {raw source line containing character}
  out     lnum: sys_int_machine_t;     {line number within file, first = 1}
  in out  tnam: univ string_var_arg_t); {treename of file containing source line}
  val_param;

var
  ch: syo_char_t;                      {local handle to character actually used}
  nchar: sys_int_machine_t;            {number of normal characters in input line}

begin
  cnum := 0;                           {init number character within source line}
  sline.len := 0;                      {init input line from file}
  lnum := 0;                           {init input line number in file}
  tnam.len := 0;                       {init file treename}
  ch := char_handle;                   {init char to use to user's character}

  while                                {loop until find a real character}
      ch.ofs >= ch.crange_p^.n_chars
      do begin
    if ch.crange_p^.next_p = nil then begin {hit end of input stream ?}
      ichar := syo_ichar_eod_k;        {indicate end of input stream}
      return;
      end;
    ch.crange_p := ch.crange_p^.next_p; {advance to next crange in chain}
    ch.ofs := 0;                       {init to at start of new crange}
    end;                               {back and try again with new crange}

  with ch.crange_p^.line_p^: line do begin {LINE is descriptor for this input line}
    cnum := ch.crange_p^.start_pos + ch.ofs; {source line index for this char}
    ichar := ord(line.c[cnum]);        {fetch raw source line character}
    if ichar > 127                     {make special flags negative in full word}
      then ichar := ichar ! ~127;
    nchar := line.n_chars;             {init size of raw input line}
    while
        (nchar > 0) and then           {still chars left on this line ?}
        (ord(line.c[nchar]) > 127)     {last char is special char ?}
        do begin
      nchar := nchar - 1;              {chop off trailing character}
      end;                             {back and test new last character on line}
    string_appendn (sline, line.c, nchar); {return copy of input line}
    lnum := line.line_n;               {return line number within file}
    if line.file_p <> nil then begin   {this character came from a file ?}
      string_copy (line.file_p^.conn_p^.tnam, tnam); {return source file treename}
      end;
    end;                               {done with LINE abbreviation}
  end;
