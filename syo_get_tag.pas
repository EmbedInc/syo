{   SYO_GET_TAG (TAG,STRING_HANDLE)
*
*   Get the next tag on the syntax tree at the current level.  TAG is the returned
*   tag value as indicated in the .SYO file.  TAG is set to SYO_TAG_END_K if there
*   are no more tags at this level.  STRING_HANDLE is returned as a handle to the
*   string represented by the tag.  It can be used with subroutine
*   SYO_GET_TAG_STRING to get the actual string contents.
*
*   TAG is always returned, even on end of syntax tree due to syntax error.
*   In this case TAG will be set to SYO_TAG_ERR_K.
}
module syo_get_tag;
define syo_get_tag;
%include 'syo2.ins.pas';

procedure syo_get_tag (                {unconditionally get next tag from syo tree}
  out     tag: sys_int_machine_t;      {TAG value, = SYO_TAG_END_K on normal end}
  out     string_handle: syo_string_t); {handle to string for this tag}

var
  lev: sys_int_machine_t;              {number of levels below starting level}

label
  frame_loop;

begin
  if fake_levels > 0 then begin        {we are in a fake level ?}
    if
        (tree_pos.id_p^ = tframe_end_k) and then
        tree_pos.end_p^.error
      then begin                       {we are at error end of syntax tree}
        tag := syo_tag_err_k;
        end
      else begin                       {not at error end of syntax tree}
        tag := syo_tag_end_k;          {fake levels are always empty}
        end
      ;
    return;
    end;

  lev := 0;                            {init to level of current tree frame}

frame_loop:                            {back here each new syntax tree frame}
  case tree_pos.id_p^ of               {what kind of tree frame are we at}

tframe_tag_k: begin                    {start of a tag}
      if lev <= 0 then begin           {are we at starting syntax nesting level ?}
        tag := tree_pos.tag_p^.tag;    {pass back tag value}
        string_handle.first_char := tree_pos.tag_p^.fchar; {pass back string handle}
        string_handle.last_char := tree_pos.tag_p^.lchar;
        syo_next_tree_pos;             {advance to next syntax tree frame}
        return;
        end;
      end;

tframe_down_k: begin                   {start of new subordinate level}
      lev := lev + 1;                  {one more level below starting level}
      end;

tframe_up_k: begin                     {end of current syntax level}
      if lev <= 0
        then begin                     {we are at starting syntax nesting level}
          tag := syo_tag_end_k;        {we hit end of level without finding a tag}
          return;
          end
        else begin                     {we are below starting syntax level}
          lev := lev - 1;              {one level less below starting level}
          end
        ;
      end;

tframe_end_k: begin                    {we hit end of syntax tree}
      if tree_pos.end_p^.error
        then begin                     {error end of syntax tree}
          tag := syo_tag_err_k;        {indicate error end of syntax tree}
          end
        else begin                     {normal end of syntax tree}
          tag := syo_tag_end_k;
          end
        ;
      return;
      end;
    end;                               {end of syntax tree frame type cases}

  syo_next_tree_pos;                   {advance position to next frame}
  goto frame_loop;                     {back and process new frame}
  end;
