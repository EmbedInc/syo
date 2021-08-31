{   Subroutine SYO_MEM_ALLOC_POOL (SIZE,P)
*
*   Allocate memory from the SYO library pool.  It will not be possible to
*   individually deallocate this memory.  The memory will be deallocated when
*   SYO_CLOSE is called.  The start of the new memory will be aligned to the
*   natural alignment of a machine integer.
}
module syo_MEM_ALLOC_POOL;
define syo_mem_alloc_pool;
%include 'syo2.ins.pas';

procedure syo_mem_alloc_pool (         {allocate memory from SYO library pool}
  in      size: sys_int_adr_t;         {size of memory needed in machine addresses}
  out     p: univ_ptr);                {returned pointer to new memory}

begin
  util_mem_grab (                      {allocate memory}
    size,                              {memory size in machine addresses}
    mem_context_p^,                    {parent memory context}
    false,                             {can not individually deallocate this memory}
    p);                                {pointer to new memory region}
  end;
