{   Collection of routines that manipulate logical input files.  Input
*   lines are always read from real input files, but are reported to have
*   come from the logical input files.
}
module syn_infile_name;
define syn_infile_name_lnum;
define syn_infile_name_pop;
define syn_infile_name_push;
%include 'syn2.ins.pas';

var
  ins: string_var16_t :=
    [str := '.ins.', len := 5, max := sizeof(ins.str)];
{
*********************************************************************
*
*   Subroutine SYN_INFILE_NAME_PUSH (FNAM)
*
*   Switch the logical input file state to the new indicated file.
*   The old logical input file state will be saved, and the new one made
*   subordinate to the current position.
}
procedure syn_infile_name_push (       {push logical input file name, read old}
  in      fnam: univ string_var_arg_t); {file name to pretend input coming from}
  val_param;

var
  f_p: syn_file_p_t;                   {pointer to new file descriptor}
  i: string_index_t;

begin
  util_mem_grab (                      {alloc mem for new file descriptor}
    sizeof(f_p^), mem_context_p^, false, f_p);

  f_p^ := file_p^;                     {init all fields in new file descriptor}
  util_mem_grab (                      {alloc mem for new file connection}
    sizeof(f_p^.conn_p^), mem_context_p^, false, f_p^.conn_p);
  f_p^.conn_p^ := file_p^.conn_p^;     {init all the fields in CONN}
  string_copy (fnam, f_p^.uname);      {save name as supplied by user}
  string_copy (fnam, f_p^.conn_p^.fnam);
  string_copy (fnam, f_p^.conn_p^.gnam);
  string_copy (fnam, f_p^.conn_p^.tnam);
  f_p^.conn_p^.ext_num := 0;
  f_p^.conn_p^.data_p := nil;
  f_p^.conn_p^.close_p := nil;
  f_p^.conn_p^.lnum := 0;              {line number of last line read}

  f_p^.parent_p := file_name_p;        {link to parent file}
  if f_p^.parent_p = nil
    then begin                         {this is the top level input file}
      f_p^.nest_level := 0;
      end
    else begin                         {this is a nested input file}
      string_find (ins, fnam, i);      {look for identification of include file}
      if i <> 0
        then begin                     {new file is an include file}
          f_p^.nest_level := file_p^.nest_level + 1;
          end
        else begin                     {new file is not an include file}
          f_p^.nest_level := file_p^.nest_level;
          end
        ;
      end
    ;
  f_p^.eof := false;
  f_p^.opened := false;                {"file" was not opened by this library}
  file_name_p := f_p;                  {install new logical file as current}
  end;
{
*********************************************************************
*
*   Subroutine SYN_INFILE_NAME_POP
*
*   Pop the logical input file state.  The state will be returned to
*   that before the last SYN_INFILE_NAME_PUSH.  The old input file
*   current line number will not be altered.  Applications may need
*   to call SYN_INFILE_NAME_LNUM to correct the input file line number
*   when reading a flattened file where directives may have been added.
}
procedure syn_infile_name_pop;         {pop logical input file name}
  val_param;

const
  max_msg_parms = 2;                   {max parameters we can pass to a message}

var
  msg_parm:                            {parameter references for messages}
    array[1..max_msg_parms] of sys_parm_msg_t;

begin
  if file_name_p = nil then begin      {no logical file to pop ?}
    sys_msg_parm_int (msg_parm[1], file_p^.conn_p^.lnum);
    sys_msg_parm_vstr (msg_parm[2], file_p^.conn_p^.tnam);
    sys_message_bomb ('syn', 'infile_name_pop_none', msg_parm, 2);
    end;
  file_name_p := file_name_p^.parent_p; {pop back to logical parent file}
  end;
{
*********************************************************************
*
*   Subroutine SYN_INFILE_NAME_LNUM (LNUM)
*
*   Explicitly set the line number to report for the next input line
*   to be read.
}
procedure syn_infile_name_lnum (       {set next line number of logical input file}
  in      lnum: sys_int_machine_t);    {line number of next line "read"}
  val_param;

var
  f_p: syn_file_p_t;                   {pointer to new file descriptor}

begin
  if file_name_p = nil then begin      {not currently in a logical file ?}
    util_mem_grab (                    {alloc mem for new file descriptor}
      sizeof(f_p^), mem_context_p^, false, f_p);
    f_p^ := file_p^;                   {init from physical input file}
    f_p^.parent_p := nil;              {don't allow messing up physical input files}
    file_name_p := f_p;                {now using logical input file}
    end;

  file_name_p^.conn_p^.lnum := lnum - 1; {set the line number}
  end;
