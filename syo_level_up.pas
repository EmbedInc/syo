{   SYO_LEVEL_UP
*
*   Move up to parent level in syntax tree.
}
module syo_level_up;
define syo_level_up;
%include 'syo2.ins.pas';

procedure syo_level_up;                {move one level up in syntax tree}

var
  lev: sys_int_machine_t;              {number of levels below start}

label
  frame_loop;

begin
  if fake_levels > 0

    then begin                         {we are currently in a fake level}
      fake_levels := fake_levels - 1;  {one level less deep below current tree frame}
      end

    else begin                         {we are currently at a real level}
      lev := 0;                        {init counter to indicate current level}
frame_loop:                            {back here each new syntax tree frame}
      case tree_pos.id_p^ of           {what kind of frame are we at ?}
tframe_up_k: begin                     {end of level frame}
          if lev <= 0
            then begin                 {we are at starting level}
              syo_next_tree_pos;       {step out of this level to parent level}
              return;
              end
            else begin                 {we are below starting level}
              lev := lev - 1;          {will now be one level up}
              end
            ;
          end;
tframe_down_k: begin                   {start of level frame}
          lev := lev + 1;              {we will be one level down}
          end;
tframe_end_k: begin                    {we hit end of syntax tree}
          return;
          end;
        end;                           {end of syntax tree frame type cases}
      syo_next_tree_pos;               {advance to next frame on syntax tree}
      goto frame_loop;                 {back and process this new frame}
      end
    ;
  end;
