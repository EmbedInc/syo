{   Private include file used by all the routines that implement the syntaxer.
}
%natural_alignment;
%include 'sys.ins.pas';
%include 'util.ins.pas';
%include 'string.ins.pas';
%include 'file.ins.pas';
%include 'syn.ins.pas';

type
{
*   Mnemonics for each of the different types of items that may be written to
*   the syntax tree.
}
  tframe_k_t = (                       {IDs for the syntax tree items}
    tframe_tag_k,                      {tag for syntax construction}
    tframe_down_k,                     {down one level}
    tframe_up_k,                       {up one level}
    tframe_end_k);                     {end of syntax tree}
  tframe_k_p_t = ^tframe_k_t;
{
*   The following data structures are templates for what each type of frame on
*   the syntax tree looks like.
}
  tree_frame_tag_p_t = ^tree_frame_tag_t; {pointers to specific frame types}
  tree_frame_down_p_t = ^tree_frame_down_t;
  tree_frame_up_p_t = ^tree_frame_up_t;
  tree_frame_end_p_t = ^tree_frame_end_t;

  tree_frame_pnt_t = record            {choice of pointers to each tree frame type}
    case integer of
      0: (id_p: tframe_k_p_t);         {pointer to just the frame ID}
      1: (tag_p: tree_frame_tag_p_t);  {pointers to whole frames}
      2: (down_p: tree_frame_down_p_t);
      3: (up_p: tree_frame_up_p_t);
      4: (end_p: tree_frame_end_p_t);
    end;

  tree_frame_tag_t = record            {declare tagged syntax region}
    tframe: tframe_k_t;                {ID for this frame type}
    tag: sys_int_machine_t;            {tag value}
    fchar: syn_char_t;                 {handle to first character of string}
    lchar: syn_char_t;                 {handle to last character of string}
    end;

  tree_frame_down_t = record           {entering subordinate syntax level}
    tframe: tframe_k_t;                {ID for this frame type}
    fwd_p: tree_frame_up_p_t;          {pointer to frame ending this syntax level}
    parent_p: tree_frame_down_p_t;     {pointer to header for parent level}
    name_p: ^string;                   {pointer to name of this syntax level}
    name_len: sys_int_machine_t;       {number of characters in name}
    end;

  tree_frame_up_t = record             {end of curr syntax level, pop one level}
    tframe: tframe_k_t;                {ID for this frame type}
    head_p: tree_frame_down_p_t;       {pointer to header for new current level}
    end;

  tree_frame_end_t = record            {end of whole syntax tree}
    tframe: tframe_k_t;                {ID for this frame type}
    error: boolean;                    {TRUE on abnormal end}
    end;
{
*   End of templates for syntax tree frames.
}
  stack_frame_cpos_t = record          {stack frame for saving input stream state}
    next_char: syn_char_t;             {handle to next input stream character}
    charcase: syn_charcase_k_t;        {current character case conversion flag}
    tree_pos: univ_ptr;                {current tree end position}
    end;
  stack_frame_cpos_p_t = ^stack_frame_cpos_t;

  stack_frame_tag_t = record           {stack frame to remember start of tag}
    tag_p: tree_frame_tag_p_t;         {pointer to syntax tree TAG frame}
    next_char: syn_char_t;             {handle to next input stream character}
    charcase: syn_charcase_k_t;        {current character case conversion flag}
    end;
  stack_frame_tag_p_t = ^stack_frame_tag_t;

  stack_frame_down_t = record          {stack frame to remember start of routine}
    next_char: syn_char_t;             {handle to next input stream character}
    charcase: syn_charcase_k_t;        {current character case conversion flag}
    made_tag: boolean;                 {TRUE if made tag at or below current level}
    end;
  stack_frame_down_p_t = ^stack_frame_down_t;
{
*   Common block accessed by SYN_ routines.
}
var (syn_common)
  mem_context_p: util_mem_context_p_t; {top context for all our dynamic memory}
  sytree: util_stack_handle_t;         {handle to syntax tree stack}
  pstack: util_stack_handle_t;         {handle to stack used at parse time}
{
*   Variables used when parsing.
}
  top_fnam: string_treename_t;         {name of top input file supplied by user}
  top_fnam_ext: string_var80_t;        {extension of top input file name}
  syn_preproc_p: syn_preproc_p_t;      {points to pre-processor routine}
  next_crange_seq_n: sys_int_machine_t; {sequence number for next crange descriptor}
  file_p: syn_file_p_t;                {pointer to data about current input file}
  file_name_p: syn_file_p_t;           {pnt to data about "pretend" input file}
  tframe_p: tree_frame_down_p_t;       {pointer to curr syntax level header frame}
  start_char: syn_char_t;              {char position before first parse routine}
  next_char: syn_char_t;               {handle to next input stream character}
  far_char: syn_char_t;                {handle to farthest character requested}
  charcase: syn_charcase_k_t;          {current character case conversion flag}
  made_tag: boolean;                   {TRUE if made tag at or below current level}
  err_reparse: boolean;                {TRUE if reparsing with error condition}
{
*   Variables used when traversing syntax tree.
}
  tree_pos: tree_frame_pnt_t;          {points to next syntax tree frame}
  tree_pos_handle: util_stack_loc_handle_t; {handle to syntax tree stack position}
  fake_levels: sys_int_machine_t;      {number of levels below current tree frame}
  level_header_p: tree_frame_down_p_t; {pointer to header for current syntax level}
{
*   Common block accessed by all the parsing routines.
}
var (syn_parse_common)
  error: boolean;                      {TRUE if hit farthest char on error re-parse}
  unused1: char;
  unused2: char;
  unused3: char;
{
*   Entry points used internally by the syntaxer.
}
procedure syn_next_tree_pos;           {advance traversal to next syntax tree frame}
  extern;

procedure syn_preproc_default (        {default pre-processor installed by SYN lib}
  out     line_p: syn_line_p_t;        {points to descriptor for line chars are from}
  out     start_char: sys_int_machine_t; {starting char within line, first = 1}
  out     n_chars: sys_int_machine_t); {number of characters returned by this call}
  extern;

procedure syn_range_next (             {create and return pointer to next char range}
  out     p: syn_crange_p_t);          {pointer to new char range, NIL = end of input}
  extern;

procedure syn_reset;                   {set up for parsing from INIT state}
  extern;
