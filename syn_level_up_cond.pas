{   Function SYN_LEVEL_UP_COND
*
*   Pop up one syntax level if the position is at the end of the current syntax
*   level.  In that case, return TRUE.  Otherwise, the current position will no
*   be altered, and the function value will be FALSE.
}
module syn_level_up_cond;
define syn_level_up_cond;
%include 'syn2.ins.pas';

function syn_level_up_cond             {pop to parent syntax level if at end of curr}
  :boolean;                            {TRUE if was at end and popped one level}

begin
  if fake_levels > 0 then begin        {in non-existant syntax level ?}
    fake_levels := fake_levels - 1;    {one level less deep below current tree frame}
    syn_level_up_cond := true;         {indicate pop did occurr}
    return;
    end;

  if tree_pos.id_p^ = tframe_up_k
    then begin                         {we are at end of current syntax level}
      syn_next_tree_pos;               {step out of this level to parent level}
      syn_level_up_cond := true;       {indicate pop did occurr}
      end
    else begin                         {we are not at end of current syntax level}
      syn_level_up_cond := false;      {indicate pop did not occurr}
      end
    ;
  end;
