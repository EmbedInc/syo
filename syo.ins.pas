{   Public include file for the "old" syntaxer.  This library used to be called
*   SYN, but was renamed to SYO when the new syntaxer was created in 2021.  The
*   new syntaxer is now called SYN.
*
*   This library is not intended for new applications.  The syntax definition
*   files (.SYN) are compatible from the old to the new syntaxer.  See the new
*   SYN library include file for more information on the differences between the
*   old and new syntaxers.
}
const
  syo_subsys_k = -8;                   {subsystem ID for the SYO library}
  syo_stat_syerr_at_k = 1;             {syntax error at specific source char}
  syo_stat_syerr_eol_k = 2;            {syntax error at end of line}
  syo_stat_syerr_eof_k = 3;            {syntax error at end of file}
  syo_stat_syerr_eod_k = 4;            {syntax error at end of data}
{
*   Mnemonics for reserved character values that have special meaning.  The
*   values here must always be negative, and should be as close to zero as
*   possible.
}
  syo_ichar_eol_k = -1;                {end of line}
  syo_ichar_eof_k = -2;                {end of file}
  syo_ichar_eod_k = -3;                {end of all input data}
{
*   Mnemonic constants that specify special cases for the TAG value in call to
*   SYO_GET_TAG.  User tag values must always be greater than zero.
}
  syo_tag_end_k = 0;                   {end of tree at this level, no more tags here}
  syo_tag_err_k = -1;                  {error end of syntax tree}
  syo_tag_none_k = -2;                 {tag not set, used internally}

type
{
*   Mnemonics for the flag value that indicates whether a syntax matched the
*   input stream.
}
  syo_mflag_k_t = (
    syo_mflag_no_k,                    {syntax did not match}
    syo_mflag_yes_k);                  {syntax did match}
{
*   Mnemonics for flag value used to control how input character case is
*   handled.
}
  syo_charcase_k_t = (
    syo_charcase_down_k,               {convert input to lower case for matching}
    syo_charcase_up_k,                 {convert input to upper case for matching}
    syo_charcase_asis_k);              {use input chars directly for matching}
{
*   Data structures that need to be visible to application programs.
}
  syo_file_p_t = ^syo_file_t;
  syo_file_t = record                  {descriptor for an input file}
    uname: string_treename_t;          {original name as received}
    conn_p: file_conn_p_t;             {pointer to file connection handle}
    parent_p: syo_file_p_t;            {points to parent file, NIL if top level}
    nest_level: sys_int_machine_t;     {number of parent files above here}
    eof: boolean;                      {TRUE if read end of file and closed file}
    opened: boolean;                   {TRUE if file opened by this library}
    end;

  syo_line_p_t = ^syo_line_t;
  syo_line_t = record                  {descriptor for one input line}
    file_p: syo_file_p_t;              {points to file descriptor}
    line_n: sys_int_machine_t;         {line number, first is 1}
    n_chars: sys_int_machine_t;        {number of characters in line}
    c: array[1..1] of char;            {0-127 ASCII values for the characters}
    end;

  syo_crange_p_t = ^syo_crange_t;
  syo_crange_t = record                {descriptor for one range of input chars}
    line_p: syo_line_p_t;              {points to descriptor of line chars are from}
    start_pos: sys_int_machine_t;      {starting character number within line}
    n_chars: sys_int_machine_t;        {number of characters in this range}
    seq_n: sys_int_machine_t;          {sequential number of this character range}
    next_p: syo_crange_p_t;            {point to next char range in linked list}
    prev_p: syo_crange_p_t;            {point to previous char range in linked list}
    end;

  syo_char_t = record                  {descriptor for one input character}
    crange_p: syo_crange_p_t;          {pointer to range character lives in}
    ofs: sys_int_machine_t;            {offset within the range}
    end;

  syo_string_t = record                {descriptor for a string of input characters}
    first_char: syo_char_t;            {first character of string}
    last_char: syo_char_t;             {last character of string}
    end;
{
*   Syntax tree position handle.  The application should never access individual
*   fields in this data structure.  The entire data structure should only be
*   used in passing to SYO routines.
}
  syo_tpos_t = record                  {syntax tree position handle}
    tree_pos: univ_ptr;                {pointer to current syntax tree frame}
    tree_pos_handle: util_stack_loc_handle_t; {syntax tree stack position handle}
    fake_levels: sys_int_machine_t;    {number of levels below curr tree frame}
    level_header_p: univ_ptr;          {points to tree frame header for this level}
    end;
  syo_tpos_p_t = ^syo_tpos_t;

