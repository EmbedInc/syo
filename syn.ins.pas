{   Application-visible include file for the syntaxer.  This is the only include
*   file needed for application programs that are using the syntaxer to parse
*   a formal language.
}
const
  syn_subsys_k = -8;                   {subsystem ID for the SYN library}
  syn_stat_syerr_at_k = 1;             {syntax error at specific source char}
  syn_stat_syerr_eol_k = 2;            {syntax error at end of line}
  syn_stat_syerr_eof_k = 3;            {syntax error at end of file}
  syn_stat_syerr_eod_k = 4;            {syntax error at end of data}
{
*   Mnemonics for reserved character values that have special meaning.  The values
*   here must always be negative, and should be as close to zero as possible.
}
  syn_ichar_eol_k = -1;                {end of line}
  syn_ichar_eof_k = -2;                {end of file}
  syn_ichar_eod_k = -3;                {end of all input data}
{
*   Mnemonic constants that specify special cases for the TAG value in call to
*   SYN_GET_TAG.  User tag values must always be greater than zero.
}
  syn_tag_end_k = 0;                   {end of tree at this level, no more tags here}
  syn_tag_err_k = -1;                  {error end of syntax tree}
  syn_tag_none_k = -2;                 {tag not set, used internally}

type
{
*   Mnemonics for the flag value that indicates whether a syntax matched the input
*   stream.
}
  syn_mflag_k_t = (
    syn_mflag_no_k,                    {syntax did not match}
    syn_mflag_yes_k);                  {syntax did match}
{
*   Mnemonics for flag value used to control how input character case is handled.
}
  syn_charcase_k_t = (
    syn_charcase_down_k,               {convert input to lower case for matching}
    syn_charcase_up_k,                 {convert input to upper case for matching}
    syn_charcase_asis_k);              {use input chars directly for matching}
{
*   Data structures that need to be visible to application programs.
}
  syn_file_p_t =                       {pointer to a file descriptor}
    ^syn_file_t;

  syn_line_p_t =                       {pointer to an input line descriptor}
    ^syn_line_t;

  syn_crange_p_t =                     {pointer to range of characters descriptor}
    ^syn_crange_t;

  syn_file_t = record                  {descriptor for an input file}
    uname: string_treename_t;          {original name as received}
    conn_p: file_conn_p_t;             {pointer to file connection handle}
    parent_p: syn_file_p_t;            {points to parent file, NIL if top level}
    nest_level: sys_int_machine_t;     {number of parent files above here}
    eof: boolean;                      {TRUE if read end of file and closed file}
    opened: boolean;                   {TRUE if file opened by this library}
    end;

  syn_line_t = record                  {descriptor for one input line}
    file_p: syn_file_p_t;              {points to file descriptor}
    line_n: sys_int_machine_t;         {line number, first is 1}
    n_chars: sys_int_machine_t;        {number of characters in line}
    c: array[1..1] of char;            {0-127 ASCII values for the characters}
    end;

  syn_crange_t = record                {descriptor for one range of input chars}
    line_p: syn_line_p_t;              {points to descriptor of line chars are from}
    start_pos: sys_int_machine_t;      {starting character number within line}
    n_chars: sys_int_machine_t;        {number of characters in this range}
    seq_n: sys_int_machine_t;          {sequential number of this character range}
    next_p: syn_crange_p_t;            {point to next char range in linked list}
    prev_p: syn_crange_p_t;            {point to previous char range in linked list}
    end;

  syn_char_t = record                  {descriptor for one input character}
    crange_p: syn_crange_p_t;          {pointer to range character lives in}
    ofs: sys_int_machine_t;            {offset within the range}
    end;

  syn_string_t = record                {descriptor for a string of input characters}
    first_char: syn_char_t;            {first character of string}
    last_char: syn_char_t;             {last character of string}
    end;
{
*   Syntax tree position handle.  The application should never access individual
*   fields in this data structure.  The entire data structure should only
*   be used in passing to SYN routines.
}
  syn_tpos_t = record                  {syntax tree position handle}
    tree_pos: univ_ptr;                {pointer to current syntax tree frame}
    tree_pos_handle: util_stack_loc_handle_t; {syntax tree stack position handle}
    fake_levels: sys_int_machine_t;    {number of levels below curr tree frame}
    level_header_p: univ_ptr;          {points to tree frame header for this level}
    end;
  syn_tpos_p_t = ^syn_tpos_t;

