{   SYN_GET_TAG_MSG_NONE (TAG,STRING_HANDLE)
*
*   Get the next tag on the syntax tree at the current level.  TAG is the returned
*   tag value as indicated in the .SYN file.  TAG is set to SYN_TAG_END_K if there
*   are no more tags at this level.  STRING_HANDLE is returned as a handle to the
*   string represented by the tag.  It can be used with subroutine
*   SYN_GET_TAG_STRING to get the actual string contents.
*
*   If the end of the syntax tree due to a syntax error is encountered, then
*   a message will be printed and the program aborted.  This can be caught by
*   a cleanup handler in the application, if desired.
}
module syn_get_tag_msg_none;
define syn_get_tag_msg_none;
%include 'syn2.ins.pas';

procedure syn_get_tag_msg_none (       {get next tag, bomb on syntax error}
  out     tag: sys_int_machine_t;      {TAG value, = SYN_TAG_END_K on normal end}
  out     string_handle: syn_string_t); {handle to string for this tag}

begin
  syn_get_tag_msg (tag, string_handle, '', '', nil, 0);
  end;
