{   SYO_P_CPOS_PUSH
*
*   Push the current input stream state on the stack.  The state can be popped
*   with subroutine SYO_P_CPOS_POP.
}
module syo_p_cpos_push;
define syo_p_cpos_push;
%include 'syo2.ins.pas';

procedure syo_p_cpos_push;             {save current character position on stack}

var
  p: stack_frame_cpos_p_t;             {points to new stack frame}

begin
  util_stack_push (pstack, sizeof(p^), p); {create a stack frame}
  p^.next_char := next_char;           {save current state in new stack frame}
  p^.charcase := charcase;
  util_stack_last_frame (sytree, 0, p^.tree_pos); {save curr syntax tree position}
  end;