syo_preproc_p_t = ^procedure (         {pointer to a pre-processor routine}
  out     line_p: syo_line_p_t;        {points to descriptor for line chars are from}
  out     start_char: sys_int_machine_t; {starting char within line, first = 1}
  out     n_chars: sys_int_machine_t); {number of characters returned by this call}
{
********************************************************************************
*
*   Entry points intended for use by the application program.
}
procedure syo_addstat_char (           {add STAT parms to show line and pnt to char}
  in      char_h: syo_char_t;          {handle to character to show}
  in out  stat: sys_err_t);            {will have two string parms added}
  val_param; extern;

procedure syo_addstat_line (           {add line number and file name to STAT}
  in      char_handle: syo_char_t;     {handle to character to inquire about}
  in out  stat: sys_err_t);            {will have LNUM and FNAM parameters added}
  val_param; extern;

procedure syo_close;                   {close this use of the SYO library}
  extern;

procedure syo_error (                  {error occurred while reading input}
  in      str_h: syo_string_t;         {handle to input string with error}
  in      subsys: string;              {msg file generic name}
  in      msg_name: string;            {message name}
  in      msg_parm: univ sys_parm_msg_ar_t; {parameter references for the message}
  in      n_parms: sys_int_machine_t); {number of parameters passed to message}
  options (extern, noreturn);

procedure syo_error_abort (            {abort and print messages on error status}
  in      stat: sys_err_t;             {error status code}
  in      str_h: syo_string_t;         {handle to input string related to error}
  in      subsys: string;              {msg file generic name}
  in      msg_name: string;            {message name}
  in      msg_parm: univ sys_parm_msg_ar_t; {parameter references for the message}
  in      n_parms: sys_int_machine_t); {number of parameters passed to message}
  extern;

procedure syo_error_print (            {print syntax error message and bomb}
  in      subsys: string;              {subsystem containing error message}
  in      m_name: string;              {name of message within subsystem}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter references for message}
  in      n_parms: sys_int_machine_t); {number of parameters in PARMS}
  options (val_param, extern, noreturn);

procedure syo_error_syntax (           {print syntax error message, no bomb}
  in      subsys: string;              {subsystem containing error message}
  in      m_name: string;              {name of message within subsystem}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter references for message}
  in      n_parms: sys_int_machine_t); {number of parameters in PARMS}
  val_param; extern;

procedure syo_error_tag_unexp (        {got unexpected syntax tag value}
  in      tag: sys_int_machine_t;      {value of syntax tag}
  in      str_h: syo_string_t);        {handle to string for this tag}
  options (extern, noreturn);

