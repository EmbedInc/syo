{   Subroutine SYO_INFILE_TOP_SET (NAME, EXT)
*
*   Declare the top level input file name.  NAME is the generic file name, and
*   EXT is the optional file name extension (suffix).
}
module syo_INFILE_TOP_SET;
define syo_infile_top_set;
%include 'syo2.ins.pas';

procedure syo_infile_top_set (         {declare name of top level input file}
  in      name: univ string_var_arg_t; {file name}
  in      ext: string);                {file name extension, padded with blanks}

const
  max_msg_parms = 2;                   {max parameters we can pass to a message}
  max_try_k = 5;                       {max number of times to try to open file}
  retry_wait_k = 0.25;                 {seconds wait between retry attempts}

var
  msg_parm:                            {parameter references for messages}
    array[1..max_msg_parms] of sys_parm_msg_t;
  stat: sys_err_t;                     {completion status code}
  n_try: sys_int_machine_t;            {number of attempts to open input file}

label
  retry_file;

begin
  string_copy (name, top_fnam);        {save file name in common block}

  string_vstring (top_fnam_ext, ext, sizeof(ext)); {save file name extension}
  string_unpad (top_fnam_ext);         {delete trailing blanks from extension name}
  string_fill (top_fnam_ext);          {fill unused string space with blanks}

  file_p := nil;                       {init to no current input file}
  file_name_p := nil;

  n_try := 0;                          {init number of attempts to open input file}
retry_file:                            {back here to retry opening input file}
  syo_infile_push (top_fnam, top_fnam_ext, stat); {open first input file}
  if sys_error(stat) then begin        {error on attempt to open file ?}
    n_try := n_try + 1;                {make number of this attempt}
    if n_try < max_try_k then begin    {OK to try again ?}
      sys_wait (retry_wait_k);         {wait a short time}
      goto retry_file;                 {try again}
      end;
    sys_msg_parm_vstr (msg_parm[1], top_fnam);
    sys_msg_parm_vstr (msg_parm[2], top_fnam_ext);
    sys_error_abort (stat, 'syn', 'infile_open', msg_parm, 2);
    end;

  syo_range_next (next_char.crange_p); {init next character to first in file}
  next_char.ofs := 0;

  start_char := next_char;             {save handle to first input character}
  far_char := next_char;               {init handle to farthest char used so far}
  end;
