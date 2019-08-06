{   SYN_P_TAG_END (MFLAG,TAG)
*
*   Close a tagged region started with SYN_P_TAG_START.  MFLAG is the syntax matched
*   flag for the tagged region.  If MFLAG indicates that the syntax matched, then
*   the tag will be completed and current state left as is.  If MFLAG indicates no
*   match, then state will be restored to what it was when SYN_P_TAG_START was
*   called.  TAG is the tag ID number.  This will be returned to the application
*   program when traversing the syntax tree.  It must be greater than zero.
}
module syn_p_tag_end;
define syn_p_tag_end;
%include 'syn2.ins.pas';

procedure syn_p_tag_end (              {end tagged region started with TAG_START}
  in      mflag: syn_mflag_k_t;        {syntax matched yes/no flag}
  in      tag: sys_int_machine_t);     {ID to tag region with, must be > 0}

var
  sf_p: stack_frame_tag_p_t;           {points to stack frame to remember tag pos}

begin
  util_stack_last_frame (pstack, sizeof(sf_p^), sf_p); {get pointer to stack frame}
  if mflag = syn_mflag_yes_k
    then begin                         {syntax matched, finish tag}
      if tag <= 0 then begin
        writeln ('TAG value out of range in SYN_P_TAG_END.');
        sys_bomb;
        end;
      with sf_p^.tag_p^: tg do begin   {TG is syntax tree frame for this tag}
        tg.tag := tag;                 {set user ID for this tag}
        tg.fchar := sf_p^.next_char;   {handle to first char of tagged region}
        tg.lchar := next_char;         {handle to next char after last tagged}
        end;                           {done with TG abbreviation}
      made_tag := true;                {we made a tag at this syntax level}
      end
    else begin                         {syntax didn't match, pop back to old state}
      util_stack_popto (sytree, sf_p^.tag_p); {restore syntax tree to before tag}
      next_char := sf_p^.next_char;    {restore state from stack frame}
      charcase := sf_p^.charcase;
      end
    ;                                  {done handling syntax matched yes/no}
  util_stack_popto (pstack, sf_p);     {pop tag marker frame from stack}
  end;
