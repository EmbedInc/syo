{   SYN_P_CPOS_POP (MFLAG)
*
*   Pop the state from the stack that was pushed with SYN_P_CPOS_PUSH.  MFLAG
*   indicates whether the syntax check was successful.  If so, then the data
*   is only popped from the stack and not made current.  If the syntax did not
*   match, then the current state is restored to what it was then SYN_P_CPOS_PUSH
*   was called.
}
module syn_p_cpos_pop;
define syn_p_cpos_pop;
%include 'syn2.ins.pas';

procedure syn_p_cpos_pop (             {pop current character position from stack}
  in      mflag: syn_mflag_k_t);       {syntax matched yes/no flag}

var
  p: stack_frame_cpos_p_t;             {points to stack frame that holding state}

begin
  util_stack_last_frame (pstack, sizeof(p^), p); {get pointer stack frame}
  if mflag <> syn_mflag_yes_k then begin {restore state from stack frame ?}
    next_char := p^.next_char;         {restore current state from stack frame}
    charcase := p^.charcase;
    util_stack_popto (sytree, p^.tree_pos);
    end;
  util_stack_popto (pstack, p);        {deallocate stack frame}
  end;
