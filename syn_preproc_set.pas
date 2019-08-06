{   Subroutine SYN_PREPROC_SET (PREPROC_P)
*
*   Explicitly set an application-specific pre-processor.  PREPROC_P is the pointer
*   to the pre-processor routine entry point.  A value of NIL causes the
*   default SYN library pre-processor to be installed, which is also the default
*   after SYN_INIT.
*
*   A pre-processor may be used to modify the raw data from the input file before
*   the syntaxer reads it.  The default pre-processor just passes on the raw input
*   file without modification.
}
module syn_PREPROC_SET;
define syn_preproc_set;
%include 'syn2.ins.pas';

procedure syn_preproc_set (            {set pre-processor to use, if any}
  in      preproc_p: syn_preproc_p_t); {pnt to pre-proc routine, NIL = no pre-proc}

begin
  if preproc_p = nil
    then begin                         {user wants default pre-processor}
      syn_preproc_p := addr(syn_preproc_default);
      end
    else begin                         {user wants his own pre-processor}
      syn_preproc_p := preproc_p;
      end
    ;
  end;
