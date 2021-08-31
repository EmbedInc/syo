{   SYO_CLOSE
*
*   Close the current use of the SYO routines.  All memory dynamically allocated
*   by the SYO routines will be released.  The next SYO_ call, if any, must be
*   SYO_INIT>
}
module syo_close;
define syo_close;
%include 'syo2.ins.pas';

procedure syo_close;                   {close this use of the SYO library}

begin
  util_mem_context_del (mem_context_p); {deallocate all dynamic memory}
  end;
