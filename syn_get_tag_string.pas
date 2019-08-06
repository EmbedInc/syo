{   SYN_GET_TAG_STRING (STRING_HANDLE,S)
*
*   Get the actual string associated with a syntax tag.  The string is identified
*   by STRING_HANDLE, which comes from subroutine SYN_GET_TAG.
}
module syn_get_tag_string;
define syn_get_tag_string;
%include 'syn2.ins.pas';

procedure syn_get_tag_string (         {get string associated with a tag}
  in      string_handle: syn_string_t; {handle from SYN_GET_TAG}
  in out  s: univ string_var_arg_t);   {returned string}

var
  curr_c: syn_char_t;                  {descriptor for current character}
  line_p: ^string;                     {pointer to curr raw input characters}
  line_i: sys_int_machine_t;           {curr char number within input line}

label
  new_crange;

begin
  s.len := 0;                          {init length of returned string}
  if s.max <= 0 then return;           {no room to put any characters ?}
  curr_c := string_handle.first_char;  {init current char to first in string}

new_crange:                            {jump back here for each new crange}
  line_p := addr(curr_c.crange_p^.line_p^.c); {cache pointer to raw input line}
  line_i := curr_c.crange_p^.start_pos + curr_c.ofs; {init index to first char}

  while                                {keep looping until ending character}
      (curr_c.crange_p <> string_handle.last_char.crange_p) or
      (curr_c.ofs < string_handle.last_char.ofs)
      do begin
    if curr_c.ofs >= curr_c.crange_p^.n_chars then begin {exhausted this crange ?}
      curr_c.crange_p := curr_c.crange_p^.next_p; {point to next crange in chain}
      curr_c.ofs := 0;                 {next char is first in new crange}
      goto new_crange;                 {jump back to handle swapping in new crange}
      end;                             {done swapping in new crange}
    s.len := s.len + 1;                {one more character in returned string}
    s.str[s.len] := line_p^[line_i];   {fetch input character and put in string}
    if s.len >= s.max then return;     {completely filled output string ?}
    curr_c.ofs := curr_c.ofs + 1;      {advance character indicies}
    line_i := line_i + 1;
    end;                               {back and process next input character}
  end;
