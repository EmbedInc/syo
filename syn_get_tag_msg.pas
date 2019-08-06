{   SYN_GET_TAG (TAG, STRING_HANDLE, SUBSYS, MSG_NAME, MSG_PARM, N_PARMS)
*
*   Get the next tag on the syntax tree at the current level.  TAG is the returned
*   tag value as indicated in the .SYN file.
*   STRING_HANDLE is returned as a handle to the
*   string represented by the tag.  It can be used with subroutine
*   SYN_GET_TAG_STRING to get the actual string contents.
*
*   If the end of the syntax tree due to a syntax error is encountered, then
*   the indicated message will be printed, and the program aborted with
*   "output invalid" status.  This may be caught by application programs with
*   a cleanup handler if desired.
*
*   SUBSYS, MSG_NAME, MSG_PARM, and N_PARMS are the standard values for
*   describing a message with parameters.  They are documented more fully
*   in the SYS_ routines that deal with such messages.  Briefly, SUBSYS is the
*   subsystem name.  This is used to make the message file name.  MSG_NAME is
*   the name of the message within the message file.  MSG_PARM is an array of
*   parameters that may be passed to the message.  Use NIL if there are no
*   parameters.  N_PARMS is the number of parameters in MSG_PARM.
}
module syn_get_tag_msg;
define syn_get_tag_msg;
%include 'syn2.ins.pas';

procedure syn_get_tag_msg (            {get tag, print message and bomb on syn error}
  out     tag: sys_int_machine_t;      {TAG value, = SYN_TAG_END_K on normal end}
  out     string_handle: syn_string_t; {handle to string for this tag}
  in      subsys: string;              {subsystem name that message is under}
  in      msg_name: string;            {name of message within subsystem}
  in      msg_parm: univ sys_parm_msg_ar_t; {array of parameter references}
  in      n_parms: sys_int_machine_t); {number of parameters in MSG_PARM array}

begin
  syn_get_tag (tag, string_handle);    {get the next tag from syntax tree}
  if tag <> syn_tag_err_k then return; {no error condition ?}
  syn_error_print (subsys, msg_name, msg_parm, n_parms); {write error message and bomb}
  end;
