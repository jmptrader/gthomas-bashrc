1.1 Overview
=============
   This library provides Emacs support for a limited subset of
   Perl-compatible regular expression (PCRE) syntax by translating
   PCRE expresions into Emacs' native regexp syntax. It can also
   convert Emacs syntax to PCRE, convert both forms to S-expression
   based `rx' or SRE syntax, and do various other useful things.

   PCRE has a complicated syntax and semantics, only some of which can
   be translated into Elisp. The PCRE subset which should be correctly
   parsed and converted is the following:

  - parenthesis grouping `( .. )', including shy matches `(?: ... )'
  - backreferences (various syntaxes), but only up to 9 per expression
  - alternation `|'
  - greedy and non-greedy quantifiers `*', `*?', `+', `+?', `?' and `??'
    (all of which are the same in Elisp as in PCRE)
  - numerical quantifiers `{M,N}'
  - beginning/end of string `\A', `\Z'
  - string quoting `\Q .. \E'
  - word boundaries `\b', `\B' (these are the same in Elisp)
  - single character escapes `\a', `\c', `\e', `\f', `\n', `\r', `\t',
    `\x', and `\octal digits' (but see BUGS, below, about non-ASCII
    characters)
  - character classes `[...]' including Posix escapes
  - character classes `\d', `\D', `\h', `\H', `\s', `\S', `\v', `\V'
    both within character class brackets and outside
  - word and non-word characters `\w' and `\W'
    (Emacs has the same syntax, but its meaning is different)
  - `s' (single line) and `x' (extended syntax) flags, in regexp
    literals, or set within the expression via `(?xs-xs)' or `(?xs-xs:
    .... )' syntax
  - comments `(?# ... )'


1.2 Usage
==========
   Example of using the conversion functions:
   (rxt-pcre-to-elisp "(abc|def)\\w+\\d+")
      ;; => "\\(\\(?:abc\\|def\\)\\)[_[:alnum:]]+[[:digit:]]+"

   You can also use `pcre-to-elisp' as an alias for `rxt-pcre-to-elisp'.

   Besides `rxt-pcre-to-elisp', there are seven other conversion
   functions. They all take a single string argument, the regexp to
   translate:

   - `rxt-elisp-to-pcre', `rxt-pcre-to-elisp'
   - `rxt-elisp-to-rx', `rxt-pcre-to-rx'
   - `rxt-elisp-to-sre', `rxt-pcre-to-sre'
   - `rxt-elisp-to-strings', `rxt-pcre-to-strings'

   The two `-to-strings' functions are basically the inverse of
   `regexp-opt', producing a complete list of matching strings from a
   regexp. For obvious reasons, this only works with regexps that
   don't match an infinite set. Trying it with an expression that
   includes a `*', `+', or similar quantifier will throw an error.

   (regexp-opt '("cat" "caterpillar" "catatonic"))
      ;; => "\\(?:cat\\(?:atonic\\|erpillar\\)?\\)"
   (rxt-elisp-to-strings "\\(?:cat\\(?:atonic\\|erpillar\\)?\\)")
       ;; => '("cat" "caterpillar" "catatonic")

1.2.1 Interactive usage
------------------------
    The translation functions can all be used interactively. You can
    choose your own key bindings for them. ;^) In interactive use they
    read the input regexp either from the current buffer or from the
    minibuffer as follows:

    - If called with a prefix argument, both PCRE- and Elisp-expecting
      commands read a regexp from the minibuffer literally
      (i.e. without needing to double the backslashes). Without a
      prefix argument but when the region is active, they use the
      region contents, also literally.
    - With neither a prefix arg nor an active region, the commands
      that take an Emacs regexp as input behave like `C-x C-e': they
      use the result of evaluating the sexp before point (which could
      be a string literal).
    - PCRE translators called without prefix arg or active region
      attempt to read a Perl-style delimited regexp literal
      *following* point in the current buffer, including its
      flags. For example, putting point before the `m' in the
      following example and doing `M-x pcre-to-elisp' displays
      `\(?:bar\|foo\)'

      $x =~ m/  foo   |  (?# comment) bar /x

      The PCRE reader currently only works with `/ ... /' delimiters. It
      will ignore any preceding `m', `s', or `qr' operator, as well as
      the replacement part of an `s' construction.

    The translation functions display a result in the minibuffer and
    copy it to the kill ring. In the case of `rxt-pcre-to-elisp', you
    might need to use the result either literally, for input to an
    interactive command, or as a string to paste into Lisp code;
    therefore, this command copies both versions to the kill ring. You
    can get the literal regexp by doing `C-y' and the Lisp string by `C-y
    M-y'.

1.2.2 Query replace
--------------------
    You may want to perform the following key bindings if you prefer
    PCRE generally over the Emacs counterparts:

    (global-set-key [(meta %)] 'pcre-query-replace-regexp)

1.2.3 RE-Builder support
-------------------------
    The Emacs RE-Builder comes with support for multiple syntaxes via
    `reb-change-syntax' (`C-c TAB'). It supports Elisp read and
    literal syntax, `rx' and `sregex' (another S-expression syntax),
    but only converts from the symbolic forms to Elisp, not the other
    way.  This package hacks the RE-Builder to also work with emulated
    PCRE syntax, and to convert transparently between Elisp, PCRE and
    rx syntaxes. PCRE mode reads a delimited literal `/ ... /', and
    should support using the `x' and `s' flags.

1.2.4 Explain regexps
----------------------
    Two commands, `rxt-explain-elisp' and `rxt-explain-pcre', can help
    untangle long regexps found in the wild. They read a regexp
    in the same way as the other interactive functions, convert it to
    `rx' S-expressions, and put the pretty-printed result in a new
    buffer. This is a work in progress.

1.3 Internal details
=====================
   Internally, `pcre2el' defines a set of abstract data types for
   regular expressions, parsers from Elisp and PCRE syntax to the ADT,
   and unparsers from the ADT to PCRE, rx, and SRE syntax. Conversion
   from the ADT to Elisp syntax is a two-step process: first convert
   to `rx' form, then let `rx-to-string' do the heavy lifting. See
   `rxt-parse-re', `rxt-adt->pcre', `rxt-adt->rx', and `rxt-adt->sre',
   and the section beginning "Regexp ADT" in pcre2el.el for details.

   This code is partially based on Olin Shivers' reference SRE
   implementation in scsh, although it is simplified in some respects
   and extended in others. See `scsh/re.scm', `scsh/spencer.scm' and
   `scsh/posixstr.scm' in the `scsh' source tree for details. In
   particular, `pcre2el' steals the idea of an abstract data type for
   regular expressions and the general structure of the string regexp
   parser and unparser. The data types for character sets are extended
   in order to support symbolic translation between character set
   expressions without assuming a small (Latin1) character set. The
   string parser is also extended to parse a bigger variety of
   constructions, including POSIX character classes and various Emacs
   and Perl regexp assertions. Otherwise, only the bare minimum of
   scsh's abstract data type is implemented.

1.4 Caveat
===========
   Having two incompatible regexp syntaxes in Lisp source code would
   be confusing for everyone. Please don't use this library to include
   PCRE syntax directly in Emacs packages that other people might use;
   instead, convert it to the usual Emacs Lisp syntax (or `rx' ;-)

   Emacs regexps have their annoyances, but it is worth learning them
   properly. The Emacs assertions for word boundaries, symbol
   boundaries, and syntax classes are very useful, and don't have
   direct PCRE equivalents that I know of. Other things that might be
   done with huge regexps in other languages can be expressed more
   elegantly in Elisp using combinations of `save-excursion' with the
   various searches (regexp, literal, skip-syntax-forward,
   sexp-movement functions, etc.) </soapbox>

1.5 Bugs and Limitations
=========================
   - Not namespace clean (`rxt-' and `pcre-'). Dunno which is better.
   - The order of alternatives and characters in char classes
     sometimes gets shifted around, which is annoying.
   - Although the string parser tries to interpret PCRE's octal and
     hexadecimal escapes correctly, there are problems with matching
     8-bit characters that I don't use enough to properly understand,
     e.g.:
     (string-match-p (rxt-pcre->elisp "\\377") "\377") => nil
     A fix for this would be welcome.

   - Most of PCRE's rules for how `^', `\A', `$' and `\Z' interact with
     newlines in a string are not implemented; they don't seem as
     relevant to Emacs's buffer-oriented rather than
     string/line-oriented model.

   - Many more esoteric PCRE features will never be supported because
     they can't be emulated by translation to Elisp regexps. These
     include the different lookaround assertions, conditionals, and
     the "backtracking control verbs" `(* ...)' . There are better ways
     to do those things in Elisp, anyway (IMHO ;^)

1.5.1 TODO :
-------------
   - improve error reporting
   - PCRE `\L', `\U', `\l', `\u' case modifiers
   - PCRE `\g{...}' backreferences
   - PCREs in isearch mode
   - many other things

1.6 History
============
   This was originally created out of an answer to a stackoverflow
   question:
   [http://stackoverflow.com/questions/9118183/elisp-mechanism-for-converting-pcre-regexps-to-emacs-regexps]
   Thanks to Wes Hardaker for the initial inspiration and subsequent
   hacking, and to priyadarshan for requesting RX/SRE support!
