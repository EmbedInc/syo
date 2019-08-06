{   SYN_P_END_ROUTINE (MFLAG)
*
*   Declare end of syntax routine.  This closes a syntax level opened with
*   SYN_P_START_ROUTINE.  If no tags were written to the tree at or below this
*   syntax level, or the syntax did not match, then the syntax level is removed
*   from the tree.  Otherwise a "one level up" frame is written to the syntax tree.
}
module syn_p_end_routine;
define syn_p_end_routine;
%include 'syn2.ins.pas';

procedure syn_p_end_routine (          {end syntax level, pop back to parent}
  in      mflag: syn_mflag_k_t);       {syntax matched yes/no flag}

var
  up_p: tree_frame_up_p_t;             {points to "one level up" syntax tree frame}
  sf_p: stack_frame_down_p_t;          {points to stack frame for "one leve down"}
  down_p: tree_frame_down_p_t;         {points to "one level down" syntax tree frame}

label
  done_tree;

begin
  util_stack_last_frame (pstack, sizeof(sf_p^), sf_p); {get pointer to our stack frame}
  down_p := tframe_p;                  {save pointer to "one level down" tree frame}
  tframe_p := tframe_p^.parent_p;      {make parent level the current level}

  if mflag <> syn_mflag_yes_k then begin {restore state to start of this level ?}
    next_char := sf_p^.next_char;
    charcase := sf_p^.charcase;
    end;

  if error then begin                  {terminating an error re-parse ?}
    goto done_tree;
    end;

  if (mflag = syn_mflag_yes_k) and made_tag {check for need to keep this level}
    then begin                         {this level stays, close it out properly}
      util_stack_push (sytree, sizeof(up_p^), up_p); {make "one level up" tree frame}
      up_p^.tframe := tframe_up_k;     {ID for this syntax tree frame type}
      up_p^.head_p := tframe_p;        {point to header for new syntax level}
      down_p^.fwd_p := up_p;           {pointer to "up" frame in "down" frame}
      end
    else begin                         {remove this level}
      util_stack_popto (sytree, down_p); {back up syntax tree to before "down" frame}
      made_tag := sf_p^.made_tag;      {restore whether tags made at this level}
      end
    ;

done_tree:                             {jump here when done with syntax tree}
  util_stack_popto (pstack, sf_p);     {remove "one level down" frame from stack}
  end;
