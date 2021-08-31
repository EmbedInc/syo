{   SYO_POP1 (I)
*
*   Pop one machine integer from the internal stack.  This integer should have
*   been pushed there by subroutine SYO_PUSH1.
}
module syo_pop1;
define syo_pop1;
%include 'syo2.ins.pas';

procedure syo_pop1 (                   {pop one machine integer from stack}
  out     i: sys_int_machine_t);       {value popped from stack}

var
  p: sys_int_machine_p_t;              {pointer to integer on stack}

begin
  util_stack_last_frame (pstack, sizeof(p^), p); {get pointer to stack frame}
  i := p^;                             {return integer value to caller}
  util_stack_popto (pstack, p);        {remove stack frame from stack}
  end;
