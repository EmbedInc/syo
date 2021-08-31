{   Subroutine SYO_MEM_CONTEXT_ALLOC (MEM_P)
*
*   Create a new memory context that is subordinate to the SYO library
*   memory context.  This memory context will be deallocated when SYO_CLOSE
*   is called.
}
module syo_MEM_CONTEXT_ALLOC;
define syo_mem_context_alloc;
%include 'syo2.ins.pas';

procedure syo_mem_context_alloc (      {create mem context subordinate to SYO memory}
  out     mem_p: util_mem_context_p_t); {returned handle to new memory context}

begin
  util_mem_context_get (mem_context_p^, mem_p);
  end;
