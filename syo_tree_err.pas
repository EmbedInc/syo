{   SYO_TREE_ERR
*
*   Set up the state for an error re-parse.  This may be done if the top level syntax
*   parsing routine returned SYO_MFLAG_NO_K, meaning the syntax did not match.
*   In that case, the syntax tree would be empty.  By doing a error re-parse,
*   the syntax tree is re-built, and left in the state it was in when the farthest
*   character was requested.  The application can then traverse this tree
*   and get more information about the syntax error.
}
module syo_tree_err;
define syo_tree_err;
%include 'syo2.ins.pas';

procedure syo_tree_err;                {set up tree for error re-parse}

begin
  syo_tree_setup;                      {close out parsing operation}

  util_stack_dalloc (sytree);          {reset syntax tree to empty}
  util_stack_alloc (mem_context_p^, sytree);

  util_stack_dalloc (pstack);          {reset parsing stack to empty}
  util_stack_alloc (mem_context_p^, pstack);

  err_reparse := true;                 {indicate we will be doing error re-parse}
  syo_reset;                           {reset state for new parsing operation}
  end;
