{   Subroutine SYN_STACK_ALLOC (STACK_H)
*
*   Create a stack that will be subordinate to the SYN library memory context.
*   The stack will be deallocated automatically when SYN_CLOSE is called.
}
module syn_STACK_ALLOC;
define syn_stack_alloc;
%include 'syn2.ins.pas';

procedure syn_stack_alloc (            {create stack subordinate to SYN library mem}
  out     stack_h: util_stack_handle_t); {returned handle to new stack}

begin
  util_stack_alloc (mem_context_p^, stack_h);
  end;
