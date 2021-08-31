{   SYO_P_TAG_START
*
*   Mark the current position of the syntax tree, and save the current input stream
*   state on the stack.  The tagged region is "open" until SYO_P_TAG_END is called.
*   This either closes the tag if the syntax matched, or pops back to the original
*   state if the syntax did not match.
}
module syo_p_tag_start;
define syo_p_tag_start;
%include 'syo2.ins.pas';

procedure syo_p_tag_start;             {start tagged region at current character}

var
  tag_p: tree_frame_tag_p_t;           {points to syntax tree frame for this tag}
  sf_p: stack_frame_tag_p_t;           {points to stack frame to remember tag pos}

begin
  util_stack_push (sytree, sizeof(tag_p^), tag_p); {make tag frame on syntax tree}
  tag_p^.tframe := tframe_tag_k;       {ID for this syntax tree frame type}
  tag_p^.tag := syo_tag_none_k;        {init tag value to NONE}

  util_stack_push (pstack, sizeof(sf_p^), sf_p); {make stack frame for this tag}
  sf_p^.tag_p := tag_p;                {save pointer to syntax tree tag frame}
  sf_p^.next_char := next_char;        {save current state in stack frame}
  sf_p^.charcase := charcase;
  end;
