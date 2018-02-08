.\"
.\" Created: Sun Mar  8 07:46:40 1998
.\" Revised: Sun Mar  8 10:34:44 1998 by faith@acm.org
.\" Distribution of this memo is unlimited.
.\"
.\" $Id: dicf.ms,v 1.1 1998/07/05 22:10:06 faith Exp $
.\" 
.pl 10.0i
.po 0
.ll 7.2i
.lt 7.2i
.nr LL 7.2i
.nr LT 7.2i
.ds DA 8 March 1988
.ds LH DDG-TR-2 DRAFT
.ds CH DICT Interchange Format
.ds RH \*(DA
.ds LF 
.ds CF 
.ds RF FORMFEED[Page %]
.hy 0
.ad l
.in 0
.tl 'DICT Development Group''\*(LH'
.tl '''\*(DA'
.de HU
.RE
.SH
\\$1
.RS
.hy 0
..
.de HR
.RE
.NH \\$1 \\$2
\\$3
.RS
.hy 0
.XS
\\*(SN\t\\$3
.XE
..
.de HN
.RE
.NH \\$1
\\$2
.RS
.hy 0
.XS
\\*(SN\t\\$2
.XE
..
.de Hn
.RE
.NH \\$1
\\$2
.RS
.hy 0
..
.ds an-empty \" this is referenced to avoid looping on eg .RB ( \\ )
.de BR
.ds an-result \&
.while \\n[.$]>=2 \{\
.       as an-result \fB\\$1\fR\\$2\\*[an-empty]
.       shift 2
.\}
.if \\n[.$] .as an-result \fB\\$1
\\*[an-result]
.ft R
..

.hy 0
.ce
DICT Interchange Format

.RS
.HU "Status of this Memo"

This document is a DICT Development Group Technical Report.

.HU "Abstract"

The DICT Interchange Format (DICF) is a human-readable format for the
interchange of dictionary databases for the use with DICT protocol
client/server software.

.\".bp
.HU "Table of Contents"
.RE
.sp
.nf
.so dicf.toc
.fi
.RS

.HR 1 0 "Introduction"

.HN 2 "Requirements"

In this document, we adopt the convention discussed in Section 1.3.2
of [RFC1122] of using the capitalized words MUST, REQUIRED, SHOULD,
RECOMMENDED, MAY, and OPTIONAL to define the significance of each
particular requirement specified in this document.

In brief: "MUST" (or "REQUIRED") means that the item is an absolute
requirement of the specification; "SHOULD" (or "RECOMMENDED") means
there may exist valid reasons for ignoring this item, but the full
implications should be understood before doing so; and "MAY" (or
"OPTIONAL") means that his item is optional, and may be omitted
without careful consideration.

.HN 1 "Design Considerations"

.HN 2 "Introduction"

The goal of DICF is to provide a format suitable for the interchange of
dictionary databases.  New databases can be converted into DICF, and then
the DICF can be analyzed and indexed by DICT server software.

If machine translation were the only use of DICF, then SGML might be the
best choice for DICF syntax.  However, we expect humans to create new
dictionary databases by hand, and we have found that the use of SGML
without specialized editors is difficult for humans to read and edit.  We
have found a minimalistic syntax, similar to
.B nroff
or TeX, easier to edit using a wide variety of text-based editors.

Further, we would like to be able to combine a DICF formatting engine into
other pieces of software, such as DICT protocol clients and servers.
Therefore, we would like the parsing and formatting requirements of DICF to
be lightweight and easy to implement.  We also would like underlying engine
to be powerful enough to support unforeseen extensions that might be needed
to support complex databases.  From this viewpoint, engines bases on SGML
or TeX would be too large to be easily embedded in other applications.  The
.B nroff
language [NROFF86] is well documented, extensible, and relatively small.
We have decided to base the DICF langauge syntax and capabilities on an
extended subset of
.BR nroff .

.HN 2 "Requirements"

DICF must be translatable to the following formats:
.RS
.IP \(bu
ASCII text [ASCII]
.IP \(bu
UTF-8 encoded text [ISO10646,RFC2044]
.IP \(bu
HTML [XXX]
.RE

Further, DICF must be sufficiently powerful to support the indexing
requirements of current and future versions of DICT client/server software;
and DICF must be editable without a specialized editor.

.HN 2 "Limitations"

DICF provide simpler capabilities that a full
.B nroff
implementation:
.RS
.IP \(bu
Page control commands are not needed, since a single definition will always
appear on a single logical page.  This includes the commands:
.BR .pl ", " .bp ", " .pn ", " .po ", " .ne ", " .mk ", and " .rt .
.IP \(bu
Because definitions and formatting instructions will be included in a
single file, the ability to access other files and programs should not be
supported.  This includes the commands:
.BR .so ", " .nx ", and " .pi .
Note that the elimination of these command also eliminates security
considerations from the formatting language.
.RE

Because the notion of pages have changed, commands dealing with traps
(i.e.,
.BR .wh ", " .ch ", " .dt ", " .em ", and " .it )
and
titles
(i.e.,
.BR .tl ", " .pc, ", and " .lt )
may have slightly different meanings than in standard
.BR nroff .

.HN 2 "Extensions"

Because of the necessity of dealing with UTF-8 encoded characters and the
requirement that DICF file can be easily edited by standard editors, the
syntax for special characters is extended.

.HN 1 "Language Syntax"

.HN 1 "Commands"

.HN 2 "Entries"

An "entry" will contain a definitiona and will usually be marked for
indexing by at least one headword (if no headwords are marked in an entry,
then the entry cannot be searched for).

An entry starts with:
.DS
 .e
.DE
or with:
.DS
 .e word
.DE
which is equivalent to:
.DS
 .e
 .h word
.DE
as described in the next section.

An entry ends when:
.RS
.IP \(bu
the next entry begins,
.IP \(bu
the end of the file is reached,
.IP \(bu
or
.DS
 ..
.DE
is seen on the input.
.RE

Blank lines at the end of an entry MUST BE elided.

.HN 2 "Headwords"

For an entry, several words might be marked as "headwords".  These
headwords are placed in an index such that a search on the index for the
headword will return the entry containing the headword.  By default, if a
headword is indexed, then all standard search methods should find that
headword and return the definition.

However, some headwords may best identify an entry only when an "exact"
search is performed, and should not be returned for various inexact
searches.  For example, uncommon spellings or misspellings of a word may
reasonably identify an entry when an exact search is performed, but would
confuse a user if these spellings were also returned when an inexact search
was performed.  Another example arises in gazetteer-like dictionaries: an
exact search for "city, state" should return the appropriate informatin,
but inexact searches should only return a list of cities without state
names \(em otherwise too many matches are returned for inexact searches,
making these types of searches useless (because so many cities have the
same name).

Other headwords may be marked so that they are only returned for specific
types of searches.  For example, an entry may mark several words as
"mentioned".  These words should not identify the entry for the usual exact
or inexact searches, because doing to would return too many unrelated
definitions.  However, a special "mentioned" search may return entries
which mention or provide usage examples for words which are peripheral to
the main word being defined by the entry.

The best types of searches provided depend on the specific database.  DICF
defines the three most common builtin marks for headwords:

.DS
 .h word
.DE
marks "word" as a headword for common exact and inexact searches.

.DS
 .he word
.DE
marks "word" as a headword only for exact searches.  If the DICT server
does not support multiple types of index entries, then this headword will
not be indexed.

.DS
 .hm word
.DE
marks "word" as a headword only for special "mentioned" searches.  If the
DICT server does not support multiple types of index entries, then this
headword will not be indexed.

By default, a word marked as a headword will be inserted in place in the
text of the definition.  If this insertion is not desired, the following
alternative forms of these commands are provided:
.B .hn ", " .hen ", and " .hmn .

.HN 2 "Cross References"

For an entry, several words might be marked as "cross references"
so that, during definition display, selection of one of these words will
search for another definition.  By default, these words are inserted in
place in the text of the definition.  As with the headword commands, an
alternative form is provided that does not have this behavior.

.DS
 .x word
.DE
marks "word" as a cross reference to another entry, inserting the word in
place in the definition text.

.DS
 .xn word
.DE
marks "word" as a cross reference to another entry, but does not insert the
word in the definition text.  If the DICT server does not support cross
references to words which do not appear in the text, then "word" will be
ignored.  This command is provided for orthogonality with the headword
commands and for support of future DICT and DICF capabilities.

.HN 2 "Word Marks"

Some words (including compound words, or phrases) may be marked as having
special features which may imply status as a headword and/or cross
reference, or suggest the use of font changes to set the word appart.  For
example:
.DS
 .title       Book/paper/record/movie title
 .person      Name of a person
 .syn         Synonym
 .ant         Antonym
 .cf          Compare with
 .see         See also
 .genus       Name of a genus
 .species     Name of a species
 .subspecies  Name of a subspecies
 .order       Name of an order
 .phylum      Name of a phylum
 .class       Name of a class
 .family      Name of a family
 .chem        Chemical notation
 .math        Mathematical notation [XXX shouldn't be here]
.DE

.HN 2 "Informational Marks"

In many databases, the text of the entry will follow the headword in a free
format.  For other databases, marking some parts of the entry may be
helpful for later machine processing or formatting:
.DS
 .note        Note
 .usage       Usage note
 .q           Quote, usually as an example
 .qa          Author of previous quote
 .ex          Example of usage
 .au          Author of entry
 .s           Source of entry
 .pron        Pronounciation
 .syl         Syllabification
 .pos         Part of speech
 .var         Variant
 .altsp       Alternative spelling
 .pl          Spelling of plural form
 .sing        Spelling of singular form
.DE

.HN 1 "Security Considerations"

Because DICF commands cannot cause the execution of arbitrary programs,
DICF raises no security issues.

.HN 1 "References"

.XP
[ASCII] US-ASCII. Coded Character Set - 7-Bit American Standard Code
for Information Interchange. Standard ANSI X3.4-1986, ANSI, 1986.

.XP
[ISO10646] ISO/IEC 10646-1:1993. International Standard -- Information
technology -- Universal Multiple-Octet Coded Character Set (UCS) --
Part 1: Architecture and Basic Multilingual Plane.  UTF-8 is described
in Annex R, adopted but not yet published.  UTF-16 is described in
Annex Q, adopted but not yet published.

.XP
[NROFF86] Ossanna, Joseph F. Nroff/Troff User's Manual, updated for 4.3BSD
by Mark Seiden (USD-24).  Published in UNIX User's Supplementary Documents
(USD): 4.3 Berkeley Software Distribution, Virtual VAX-11 Version, April
1986 (Computer Systems Research Group, Computer Science Division,
Department of Electrical Engineering and COmputer Science, University of
California, Berkeley).

.XP
[RFC2044] Yergeau, F., "UTF-8, a transformation format of Unicode and
ISO 10646", RFC-2044, Alis Technologies, October 1996.

.HN 1 "Acknowledgements"

.HN 1 "Author's Addresses"

.DS
Rickard E. Faith
EMail: faith@cs.unc.edu (or faith@acm.org)
.DE
.DS
Bret Martin
EMail: bamartin@miranda.org
.DE
.RE
.\" Local Variables:
.\" mode: nroff
.\" mode: font-lock
.\" fill-column: 70
.\" End:
