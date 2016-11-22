TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/make/
TERMUX_PKG_DESCRIPTION="Tool which controls the generation of executables and other non-source files of a program from the program's source files"
TERMUX_PKG_VERSION=4.2.1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/make/make-${TERMUX_PKG_VERSION}.tar.gz
# Prevent linking against libelf:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_elf_elf_begin=no"
