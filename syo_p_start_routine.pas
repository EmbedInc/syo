{   SYO_P_START_ROUTINE (NAME_STR,NAME_LEN)
*
*   Declare entry to a new syntax checking routine.  NAME_STR is the name of the
*   syntax construction, and NAME_LEN is the number of characters in NAME_STR.
*   NAME_STR must not be a volitile variable, as only its address will be saved.
*
*   The current state is saved on the stack and a "one level down" frame is
*   written to the synax tree.  SYO_P_END_ROUTINE must be called at the end
*   of the syntax checking routine.  This subrroutine pops the internal stack
*   and fixes things up according to whether the syntax matched.
}
module syo_p_start_routine;
define syo_p_start_routine;
%include 'syo2.ins.pas';

procedure syo_p_start_routine (        {start new syntax parsing routine}
  in      name_str: string;            {syntax name, must not be volitile variable}
  in      name_len: sys_int_machine_t); {number of characters in NAME_STR}

var
  down_p: tree_frame_down_p_t;         {points to "down one level" syntax tree frame}
  sf_p: stack_frame_down_p_t;          {points to stack frame for syo tree frame}

begin
  util_stack_push (sytree, sizeof(down_p^), down_p); {make syntax tree frame}
  down_p^.tframe := tframe_down_k;     {ID for this syntax tree frame type}
  down_p^.fwd_p := nil;                {init forward pointer to invalid}
  down_p^.parent_p := tframe_p;        {pointer to parent syntax level frame}
  down_p^.name_p := addr(name_str);    {save pointer to name of this level}
  down_p^.name_len := name_len;        {save number of characters in name}

  util_stack_push (pstack, sizeof(sf_p^), sf_p); {make stack frame for saving state}
  sf_p^.next_char := next_char;        {save some current state in stack frame}
  sf_p^.charcase := charcase;
  sf_p^.made_tag := made_tag;

  tframe_p := down_p;                  {update pointer to current syo level header}
  made_tag := false;                   {init to no tag so far for this new level}
  end;
