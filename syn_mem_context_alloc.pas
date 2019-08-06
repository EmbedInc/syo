{   Subroutine SYN_MEM_CONTEXT_ALLOC (MEM_P)
*
*   Create a new memory context that is subordinate to the SYN library
*   memory context.  This memory context will be deallocated when SYN_CLOSE
*   is called.
}
module syn_MEM_CONTEXT_ALLOC;
define syn_mem_context_alloc;
%include 'syn2.ins.pas';

procedure syn_mem_context_alloc (      {create mem context subordinate to SYN memory}
  out     mem_p: util_mem_context_p_t); {returned handle to new memory context}

begin
  util_mem_context_get (mem_context_p^, mem_p);
  end;
