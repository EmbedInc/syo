{   Subroutine SYO_STACK_ALLOC (STACK_H)
*
*   Create a stack that will be subordinate to the SYO library memory context.
*   The stack will be deallocated automatically when SYO_CLOSE is called.
}
module syo_STACK_ALLOC;
define syo_stack_alloc;
%include 'syo2.ins.pas';

procedure syo_stack_alloc (            {create stack subordinate to SYO library mem}
  out     stack_h: util_stack_handle_t); {returned handle to new stack}

begin
  util_stack_alloc (mem_context_p^, stack_h);
  end;
