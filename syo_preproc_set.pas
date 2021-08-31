{   Subroutine SYO_PREPROC_SET (PREPROC_P)
*
*   Explicitly set an application-specific pre-processor.  PREPROC_P is the pointer
*   to the pre-processor routine entry point.  A value of NIL causes the
*   default SYO library pre-processor to be installed, which is also the default
*   after SYO_INIT.
*
*   A pre-processor may be used to modify the raw data from the input file before
*   the syntaxer reads it.  The default pre-processor just passes on the raw input
*   file without modification.
}
module syo_PREPROC_SET;
define syo_preproc_set;
%include 'syo2.ins.pas';

procedure syo_preproc_set (            {set pre-processor to use, if any}
  in      preproc_p: syo_preproc_p_t); {pnt to pre-proc routine, NIL = no pre-proc}

begin
  if preproc_p = nil
    then begin                         {user wants default pre-processor}
      syo_preproc_p := addr(syo_preproc_default);
      end
    else begin                         {user wants his own pre-processor}
      syo_preproc_p := preproc_p;
      end
    ;
  end;