syn_preproc_p_t = ^procedure (         {pointer to a pre-processor routine}
  out     line_p: syn_line_p_t;        {points to descriptor for line chars are from}
  out     start_char: sys_int_machine_t; {starting char within line, first = 1}
  out     n_chars: sys_int_machine_t); {number of characters returned by this call}
{
**********************************************************************************
*
*   Entry points intended for use by the application program.
}
procedure syn_addstat_char (           {add STAT parms to show line and pnt to char}
  in      char_h: syn_char_t;          {handle to character to show}
  in out  stat: sys_err_t);            {will have two string parms added}
  val_param; extern;

procedure syn_addstat_line (           {add line number and file name to STAT}
  in      char_handle: syn_char_t;     {handle to character to inquire about}
  in out  stat: sys_err_t);            {will have LNUM and FNAM parameters added}
  val_param; extern;

procedure syn_close;                   {close this use of the SYN library}
  extern;

procedure syn_error (                  {error occurred while reading input}
  in      str_h: syn_string_t;         {handle to input string with error}
  in      subsys: string;              {msg file generic name}
  in      msg_name: string;            {message name}
  in      msg_parm: univ sys_parm_msg_ar_t; {parameter references for the message}
  in      n_parms: sys_int_machine_t); {number of parameters passed to message}
  options (extern, noreturn);

procedure syn_error_abort (            {abort and print messages on error status}
  in      stat: sys_err_t;             {error status code}
  in      str_h: syn_string_t;         {handle to input string related to error}
  in      subsys: string;              {msg file generic name}
  in      msg_name: string;            {message name}
  in      msg_parm: univ sys_parm_msg_ar_t; {parameter references for the message}
  in      n_parms: sys_int_machine_t); {number of parameters passed to message}
  extern;

procedure syn_error_print (            {print syntax error message and bomb}
  in      subsys: string;              {subsystem containing error message}
  in      m_name: string;              {name of message within subsystem}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter references for message}
  in      n_parms: sys_int_machine_t); {number of parameters in PARMS}
  options (val_param, extern, noreturn);

procedure syn_error_syntax (           {print syntax error message, no bomb}
  in      subsys: string;              {subsystem containing error message}
  in      m_name: string;              {name of message within subsystem}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter references for message}
  in      n_parms: sys_int_machine_t); {number of parameters in PARMS}
  val_param; extern;

procedure syn_error_tag_unexp (        {got unexpected syntax tag value}
  in      tag: sys_int_machine_t;      {value of syntax tag}
  in      str_h: syn_string_t);        {handle to string for this tag}
  options (extern, noreturn);

