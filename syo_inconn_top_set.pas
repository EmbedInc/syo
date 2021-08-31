{   Subroutine SYO_INCONN_TOP_SET (CONN)
*
*   Set the top level input stream to that connected via CONN.
}
module syo_inconn_top_set;
define syo_inconn_top_set;
%include 'syo2.ins.pas';

var
  ins: string_var16_t :=
    [str := '.ins.', len := 5, max := sizeof(ins.str)];

procedure syo_inconn_top_set (         {declare top level input stream}
  in out  conn: file_conn_t);          {connection to top input stream, already open}
  val_param;

var
  f_p: syo_file_p_t;                   {pointer to new file descriptor}
  i: string_index_t;

begin
  util_mem_grab (                      {allocate memory for new file descriptor}
    sizeof(f_p^),                      {amount of memory to grab}
    mem_context_p^,                    {context to allocate memory under}
    true,                              {may need to individually deallocate this}
    f_p);                              {pointer to new memory area}

  string_copy (conn.tnam, top_fnam);   {set top input file name}
  top_fnam_ext.len := 0;               {indicate no file name extension}

  f_p^.uname.max := sizeof(f_p^.uname.str); {init new var string}
  string_copy (conn.fnam, f_p^.uname); {set user name of this file}
  f_p^.conn_p := addr(conn);           {set pointer to stream connection}
  f_p^.parent_p := file_p;
  f_p^.eof := false;
  f_p^.opened := false;                {indicate file not opened by this library}
  if file_p = nil
    then begin                         {this is the top level input file}
      f_p^.nest_level := 0;
      end
    else begin                         {this is a nested input file}
      string_find (ins, conn.fnam, i); {look for identification of include file}
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

  next_char.crange_p := nil;           {indicate first input range not yet fetched}
  end;
