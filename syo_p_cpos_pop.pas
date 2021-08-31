{   SYO_P_CPOS_POP (MFLAG)
*
*   Pop the state from the stack that was pushed with SYO_P_CPOS_PUSH.  MFLAG
*   indicates whether the syntax check was successful.  If so, then the data
*   is only popped from the stack and not made current.  If the syntax did not
*   match, then the current state is restored to what it was then SYO_P_CPOS_PUSH
*   was called.
}
module syo_p_cpos_pop;
define syo_p_cpos_pop;
%include 'syo2.ins.pas';

procedure syo_p_cpos_pop (             {pop current character position from stack}
  in      mflag: syo_mflag_k_t);       {syntax matched yes/no flag}

var
  p: stack_frame_cpos_p_t;             {points to stack frame that holding state}

begin
  util_stack_last_frame (pstack, sizeof(p^), p); {get pointer stack frame}
  if mflag <> syo_mflag_yes_k then begin {restore state from stack frame ?}
    next_char := p^.next_char;         {restore current state from stack frame}
    charcase := p^.charcase;
    util_stack_popto (sytree, p^.tree_pos);
    end;
  util_stack_popto (pstack, p);        {deallocate stack frame}
  end;