procedure syn_get_err_char (           {get error char, only valid after err reparse}
  out     char_handle: syn_char_t);    {first char that didn't match anything}
  extern;

procedure syn_get_char_flevel (        {get file nesting level from char handle}
  in      char_handle: syn_char_t;     {handle to character to inquire about}
  out     level: sys_int_machine_t);   {nesting level, 0 = top file}
  extern;

procedure syn_get_char_line (          {get source line and context for a character}
  in      char_handle: syn_char_t;     {handle to character to inquire about}
  out     ichar: sys_int_machine_t;    {0-127 char, or SYN_ICHAR_xxx_K special flags}
  out     cnum: sys_int_machine_t;     {character index into source line}
  in out  sline: univ string_var_arg_t; {raw source line containing character}
  out     lnum: sys_int_machine_t;     {line number within file, first = 1}
  in out  tnam: univ string_var_arg_t); {treename of file containing source line}
  val_param; extern;

procedure syn_get_line (               {get source line info from char handle}
  in      char_handle: syn_char_t;     {handle to character to inquire about}
  out     lnum: sys_int_machine_t;     {line number within file, first = 1}
  in out  tnam: univ string_var_arg_t); {treename of file containing source line}
  val_param; extern;

procedure syn_get_name (               {get name of current syntax level}
  in out  name: univ string_var_arg_t); {will be empty if at non-existant level}
  extern;

procedure syn_get_tag (                {unconditionally get next tag from syn tree}
  out     tag: sys_int_machine_t;      {tag value, or SYN_TAG_xxx_K}
  out     string_handle: syn_string_t); {handle to string for this tag}
  extern;

procedure syn_get_tag_msg (            {get tag, print message and bomb on syn error}
  out     tag: sys_int_machine_t;      {TAG value, = SYN_TAG_END_K on normal end}
  out     string_handle: syn_string_t; {handle to string for this tag}
  in      subsys: string;              {subsystem name that message is under}
  in      msg_name: string;            {name of message within subsystem}
  in      msg_parm: univ sys_parm_msg_ar_t; {array of parameter references}
  in      n_parms: sys_int_machine_t); {number of parameters in MSG_PARM array}
  extern;

procedure syn_get_tag_msg_none (       {get next tag, bomb on syntax error}
  out     tag: sys_int_machine_t;      {TAG value, = SYN_TAG_END_K on normal end}
  out     string_handle: syn_string_t); {handle to string for this tag}
  extern;

procedure syn_get_tag_stat (           {get next tag, STAT set on syntax error}
  out     tag: sys_int_machine_t;      {app tag value or END or ERR}
  out     string_handle: syn_string_t; {handle to string for this tag}
  out     stat: sys_err_t);            {OK for app or END tag, error for ERR tag}
  val_param; extern;

procedure syn_get_tag_string (         {get string associated with a tag}
  in      string_handle: syn_string_t; {handle from SYN_GET_TAG}
  in out  s: univ string_var_arg_t);   {returned string}
  extern;

procedure syn_inconn_top_set (         {declare top level input stream}
  in out  conn: file_conn_t);          {connection to top input stream, already open}
  val_param; extern;

procedure syn_infile_top_set (         {declare name of top level input file}
  in      name: univ string_var_arg_t; {file name}
  in      ext: string);                {file name extension, padded with blanks}
  extern;

procedure syn_init;                    {init SYN library.  Must be first call}
  extern;

procedure syn_level_down;              {move one level down in syntax tree}
  extern;

function syn_level_down_cond           {move down one syntax level in tree if exists}
  :boolean;                            {TRUE if level did exist}
  extern;

procedure syn_level_up;                {move one level up in syntax tree}
  extern;

function syn_level_up_cond             {pop to parent syntax level if at end of curr}
  :boolean;                            {TRUE if was at end and popped one level}
  extern;

procedure syn_mem_alloc_pool (         {allocate memory from SYN library pool}
  in      size: sys_int_adr_t;         {size of memory needed in machine addresses}
  out     p: univ_ptr);                {returned pointer to new memory}
  extern;

procedure syn_mem_context_alloc (      {create mem context subordinate to SYN memory}
  out     mem_p: util_mem_context_p_t); {returned handle to new memory context}
  extern;

procedure syn_pos_get (                {get current syntax tree position}
  out     pos: syn_tpos_t);            {returned syntax tree position handle}
  extern;

procedure syn_pos_set (                {jump to new syntax tree position}
  in      pos: syn_tpos_t);            {handle from previous SYN_POS_GET}
  val_param; extern;

procedure syn_preproc_set (            {set pre-processor to use, if any}
  in      preproc_p: syn_preproc_p_t); {pnt to pre-proc routine, NIL = no pre-proc}
  extern;

procedure syn_push_pos;                {push current syntax tree position onto stack}
  extern;

procedure syn_push1 (                  {push one machine integer onto stack}
  in      i: sys_int_machine_t);       {value to push onto stack}
  extern;

procedure syn_pop_pos;                 {pop current syntax tree position from stack}
  extern;

procedure syn_pop1 (                   {pop one machine integer from stack}
  out     i: sys_int_machine_t);       {value popped from stack}
  extern;

procedure syn_stack_alloc (            {create stack subordinate to SYN library mem}
  out     stack_h: util_stack_handle_t); {returned handle to new stack}
  extern;

procedure syn_stat_set_syerr (         {set STAT to syntax error, after err reparse}
  out     stat: sys_err_t);            {set appropriately for syntax error}
  val_param; extern;

procedure syn_tree_clear;              {clear syntax tree, setup for parsing}
  extern;

procedure syn_tree_err;                {set up tree for error re-parse}
  extern;

procedure syn_tree_setup;              {set up tree for traversing and getting tags}
  extern;
{
**********************************************************************************
*
*   The following entry points are intended for use by pre-processors.
*   These are routines that may be installed by applications to do some
*   processing on the raw input stream before being passed to the syntaxer.
*   Pre-processors are installed with the call SYN_PREPROC_SET, declared above.
*   The default pre-processor just passes the top level input file
*   directly to the syntaxer without alteration.
}
procedure syn_infile_name_lnum (       {set next line number of logical input file}
  in      lnum: sys_int_machine_t);    {line number of next line "read"}
  val_param; extern;

procedure syn_infile_name_pop;         {pop logical input file name}
  val_param; extern;

procedure syn_infile_name_push (       {push logical input file name, read old}
  in      fnam: univ string_var_arg_t); {file name to pretend input coming from}
  val_param; extern;

procedure syn_infile_pop;              {close curr input file, switch to previous}
  extern;

procedure syn_infile_push (            {save old input state, switch to new file}
  in      fnam: univ string_var_arg_t; {name of new input file}
  in      ext: univ string_var_arg_t;  {file name suffix, if any}
  out     stat: sys_err_t);            {completion status code}
  extern;

procedure syn_infile_read (            {read next line from current input file}
  out     line_p: syn_line_p_t;        {will point to descriptor for line from file}
  out     stat: sys_err_t);            {completion status code}
  extern;
{
**********************************************************************************
*
*   The following entry points are standard names of the two special case syntaxes.
*   These only exist if they were explicitly named such in the .SYN file.  They
*   are not required by the SYN library, but are assumed to exist by some general
*   applications.
}
procedure toplev (                     {parse top level syntax}
  out     mflag: syn_mflag_k_t);       {syntax matched yes/no, use SYN_MFLAG_xxx_K}
  extern;

procedure errgo (                      {scan to recover from error}
  out     mflag: syn_mflag_k_t);       {syntax matched yes/no, use SYN_MFLAG_xxx_K}
  extern;
{
**********************************************************************************
*
*   Entry points used by the syntax parsing routines when they are checking syntax.
*   These are not normally used by an application program except when "manually"
*   creating a syntax parsing routine.  All the entry point names in this
*   section start with "syn_p_", to indicate they are called from the parsing
*   routines, and are not intended to be called directly by an application.
}
procedure syn_p_start_routine (        {start new syntax parsing routine}
  in      name_str: string;            {syntax name, must not be volitile variable}
  in      name_len: sys_int_machine_t); {number of characters in NAME_STR}
  extern;

procedure syn_p_end_routine (          {end syntax level, pop back to parent}
  in      mflag: syn_mflag_k_t);       {syntax matched yes/no flag}
  extern;

procedure syn_p_cpos_push;             {save current character position on stack}
  extern;

procedure syn_p_cpos_pop (             {pop current character position from stack}
  in      mflag: syn_mflag_k_t);       {syntax matched yes/no flag}
  extern;

procedure syn_p_tag_start;             {start tagged region at current character}
  extern;

procedure syn_p_tag_end (              {end tagged region started with TAG_START}
  in      mflag: syn_mflag_k_t;        {syntax matched yes/no flag}
  in      tag: sys_int_machine_t);     {ID to tag region with, must be > 0}
  extern;

procedure syn_p_charcase (             {set how to handle input character case}
  in      cc: syn_charcase_k_t);       {use SYN_CHARCASE_xxx_K constants}
  extern;

procedure syn_p_get_ichar (            {get the next input character in an integer}
  out     ichar: sys_int_machine_t);   {0-127 char, or SYN_ICHAR_xxx_K special flags}
  extern;

procedure syn_p_test_eod (             {compare next input char with end of data}
  out     mflag: syn_mflag_k_t);       {syntax matched yes/no, use SYN_MFLAG_xxx_K}
  extern;

procedure syn_p_test_eof (             {compare next input char with end of file}
  out     mflag: syn_mflag_k_t);       {syntax matched yes/no, use SYN_MFLAG_xxx_K}
  extern;

procedure syn_p_test_string (          {compare string with input stream}
  out     mflag: syn_mflag_k_t;        {syntax matched yes/no flag}
  in      str: string;                 {the string to compare}
  in      len: sys_int_machine_t);     {number of characters in STR}
  extern;
