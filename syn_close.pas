{   SYN_CLOSE
*
*   Close the current use of the SYN routines.  All memory dynamically allocated
*   by the SYN routines will be released.  The next SYN_ call, if any, must be
*   SYN_INIT>
}
module syn_close;
define syn_close;
%include 'syn2.ins.pas';

procedure syn_close;                   {close this use of the SYN library}

begin
  util_mem_context_del (mem_context_p); {deallocate all dynamic memory}
  end;
