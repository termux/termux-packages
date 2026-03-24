
1.2.0 / 2012-04-24 
==================

  * updated to latest highlight.js
  * Merge branch 'master' of https://github.com/isagalaev/highlight.js
  * Add HTTP to the common set.
  * Added Joe Cheng to AUTHORS
  * Rearanged classref.txt according to test.html
  * Merge branch 'http'
  * Reverted logic of number detection in R: instead of having a number container we now have an identifier/keyword container where all the keywords live. Turns out to be much simpler. Also levelled some keyword relevances.
  * Implement R language highlighter
  * Make processSubLanguage always generate its own markup instead of relying on the caller.
  * HTTP docs and language header
  * Styling for HTTP. Simplified some .title rules along the way.
  * Request headers for HTTP
  * Simpler HTTP definition
  * Initial implementation of HTTP response language.
  * Sub-languages with autodetection
  * [Issue #75] Using named recursive function inside `nodeStream()` instead of relying on `argument.callee`.
  * [Issue #74] Testing beginRe against lexems in `subMode()` should succeed only at the beginning. Thanks to Joe Cheng for the report and the initial patch.
  * Counting a sub-language relevance in a host language.
  * Fixed typo in README.ru
  * Revised readme
  * Named constant for EOF regexp
  * Drop {begin: '\\n'} hack from SQL, we now have another hack to detect EOF
  * Replaced 'if' and two 'returns' with a ternary 'if' under 'return'.
  * Dropped unneeded parens around terminators regexp
  * [Issue #72] Enclose regexp starter keywords in \b...\b
  * Fixed comment typo
  * beginWithKeyword
  * Simplification and consistency tweaks for Solarized themes
  * Double-apostrophe escape in Bash strings
  * More consistent .title coloring in Arta theme
  * `insteadof` keyword in PHP
  * Better handling of EOF in PHP. Thanks to @glitchmr for the hint.
  * Illegalize invalid multi-character ''-strings in D. Makes a good optimization!
  * Dropping D keywords' relevance to the baseline of 1 (mostly) to simplify things.
  * Zeroing relevance of one-letter Perl keywords
  * Zeroing relevance of one-letter AVR assembler built-ins
  * Colorize regexps in Monokai theme
  * Removed 'end' from MatLab built-ins since it's already listed in 'keywords' (which makes more sense anyway).
  * Unbreak packed build by using an obscure spell. Also fix a trailing comma.
  * Illegalize '$' in PHP function and class titles.
  * Reworked PHP description to better catch language features:
  * Decreased relevance of Matlab strings and Markdown underscore emphasis.
  * Removed comment on limited nesting of D comments.
  * Moved D closer to other "C-inspired" languages in test.html
  * Cleaning up relevances in D
  * Illegalize non-whitespace characters in type/iface/enum in Rust
  * Correct definition for nested D comments
  * Merge branch 'master' of https://github.com/raleksandar/highlight.js into d
  * Fixed typos
  * Added D Programming Language definition
  * Add Ilya Baryshev to contributors
  * fixed merge conflict
  * Updated authors list
  * Merge pull request #67 from coagulant/master
  * Nonexistent endtrans removed
  * Added missing templatetags and filters to django.js
  * Version 6.2
  * Merge git://github.com/bolknote/highlight.js into bolk
  * Suffixed numbers in C++
  * [Issue #66] Removed seemingly useless part of filename regexp in profile.js that was interfering with numbers (which is really suspicious by itself).
  * Merge branch 'master' of github.com:isagalaev/highlight.js
  * Google Code style by Aahan Krish
  * Merge pull request #65 from piranha/jshint
  * C99 new types: complex and _Bool
  * +restrict keyword (C99)
  * fix jshint complaints about declarations
  * fix some of jshint complaints (semicolons and comparisons)
  * Removed 'sub_modes' replace from build.py, no longer used.
  * - Reverted hljs.inherit to use copying. Using prototype inheritance made modes to inherit all the wrong compiled stuff created in parents at runtime. - More correct test for existance of 'illegal' pattern.
  * Now do escape in mergeStreams for real.
  * Merge pull request #64 from btd/master
  * Better handling of arguments in a subprocess call to yuicompressor
  * Authorship
  * New function since Go 1: delete
  * Add new type: rune (Go 1+)
  * [Issue #57] More keywords starting a regexp container in Perl
  * Add Denis Bardadym to AUTHORS.en.txt and to matlab.js itself
  * Matlab: fixed whitespace, removed relevance, tidied up test snippet.
  * Merge branch 'master' of https://github.com/btd/highlight.js into matlab
  * Allow spaces in the path to yuicompressor.js
  * [Issue #63] Better regexp for single character in C++
  * Added matlab language support
  * Escaping the last part of the source text in mergeStreams
  * [Issue #60] Removed another trailing comma
  * Illegalize '{' in VHDL
  * Escape buffer in processKeywords only once.
  * [Issue #57] Use regexp container mode for Perl
  * Replaced numbered local variables with arrays.
  * Syntactic sugar for modes referencing themselves in `contains`
  * Fixed typo in C++ test
  * Contributor's email in AUTHORS
  * Merge pull request #58 from grigio/master
  * + DS_Store ignore
  * Monokai theme better HTML
  * Added Luigi Maselli to contributors
  * Merge pull request #56 from grigio/master
  * + Monokai theme
  * Better Erlang numbers
  * Compiling keywords into a more efficient flat object.
  * Count specific keyword relevances for real now.
  * Removed trailing whitespace
  * Use prototyping in hljs.inherit
  * Merge pull request #55 from Sannis/number-modes-refactor
  * Format keywords lists and remove duplicates
  * Refactor out binary number mode to hljs, fix C number mode
  * [Issue #54] Cut down relevance of phpdoc and vhdl literals.
  * Added simple case of heredoc/nowdoc
  * ".1", "1.", "1.e10", ".1e10"
  * Dropped ":" from CoffeeScript function definition to not highlight object keys with function values.
  * Dropped high relevance from b"" strings for Python, PHP now has them too.
  * className type fixed
  * %%var and !var! (cmd.exe)
  * Add simple case of variable variables
  * binary string added (PHP 5.2.1+)
  * Add E-form for numbers
  * '' in Go for char only
  * More correct "`" test for Google Go
  * escape has no effect for "`" in Go
  * Uncommented forgotten className for JavaScript embedded in CoffeeScript.
  * Dropped "Requires" from coffeescript.js and xml.js
  * CoffeScript: fixed code style, trailing commas.
  * CoffeeScript: unified two kinds of function definitions into one, dropped unnecessary relevances.
  * Merge branch 'dnagir-coffeescript' of git://github.com/Sannis/highlight.js into coffeescript
  * Removed trailing comma and fixed \n\r regexps in php.js
  * Noted contribution of Evgeny Stepanischev
  * Added new test for __halt_compiler
  * And more correct __halt_compiler regexp
  * Added __halt_compiler comment
  * Remove unsuitable code
  * Added missing keywords, constants and staff. Also number format was corrected
  * CoffeeScript: fix and improve  * Add modes for heredocs, herecomments and heregex  * Add modes for functions declarations  * Add mode for binary numbers  * Add mode for embedded JavaScript  * Update authors list, CSS and classes reference; improve tests
  * Removed remnants of hljs.IMMEDIATE_RE from Vala

Older Releases
==============

  * bump version
  * updated to latest highlight.js
  * Merge branch 'master' of https://github.com/isagalaev/highlight.js
  * Dropped bold font style from solarized themes. Seemed excessive…
  * added coffeescript to the languages
  * Merge pull request #44 from myadzel/master
  * Change ActionScript test code.
  * ActionScript: "title" mode definitions extracted into a local var.
  * Preprocessor example in ActionScript snippet.
  * ActionScript test snippet moved after JavaScript.
  * Actionscript code cleanup. Dropped unneeded relevances.
  * add ActionScript support (with test)
  * Merge branch 'rust' of git://github.com/vlasovskikh/highlight.js into rust
  * Comment on non-obvious use of a lookahead pattern in xml.js
  * Merge pull request #41 from hitsthings/master
  * XML submodes: Fix the lookahead on script and style so that a lexem ending with style still matches.  Apologies for the bug.
  * Merge pull request #40 from hitsthings/master
  * XML submodes: Don't go into CSS or JS modes on tag names like <styleClass>
  * Removed unnecessary relevance settings for Rust modes
  * Removed extra nested object in keywords
  * Initial Rust support
  * added hljs as command line converter
