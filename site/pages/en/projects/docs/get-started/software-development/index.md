---
page_ref: "@ARK_PROJECT__VARIANT@/termux/termux-packages/docs/@ARK_DOC__VERSION@/get-started/software-development/index.html"
---

# Software Development

<!-- @ARK_DOCS__HEADER_PLACEHOLDER@ -->

Termux is often used for software development and in scientific fields. Termux provides the following development environments.

If you are new to programming and want to learn it in Termux, then know that there are no shortcuts: it takes a lot of time, effort, and patience. People spend lifetimes learning how to program and to keep improving!

One mistake new programmers often make is focusing too much on languages - it's much better to pick a language with a large community and focus on learning how to write programs generally than to jump from new thing to new thing without learning much about anything. Don't stress too much about picking The Best Language. It's sometimes helpful to find a real world problem that you personally have, and then try to find a way to solve it and use the language that will be more appropriate for it.

However, learning how things work at a lower level is also very important to be a good programmer, and so you may want to try to learn a low level language like C/C++ at some point, even if you don't start with it.

We aim to provide tutorials for specific languages in our docs. If you need help with a language that is not listed, feel free to ask - maybe someone in our community can help.

- [APKs](#apks)
- [C/C++](#cc)
- [Common Lisp](#common-lisp)
- [D](#d)
- [Dart](#dart)
- [ECJ](#ecj)
- [Elixir](#elixir)
- [Erlang](#erlang)
- [Forth](#forth)
- [Go](#go)
- [Gradle](#gradle)
- [Groovy](#groovy)
- [Guile](#guile)
- [Haskell](#haskell)
- [Java](#java)
- [JavaScript](#javascript)
- [Kotlin](#kotlin)
- [Lua](#lua)
- [Nim](#nim)
- [NodeJS](#nodejs)
- [OCaml](#ocaml)
- [Octave](#octave)
- [Perl](#perl)
- [PHP](#php)
- [Picolisp](#picolisp)
- [Prolog](#prolog)
- [Python](#python)
- [Racket](#racket)
- [Ruby](#ruby)
- [Rust](#rust)
- [Scala](#scala)
- [Scheme](#scheme)
- [Smalltalk](#smalltalk)
- [Swift](#swift)
- [TinyScheme](#tinyscheme)
- [Tcl](#tcl)

---

&nbsp;





### APKs

APKs (Android application PacKage) can be built in Termux on device with [`openjdk-17`](#java), [`kotlin`](#kotlin) and [`gradle`](#gradle).

Related Pull Request and Temporary Guide: https://github.com/termux/termux-packages/pull/7227#issuecomment-893022283 

## &nbsp;

&nbsp;



### C/C++

**Package:** `clang`

**Description:** C language frontend for LLVM.

**Homepage:** http://clang.llvm.org/

**Related Issues:** https://github.com/termux/termux-packages/issues?q=clang

## &nbsp;

&nbsp;



### Common Lisp

**Package:** `ecl`

**Description:** ECL (Embeddable Common Lisp) interpreter.

**Homepage:** https://common-lisp.net/project/ecl/

## &nbsp;

&nbsp;



### D

**Package:** `ldc`

**Description:** D programming language compiler, built with LLVM.

**Homepage:** https://dlang.org/

**Instructions:** https://wiki.dlang.org/Build_D_for_Android

## &nbsp;

&nbsp;



### Dart

**Package:** `dart`

**Homepage:** https://www.dartlang.org/

## &nbsp;

&nbsp;



### ECJ

**Package:** `ecj`

**Description:** Eclipse Compiler for Java.

**Homepage:** http://www.eclipse.org/jdt/core/

**Related Issues:** https://github.com/termux/termux-packages/issues?q=ecj

## &nbsp;

&nbsp;



### Elixir

**Package:** `elixir`

**Description:** Programming language compatible with the Erlang platform.

**Homepage:** https://elixir-lang.org/

## &nbsp;

&nbsp;



### Erlang

**Package:** `erlang`

**Description:** Erlang programming language and runtime environment.

**Homepage:** https://www.erlang.org/

## &nbsp;

&nbsp;



### Forth

**Package:** `pforth`

**Description:** Portable Forth in C.

**Homepage:** http://www.softsynth.com/pforth/

## &nbsp;

&nbsp;



### Go

**Package:** `golang`

**Description:** Go programming language compiler.

**Homepage:** https://golang.org/

**Instructions:** https://gobyexample.com/hello-world

## &nbsp;

&nbsp;



### Gradle

**Package:** `gradle`

**Description:**  A build automation tool for multi-language software development.

**Homepage:** https://gradle.org

## &nbsp;

&nbsp;



### Groovy

**Package:** `groovy`

**Description:** A multi-faceted language for the Java platform.

**Homepage:** https://groovy-lang.org/

## &nbsp;

&nbsp;



### Guile

**Package:** `guile`

**Homepage:** http://www.gnu.org/software/guile/

## &nbsp;

&nbsp;



### Haskell

**Package:** `ghc`

**Description:** Glasgow Haskell Compiler.  

`ghc` is currently disabled due to build issues. Looking for patches that will fix package.

**Homepage:** https://www.haskell.org/ghc/

**Related Issues:** https://github.com/termux/termux-packages/issues?q=haskell

## &nbsp;

&nbsp;



### Java

**Package:** `openjdk-17`

**Description:** Java development kit and runtime.

**Related Issues:** https://github.com/termux/termux-packages/issues?q=openjdk, https://github.com/termux/termux-packages/issues?q=java

## &nbsp;

&nbsp;



### JavaScript

**Package:** `quickjs`, `duktape`, `nodejs`, `nodejs-lts`

## &nbsp;

&nbsp;



### Kotlin

**Package:** `kotlin`

**Homepage:** https://kotlinlang.org/

## &nbsp;

&nbsp;



### Lua

**Package:** `lua52`

**Package:** `lua53`

**Package:** `lua54`

**Description:** Lightweight embeddable scripting language.

**Homepage:** https://www.lua.org/

## &nbsp;

&nbsp;



### Nim

**Package:** `nim`

**Description:** Nim programming language compiler.

**Homepage:** https://nim-lang.org/

## &nbsp;

&nbsp;



### NodeJS

Main **Article:** [https://wiki.termux.com/index.php?title=Node.js Node.js]

**Homepage:** https://nodejs.org/

## &nbsp;

&nbsp;



### OCaml

[Compiling and setting up OCaml](https://wiki.termux.com/wiki/Compiling_and_setting_up_OCaml) (a copy of the article http://ygrek.org.ua/p/ocaml-termux.html).

**Related Issues:** https://github.com/termux/termux-packages/issues?q=ocaml

**See also:**

- https://ocaml.org/learn/description.html

## &nbsp;

&nbsp;



### Octave

Octave is available from a community repository. [Setup up `its-pointless`](https://wiki.termux.com/wiki/Package_Management#By_its-pointless) repository.

https://github.com/termux/termux-packages/issues?q=octave

## &nbsp;

&nbsp;



### Perl

**Package:** `perl`

**Homepage:** https://www.perl.org/

## &nbsp;

&nbsp;



### PHP

**Package:** `php`

**Description:** Server-side scripting language.

**Homepage:** https://php.net

**Related Issues:** https://github.com/termux/termux-packages/issues?q=php

## &nbsp;

&nbsp;



### Picolisp

**Main external docs:** https://picolisp.com/wiki/?TermuxPentiPicoLisp

**Related Issues:** https://github.com/termux/termux-packages/issues?q=picolisp

## &nbsp;

&nbsp;



### Prolog

**Package:** `swi-prolog`

**Description:** Popular prolog implementation.

**Homepage:** https://swi-prolog.org/

## &nbsp;

&nbsp;



### Python

**Main docs:** https://wiki.termux.com/wiki/Python

**Package:** `python`

**Description:** Python 3 interpreter.

**Package:** `python2`

**Description:** Python 2 interpreter.

**Homepage:** http://python.org/

**Related Issues:** https://github.com/termux/termux-packages/issues?q=python

## &nbsp;

&nbsp;



### Racket

**Package:** `racket`

**Homepage:** https://racket-lang.org

## &nbsp;

&nbsp;



### Ruby

**Main docs:** https://wiki.termux.com/wiki/Ruby

**Package:** `ruby`

**Homepage:** https://www.ruby-lang.org/

**Related Issues:** https://github.com/termux/termux-packages/issues?q=ruby

## &nbsp;

&nbsp;



### Rust

**Package:** `rust`

**Description:** The Rust compiler and Cargo package manager.

**Homepage:** https://www.rust-lang.org

**Related Issues:** https://github.com/termux/termux-packages/issues?q=rust

## &nbsp;

&nbsp;



### Scala

**Package:** `scala`

**Homepage:** https://www.scala-lang.org

## &nbsp;

&nbsp;



### Scheme

**Package:** `scheme48`, `tinyscheme`

## &nbsp;

&nbsp;



### Smalltalk

**Package:** `smalltalk`

**Description:** Smalltalk-80 language implementation by GNU.

**Homepage:** http://smalltalk.gnu.org/


## &nbsp;

&nbsp;



### Swift

**Package:** `swift`

**Description:** Swift compiler.

**Homepage:** https://swift.org/

## &nbsp;

&nbsp;



### TinyScheme

**Package:** `tinyscheme`

**Description:** Very small scheme implementation.

**Homepage:** http://tinyscheme.sourceforge.net/home.html

## &nbsp;

&nbsp;



### Tcl

**Package:** `tcl`

**Homepage:** https://www.tcl.tk/

## &nbsp;

&nbsp;


