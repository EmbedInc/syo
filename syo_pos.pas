{   Module of routines that deal with syntax position handles.
}
module syo_pos;
define syo_push_pos;
define syo_pop_pos;
define syo_pos_get;
define syo_pos_set;
%include 'syo2.ins.pas';
{
*******************************************************************
*
*   Subroutine SYO_PUSH_POS
*
*   Save the current position of traversing the syntax tree.  This state is saved
*   by pushing it on a stack.  The state can be popped off the stack with
*   subroutine SYO_POP_POS.
}
procedure syo_push_pos;                {push current syntax tree position onto stack}

var
  tp_p: syo_tpos_p_t;                  {points to stack frame where state is saved}

begin
  util_stack_push (pstack, sizeof(tp_p^), tp_p); {make stack frame}
  tp_p^.tree_pos := tree_pos.id_p;     {save current state in stack frame}
  tp_p^.tree_pos_handle := tree_pos_handle;
  tp_p^.fake_levels := fake_levels;
  tp_p^.level_header_p := level_header_p;
  end;
{
*******************************************************************
*
*   Subroutine SYO_POP_POS
*
*   Restore the current position of the syntax tree traversal by popping the state
*   from the stack.  It is assumed that the state was pushed there by subroutine
*   SYO_PUSH_POS.
}
procedure syo_pop_pos;                 {pop current syntax tree position from stack}

var
  tp_p: syo_tpos_p_t;                  {points to stack frame where state is saved}

begin
  util_stack_last_frame (pstack, sizeof(tp_p^), tp_p); {get pointer to stack frame}

  tree_pos.id_p := tp_p^.tree_pos;     {restore curr state from stack frame}
  tree_pos_handle := tp_p^.tree_pos_handle;
  fake_levels := tp_p^.fake_levels;
  level_header_p := tp_p^.level_header_p;

  util_stack_popto (pstack, tp_p);     {remove stack frame from stack}
  end;
{
*******************************************************************
*
*   Subroutine SYO_POS_GET (POS)
*
*   Return a handle to the current syntax tree position.
}
procedure syo_pos_get (                {get current syntax tree position}
  out     pos: syo_tpos_t);            {returned syntax tree position handle}

begin
  pos.tree_pos := tree_pos.id_p;       {copy current tree position into handle}
  pos.tree_pos_handle := tree_pos_handle;
  pos.fake_levels := fake_levels;
  pos.level_header_p := level_header_p;
  end;
{
*******************************************************************
*
*   Subroutine SYO_POS_SET (POS)
*
*   Set the new syntax tree position from the given position handle.
}
procedure syo_pos_set (                {jump to new syntax tree position}
  in      pos: syo_tpos_t);            {handle from previous SYO_POS_GET}
  val_param;

begin
  tree_pos.id_p := pos.tree_pos;       {copy current position from handle}
  tree_pos_handle := pos.tree_pos_handle;
  fake_levels := pos.fake_levels;
  level_header_p := pos.level_header_p;
  end;
