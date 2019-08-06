{   SYN_NEXT_TREE_POS
*
*   Advance the current traversal position of the syntax tree to the next frame.
}
module syn_next_tree_pos;
define syn_next_tree_pos;
%include 'syn2.ins.pas';

procedure syn_next_tree_pos;           {advance traversal to next syntax tree frame}

var
  sz: sys_int_adr_t;                   {size of current syntax tree frame}

begin
  case tree_pos.id_p^ of               {different for each syntax tree frame type}

tframe_tag_k: begin                    {tag frame}
      sz := sizeof(tree_frame_tag_t);
      end;

tframe_down_k: begin                   {start of new level frame}
      level_header_p := tree_pos.down_p; {save pointer to new current level header}
      sz := sizeof(tree_frame_down_t);
      end;

tframe_up_k: begin                     {end of current level frame}
      level_header_p := level_header_p^.parent_p; {update pointer to current header}
      sz := sizeof(tree_frame_up_t);
      end;

tframe_end_k: begin                    {end of syntax tree frame}
      return;
      end;

otherwise
    writeln ('Illegal syntax tree frame ID.');
    sys_bomb;
    end;                               {SZ is all set}

  util_stack_loc_fwd (tree_pos_handle, sz, tree_pos.id_p); {move to next frame}
  end;
