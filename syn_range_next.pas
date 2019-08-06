{   SYN_RANGE_NEXT (P)
*
*   Create and return pointer to the next input characters range descriptor.
*   P is returned as NIL if there is no more input available.
*   This routine will assemble a character range descriptor from the information
*   returned by the current pre-processor.
*
*   The character range descriptor will be returned not linked to any chain.
}
module syn_range_next;
define syn_range_next;
%include 'syn2.ins.pas';

procedure syn_range_next (             {create and return pointer to next char range}
  out     p: syn_crange_p_t);          {pointer to new char range, NIL = end of input}

var
  line_p: syn_line_p_t;                {points to descriptor for source line}
  start_char: sys_int_machine_t;       {number of first char from source line}
  n_chars: sys_int_machine_t;          {number of characters from source line}

%debug; i: sys_int_machine_t;          {used for echoing resolved input stream}
%debug; v: sys_int_machine_t;

begin
  repeat                               {loop to ignore no characters returned}
    syn_preproc_p^ (line_p, start_char, n_chars); {get next chars from pre-processor}
    until n_chars > 0;

  util_mem_grab (sizeof(p^), mem_context_p^, false, p); {allocate crange descriptor}

  p^.line_p := line_p;                 {fill in character range descriptor}
  p^.start_pos := start_char;
  p^.n_chars := n_chars;
  p^.seq_n := next_crange_seq_n;
  p^.next_p := nil;
  p^.prev_p := nil;

  next_crange_seq_n := next_crange_seq_n + 1; {update sequence num for next crange}

%debug;                                {
%debug; *   Echo the input stream to the user for debugging purposes.
%debug; }
%debug;   for i := p^.start_pos to p^.start_pos+p^.n_chars-1 do begin
%debug;     v := ord(p^.line_p^.c[i]);
%debug;     if v > 127
%debug;       then begin               {this is a special character}
%debug;         v := v ! ~127;         {make special character integer value}
%debug;         case v of
%debug; syn_ichar_eol_k: begin
%debug;             writeln;
%debug;             end;
%debug; syn_ichar_eof_k: begin
%debug;             writeln ('**EOF**');
%debug;             end;
%debug; syn_ichar_eod_k: begin
%debug;             writeln ('**EOD**');
%debug;             end;
%debug;           end;
%debug;         end
%debug;       else begin               {regular character}
%debug;         write (p^.line_p^.c[i]);
%debug;         end
%debug;       ;
%debug;     end;                       {back and process next character}

  end;
