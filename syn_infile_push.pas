module syn_infile_push;
define syn_infile_push;
define syn_infile_push_sext;
%include 'syn2.ins.pas';

var
  ins: string_var16_t :=
    [str := '.ins.', len := 5, max := sizeof(ins.str)];
{
********************************************************************************
*
*   Subroutine SYN_INFILE_PUSH (FNAM, EXT, STAT)
*
*   Save the current input environment and then switch input to the start of the
*   indicated file.  FNAM is the file name, and EXT is an optional file name
*   suffix.  The input environment can be restored to its state right before
*   this call with routine SYN_INFILE_POP.
}
procedure syn_infile_push (            {save old input state, switch to new file}
  in      fnam: univ string_var_arg_t; {name of new input file}
  in      ext: univ string_var_arg_t;  {file name suffix, if any}
  out     stat: sys_err_t);            {completion status code}
  val_param;

var
  f_p: syn_file_p_t;                   {pointer to new file descriptor}
  conn_p: file_conn_p_t;               {pointer to file connection}
  ext_str: string_var80_t;             {file name suffix padded to STRING size}
  i: string_index_t;

begin
  ext_str.max := sizeof(ext_str.str);  {init local var string}

  util_mem_grab (                      {allocate memory for new file connection}
    sizeof(conn_p^),                   {amount of memory to grab}
    mem_context_p^,                    {context to allocate memory under}
    true,                              {may need to individually deallocate this}
    conn_p);                           {pointer to new memory area}

  string_copy (ext, ext_str);          {make local copy of file name suffix}
  string_fill (ext_str);               {fill unused space with blanks}
  file_open_read_text (fnam, ext_str.str, conn_p^, stat); {open new input file}
  if sys_error(stat) then begin        {error on opening file ?}
    util_mem_ungrab (conn_p, mem_context_p^); {release mem for file connection}
    return;                            {return with error}
    end;

  util_mem_grab (                      {allocate memory for new file descriptor}
    sizeof(f_p^),                      {amount of memory to grab}
    mem_context_p^,                    {context to allocate memory under}
    true,                              {may need to individually deallocate this}
    f_p);                              {pointer to new memory area}
  f_p^.uname.max := sizeof(f_p^.uname.str); {init new var string}

  string_copy (fnam, f_p^.uname);      {fill in fields in new file descriptor}
  f_p^.conn_p := conn_p;
  f_p^.parent_p := file_p;
  f_p^.eof := false;
  f_p^.opened := true;
  if file_p = nil
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
  file_p := f_p;                       {make new file descriptor current}
  file_name_p := nil;                  {indicate logical source is also real source}
  end;
{
********************************************************************************
*
*   Subroutine SYN_INFILE_PUSH_SEXT (FNAM, EXT, STAT)
*
*   Like SYN_INFILE_PUSH, except that EXT is a Pascal string instead of a var
*   string.
}
procedure syn_infile_push_sext (       {INFILE_PUSH with string fnam extension}
  in      fnam: univ string_var_arg_t; {name of new input file}
  in      ext: string;                 {file name suffix, blank for use FNAM as is}
  out     stat: sys_err_t);            {completion status code}
  val_param;

var
  vext: string_var80_t;

begin
  vext.max := size_char(vext.str);     {init local var string}

  string_vstring (vext, ext, size_char(ext)); {make var string EXT}
  syn_infile_push (fnam, vext, stat);  {do the work}
  end;
