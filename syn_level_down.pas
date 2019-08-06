{   SYN_LEVEL_DOWN
*
*   Move one nesting level down in the syntax tree.  It is permissible to step
*   down into a level that does not exist.  In that case, we keep track of how
*   many "fake" levels down the user is below that of the current syntax tree
*   frame.
}
module syn_level_down;
define syn_level_down;
%include 'syn2.ins.pas';

procedure syn_level_down;              {move one level down in syntax tree}

begin
  if tree_pos.id_p^ = tframe_down_k
    then begin                         {there is a level here to move to}
      syn_next_tree_pos;               {advance to next frame at new level}
      end
    else begin                         {lower level doesn't exist}
      fake_levels := fake_levels + 1;  {log one more level below current frame}
      end
    ;
  end;
