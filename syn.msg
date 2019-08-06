/*   Messages related to status codes.
/*
msg err1                               /* SYS_STAT_SYERR_AT_K
  lan english -def
    Error encountered on line %p1i of file "%p2s".  The first
    character that did not match the syntax template is shown:
    .nfill
    %p3s                               /* source line
    %p4s                               /* up arrow pointing to offending character
msg err2                               /* SYS_STAT_SYERR_EOL_K
  lan english -def
    Error occurred on line %p1i of file "%p2s".  The end of line
    was the first character that did not match the syntax template:
    .nfill
    %p3s
msg err3                               /* SYS_STAT_SYERR_EOF_K
  lan english -def
    Error occurred at the end of file "%p1s".  The end of file
    was the first character that did not match the syntax template.
msg err4                               /* SYS_STAT_SYERR_EOD_K
  lan english -def
    The end of the top level input file was the first character
    that did not match the syntax template.
/*
/*   Messages referenced by name, not thru status codes.
/*
msg charcase_bad
  lan english -def
    Bad value for flag that seclects character case.  Value was %p1i.
msg error_char
  lan english -def
    Error occurred on line %p1i in file "%p2s":
msg error_eol
  lan english -def
    Error occurred at END-OF-LINE of line %p1i in file "%p2s":
msg error_eof
  lan english -def
    Error occurred at the END-OF-FILE of file "%p2s".
msg error_eod
  lan english -def
    Error occurred when the END-OF-FILE of the top level input file
    was encountered.
msg infile_name_pop_none
  lan english -def
    Attempt to pop logical input file although no logical input file
    was currently active.  Just read line %p1i of file %p2s.
msg infile_open
  lan english -def
    Error on attempt to open top level input file and read the first
    line.  File name was "%p1s", with suffix "%p2s".
msg preproc_directive_parm_err
  lan english -def
    Error with parameter "%p3s" to pre-processor directive "%p4s".
    Error occurred on line %p1i of file "%p2s".
msg preproc_directive_unknown
  lan english -def
    Unknown pre-process directive "%p3s".
    Error occurred on line %p1i of file "%p2s".
msg syntax_error
  lan english -def
    .nfill
    SYNTAX ERROR:
msg syntax_error_char
  lan english -def
    Error encountered on line %p1i of file "%p2s".  The first
    character that did not match the syntax template is shown:
msg syntax_error_eol
  lan english -def
    Error occurred on line %p1i of file "%p2s".  The end of line
    was the first character that did not match the syntax template:
msg syntax_error_eof
  lan english -def
    Error occurred at the end of file "%p2s".  The end of file
    was the first character that did not match the syntax template.
msg syntax_error_eod
  lan english -def
    The end of the top level input file was the first character
    that did not match the syntax template.
msg tag_unexpected
  lan english -def
    Unexpected syntax tag value of %p1i.  This should not occurr, and is
    probably due to syntax definition file and source code being out of
    sync.  Get traceback to find location of error.
