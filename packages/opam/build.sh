TERMUX_PKG_HOMEPAGE=http://www.ocaml.org
TERMUX_PKG_DESCRIPTION="OPAM is a source-based package manager for OCaml."
TERMUX_PKG_DEPENDS="wget, curl, git, patch, tar, gzip, bzip2, xz-utils, rsync"
_MAIN_VERSION=1.2.2
_PATCH_VERSION=1
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_SRCURL=https://github.com/ocaml/opam/releases/download/${_MAIN_VERSION}/opam-full-${_MAIN_VERSION}.tar.gz
TERMUX_PKG_SHA256=15e617179251041f4bf3910257bbb8398db987d863dd3cfc288bdd958de58f00
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS=termux-exec
termux_step_pre_configure() {
	termux_setup_ocaml

  # One of the patches edited the configure.ac file, so the configure file
  # needs to be regenerated.
  autoreconf -i
}

termux_step_make() {
  # opam's dependencies seem to be broken. So the -j 1 option is given to only
  # build one rule at a time.
  
  # Build the dependencies from the included source instead of using them from
  # the system.
  make -j 1 lib-ext
  # Now build opam.
  make -j 1
}