procedure syo_get_err_char (           {get error char, only valid after err reparse}
  out     char_handle: syo_char_t);    {first char that didn't match anything}
  extern;

procedure syo_get_char_flevel (        {get file nesting level from char handle}
  in      char_handle: syo_char_t;     {handle to character to inquire about}
  out     level: sys_int_machine_t);   {nesting level, 0 = top file}
  extern;

procedure syo_get_char_line (          {get source line and context for a character}
  in      char_handle: syo_char_t;     {handle to character to inquire about}
  out     ichar: sys_int_machine_t;    {0-127 char, or SYO_ICHAR_xxx_K special flags}
  out     cnum: sys_int_machine_t;     {character index into source line}
  in out  sline: univ string_var_arg_t; {raw source line containing character}
  out     lnum: sys_int_machine_t;     {line number within file, first = 1}
  in out  tnam: univ string_var_arg_t); {treename of file containing source line}
  val_param; extern;

procedure syo_get_line (               {get source line info from char handle}
  in      char_handle: syo_char_t;     {handle to character to inquire about}
  out     lnum: sys_int_machine_t;     {line number within file, first = 1}
  in out  tnam: univ string_var_arg_t); {treename of file containing source line}
  val_param; extern;

procedure syo_get_name (               {get name of current syntax level}
  in out  name: univ string_var_arg_t); {will be empty if at non-existant level}
  extern;

procedure syo_get_tag (                {unconditionally get next tag from syn tree}
  out     tag: sys_int_machine_t;      {tag value, or SYO_TAG_xxx_K}
  out     string_handle: syo_string_t); {handle to string for this tag}
  extern;

procedure syo_get_tag_msg (            {get tag, print message and bomb on syo error}
  out     tag: sys_int_machine_t;      {TAG value, = SYO_TAG_END_K on normal end}
  out     string_handle: syo_string_t; {handle to string for this tag}
  in      subsys: string;              {subsystem name that message is under}
  in      msg_name: string;            {name of message within subsystem}
  in      msg_parm: univ sys_parm_msg_ar_t; {array of parameter references}
  in      n_parms: sys_int_machine_t); {number of parameters in MSG_PARM array}
  extern;

procedure syo_get_tag_msg_none (       {get next tag, bomb on syntax error}
  out     tag: sys_int_machine_t;      {TAG value, = SYO_TAG_END_K on normal end}
  out     string_handle: syo_string_t); {handle to string for this tag}
  extern;

procedure syo_get_tag_stat (           {get next tag, STAT set on syntax error}
  out     tag: sys_int_machine_t;      {app tag value or END or ERR}
  out     string_handle: syo_string_t; {handle to string for this tag}
  out     stat: sys_err_t);            {OK for app or END tag, error for ERR tag}
  val_param; extern;

procedure syo_get_tag_string (         {get string associated with a tag}
  in      string_handle: syo_string_t; {handle from SYO_GET_TAG}
  in out  s: univ string_var_arg_t);   {returned string}
  extern;

procedure syo_inconn_top_set (         {declare top level input stream}
  in out  conn: file_conn_t);          {connection to top input stream, already open}
  val_param; extern;

procedure syo_infile_top_set (         {declare name of top level input file}
  in      name: univ string_var_arg_t; {file name}
  in      ext: string);                {file name extension, padded with blanks}
  extern;

procedure syo_init;                    {init SYO library.  Must be first call}
  extern;

procedure syo_level_down;              {move one level down in syntax tree}
  extern;

function syo_level_down_cond           {move down one syntax level in tree if exists}
  :boolean;                            {TRUE if level did exist}
  extern;

procedure syo_level_up;                {move one level up in syntax tree}
  extern;

function syo_level_up_cond             {pop to parent syntax level if at end of curr}
  :boolean;                            {TRUE if was at end and popped one level}
  extern;

procedure syo_mem_alloc_pool (         {allocate memory from SYO library pool}
  in      size: sys_int_adr_t;         {size of memory needed in machine addresses}
  out     p: univ_ptr);                {returned pointer to new memory}
  extern;

procedure syo_mem_context_alloc (      {create mem context subordinate to SYO memory}
  out     mem_p: util_mem_context_p_t); {returned handle to new memory context}
  extern;

procedure syo_pos_get (                {get current syntax tree position}
  out     pos: syo_tpos_t);            {returned syntax tree position handle}
  extern;

procedure syo_pos_set (                {jump to new syntax tree position}
  in      pos: syo_tpos_t);            {handle from previous SYO_POS_GET}
  val_param; extern;

procedure syo_preproc_set (            {set pre-processor to use, if any}
  in      preproc_p: syo_preproc_p_t); {pnt to pre-proc routine, NIL = no pre-proc}
  extern;

procedure syo_push_pos;                {push current syntax tree position onto stack}
  extern;

procedure syo_push1 (                  {push one machine integer onto stack}
  in      i: sys_int_machine_t);       {value to push onto stack}
  extern;

procedure syo_pop_pos;                 {pop current syntax tree position from stack}
  extern;

procedure syo_pop1 (                   {pop one machine integer from stack}
  out     i: sys_int_machine_t);       {value popped from stack}
  extern;

procedure syo_stack_alloc (            {create stack subordinate to SYO library mem}
  out     stack_h: util_stack_handle_t); {returned handle to new stack}
  extern;

procedure syo_stat_set_syerr (         {set STAT to syntax error, after err reparse}
  out     stat: sys_err_t);            {set appropriately for syntax error}
  val_param; extern;

procedure syo_tree_clear;              {clear syntax tree, setup for parsing}
  extern;

procedure syo_tree_err;                {set up tree for error re-parse}
  extern;

procedure syo_tree_setup;              {set up tree for traversing and getting tags}
  extern;
{
********************************************************************************
*
*   The following entry points are intended for use by pre-processors.  These
*   are routines that may be installed by applications to do some processing on
*   the raw input stream before being passed to the syntaxer.  Pre-processors
*   are installed with the call SYO_PREPROC_SET, declared above.  The default
*   pre-processor just passes the top level input file directly to the syntaxer
*   without alteration.
}
procedure syo_infile_name_lnum (       {set next line number of logical input file}
  in      lnum: sys_int_machine_t);    {line number of next line "read"}
  val_param; extern;

procedure syo_infile_name_pop;         {pop logical input file name}
  val_param; extern;

procedure syo_infile_name_push (       {push logical input file name, read old}
  in      fnam: univ string_var_arg_t); {file name to pretend input coming from}
  val_param; extern;

procedure syo_infile_pop;              {close curr input file, switch to previous}
  extern;

procedure syo_infile_push (            {save old input state, switch to new file}
  in      fnam: univ string_var_arg_t; {name of new input file}
  in      ext: univ string_var_arg_t;  {file name suffix, if any}
  out     stat: sys_err_t);            {completion status code}
  val_param; extern;

procedure syo_infile_push_sext (       {INFILE_PUSH with string fnam extension}
  in      fnam: univ string_var_arg_t; {name of new input file}
  in      ext: string;                 {file name suffix, blank for use FNAM as is}
  out     stat: sys_err_t);            {completion status code}
  val_param; extern;

procedure syo_infile_read (            {read next line from current input file}
  out     line_p: syo_line_p_t;        {will point to descriptor for line from file}
  out     stat: sys_err_t);            {completion status code}
  extern;
{
********************************************************************************
*
*   The following entry points are standard names of the two special case
*   syntaxes.  These only exist if they were explicitly named such in the .SYN
*   file.  They are not required by the SYO library, but are assumed to exist by
*   some general applications.
}
procedure toplev (                     {parse top level syntax}
  out     mflag: syo_mflag_k_t);       {syntax matched yes/no, use SYO_MFLAG_xxx_K}
  extern;

procedure errgo (                      {scan to recover from error}
  out     mflag: syo_mflag_k_t);       {syntax matched yes/no, use SYO_MFLAG_xxx_K}
  extern;
{
********************************************************************************
*
*   Entry points used by the syntax parsing routines when they are checking
*   syntax.  These are not normally used by an application program except when
*   "manually" creating a syntax parsing routine.  All the entry point names in
*   this section start with "syo_p_", to indicate they are called from the
*   parsing routines, and are not intended to be called directly by an
*   application.
}
procedure syo_p_start_routine (        {start new syntax parsing routine}
  in      name_str: string;            {syntax name, must not be volatile variable}
  in      name_len: sys_int_machine_t); {number of characters in NAME_STR}
  extern;

procedure syo_p_end_routine (          {end syntax level, pop back to parent}
  in      mflag: syo_mflag_k_t);       {syntax matched yes/no flag}
  extern;

procedure syo_p_cpos_push;             {save current character position on stack}
  extern;

procedure syo_p_cpos_pop (             {pop current character position from stack}
  in      mflag: syo_mflag_k_t);       {syntax matched yes/no flag}
  extern;

procedure syo_p_tag_start;             {start tagged region at current character}
  extern;

procedure syo_p_tag_end (              {end tagged region started with TAG_START}
  in      mflag: syo_mflag_k_t;        {syntax matched yes/no flag}
  in      tag: sys_int_machine_t);     {ID to tag region with, must be > 0}
  extern;

procedure syo_p_charcase (             {set how to handle input character case}
  in      cc: syo_charcase_k_t);       {use SYO_CHARCASE_xxx_K constants}
  extern;

procedure syo_p_get_ichar (            {get the next input character in an integer}
  out     ichar: sys_int_machine_t);   {0-127 char, or SYO_ICHAR_xxx_K special flags}
  extern;

procedure syo_p_test_eod (             {compare next input char with end of data}
  out     mflag: syo_mflag_k_t);       {syntax matched yes/no, use SYO_MFLAG_xxx_K}
  extern;

procedure syo_p_test_eof (             {compare next input char with end of file}
  out     mflag: syo_mflag_k_t);       {syntax matched yes/no, use SYO_MFLAG_xxx_K}
  extern;

procedure syo_p_test_string (          {compare string with input stream}
  out     mflag: syo_mflag_k_t;        {syntax matched yes/no flag}
  in      str: string;                 {the string to compare}
  in      len: sys_int_machine_t);     {number of characters in STR}
  extern;
