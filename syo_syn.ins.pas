{   Include file used by SST in the process of translating a SYN file to
*   executable source code.
}
%include '(cog)lib/sys.ins.pas';
%include '(cog)lib/util.ins.pas';
%include '(cog)lib/string.ins.pas';
%include '(cog)lib/file.ins.pas';
%include '(cog)lib/syo.ins.pas';

var (syo_parse_common)
  error: boolean;                      {TRUE if hit farthest char on error re-parse}
