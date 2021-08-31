{   SYO_TREE_SETUP
*
*   Set up the syntax tree for traversing by the application program.  This means
*   that the application is done building the syntax tree by calling parsing
*   routines.  The state will be left so that the next call to SYO_LEVEL_DOWN
*   will enter the syntax level of the first top level contruction.
}
module syo_tree_setup;
define syo_tree_setup;
%include 'syo2.ins.pas';

procedure syo_tree_setup;              {set up tree for traversing and getting tags}

var
  end_p: tree_frame_end_p_t;           {points to "end of syntax tree" frame}

begin
  util_stack_dalloc (pstack);          {reset parsing stack to empty}
  util_stack_alloc (mem_context_p^, pstack);

  util_stack_push (sytree, sizeof(end_p^), end_p); {create "end of syntax tree" frame}
  end_p^.tframe := tframe_end_k;       {set ID for this syntax tree frame type}
  end_p^.error := err_reparse;         {set error/normal end of tree flag}

  util_stack_loc_start (               {init position to start of tree}
    sytree,                            {handle to identify stack}
    tree_pos_handle,                   {stack position handle}
    tree_pos.id_p);                    {pointer to current tree frame of traversal}

  fake_levels := 0;                    {we are at same level as tree frame indicates}
  err_reparse := false;                {done with error re-parse, if was at all}
  end;
