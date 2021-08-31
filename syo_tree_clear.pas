{   SYO_TREE_CLEAR
*
*   Delete the old syntax tree, and set up for another parse operation.  It is not
*   necessary to call this routine directly after a call to SYO_INIT.  The SYN
*   library is initialized in a state ready for parsing.
}
module syo_tree_clear;
define syo_tree_clear;
%include 'syo2.ins.pas';

procedure syo_tree_clear;              {clear syntax tree, setup for parsing}

begin
  util_stack_dalloc (sytree);          {reset syntax tree to empty}
  util_stack_alloc (mem_context_p^, sytree);

  util_stack_dalloc (pstack);          {reset parsing stack to empty}
  util_stack_alloc (mem_context_p^, pstack);

  err_reparse := false;

  if next_char.crange_p = nil then begin {start char range not yet set ?}
    syo_range_next (next_char.crange_p); {init next character to first in file}
    next_char.ofs := 0;
    start_char := next_char;           {save handle to first input character}
    far_char := next_char;             {init handle to farthest char used so far}
    end;

  syo_reset;                           {do common initialization with SYO_INIT}
  end;
