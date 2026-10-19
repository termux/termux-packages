TERMUX_PKG_HOMEPAGE=https://pagure.io/xmlto/
TERMUX_PKG_DESCRIPTION="Convert xml to many other formats"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.29"
TERMUX_PKG_REVISION="2"
TERMUX_PKG_SRCURL="https://deb.debian.org/debian/pool/main/x/xmlto/xmlto_${TERMUX_PKG_VERSION}.orig.tar.bz2"
TERMUX_PKG_SHA256=6000d8e8f0f9040426c4f85d7ad86789bc88d4aeaef585c4d4110adb0b214f21
TERMUX_PKG_DEPENDS="xsltproc"
TERMUX_PKG_AUTO_UPDATE=false

# XMLTO_BASH_PATH needs to be absolute. The massage step fixes it.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	XMLTO_BASH_PATH=/bin/bash
	MKTEMP=mktemp
	FIND=find
	GETOPT=getopt
	PAPER_CONF=paperconf
	LOCALE=locale
	XMLLINT=xmllint
	XSLTPROC=xsltproc
	DBLATEX=dblatex
	FOP=fop
	XMLTEX=xmltex
	PDFXMLTEX=pdfxmltex
	LYNX=lynx
	LINKS=elinks
	W3M=w3m
	TAIL=tail
	GREP=grep
	SED=sed
	CP=cp
	ZIP=zip
"

termux_step_pre_configure() {
	# AC_PATH_PROG insists on using an absolute path found on the
	# build system, which would be fine if they were just for
	# building, but lots of them end up in the installed "xmlto"
	# script, which is bad when cross-compiling.
	#
	# AC_CHECK_PROG lets us choose the exact spelling, at least
	# when preceded by a matching AC_ARG_VAR - and xmlto's
	# configure.ac very carefully does this before each AC_*_PROG.
	sed -e 's/^AC_PATH_PROG/AC_CHECK_PROG/' -i configure.ac
	autoreconf -fi
}
