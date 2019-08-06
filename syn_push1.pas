{   SYN_PUSH1 (I)
*
*   Push one machine integer value onto stack.  This can be popped later with
*   subroutine SYN_POP1
}
module syn_push1;
define syn_push1;
%include 'syn2.ins.pas';

procedure syn_push1 (                  {push one machine integer onto stack}
  in      i: sys_int_machine_t);       {value to push onto stack}

var
  p: sys_int_machine_p_t;              {pointer to integer on stack}

begin
  util_stack_push (pstack, sizeof(p^), p); {make stack frame and get pointer to it}
  p^ := i;                             {save caller's value on stack}
  end;
