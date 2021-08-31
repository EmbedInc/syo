{   Function SYO_LEVEL_DOWN_COND
*
*   Move one nesting level down in the syntax tree if that level exists.
*   The function value is TRUE if it existed, and FALSE if it didn't.
}
module syo_level_down_cond;
define syo_level_down_cond;
%include 'syo2.ins.pas';

function syo_level_down_cond           {move down one syntax leve in tree if exists}
  :boolean;                            {TRUE if level did exist}

begin
  if tree_pos.id_p^ = tframe_down_k
    then begin                         {there is a level here to move to}
      syo_next_tree_pos;               {advance to next frame at new level}
      syo_level_down_cond := true;     {indicate level existed}
      end
    else begin                         {lower level doesn't exist}
      syo_level_down_cond := false;    {indicate level doesn't exist}
      end
    ;
  end;

