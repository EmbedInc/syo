This is the "old" syntaxer that used to be called SYN.  It was renamed to
SYO in preparation for creating the new syntaxer, which will be called
SYN.  The new syntaxer will use the same syntax definition files, but
will:

  *  Use the FLINE library to manage source lines instead of doing this
     with private functions in the SYN library.  The FLINE library did not
     exist when the old SYN library was created.

  *  Not have internal static state.
