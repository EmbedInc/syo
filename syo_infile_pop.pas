{   Subroutine SYO_INFILE_POP
*
*   Close the current input file and restore to the input state right before this
*   file was opened.  This subroutine is a matched pair with SYO_INFILE_PUSH.
}
module syo_INFILE_POP;
define syo_infile_pop;
%include 'syo2.ins.pas';

procedure syo_infile_pop;              {close curr input file, switch to previous}

begin
  if file_p = nil then return;         {no current input file to close ?}

  if file_p^.opened and (not file_p^.eof) then begin {we opened but not yet closed ?}
    file_close (file_p^.conn_p^);      {close current input file}
    file_p^.eof := true;               {indicate this file is now closed}
    end;

  file_p := file_p^.parent_p;          {pop back to previous input state}
  file_name_p := nil;                  {indicate logical source is also real source}
  end;
