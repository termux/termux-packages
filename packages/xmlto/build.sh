TERMUX_PKG_HOMEPAGE=https://pagure.io/xmlto/
TERMUX_PKG_DESCRIPTION="Convert xml to many other formats"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.29"
TERMUX_PKG_REVISION="1"
TERMUX_PKG_SRCURL=https://www.pagure.io/xmlto/archive/${TERMUX_PKG_VERSION}/xmlto-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=40504db68718385a4eaa9154a28f59e51e59d006d1aa14f5bc9d6fded1d6017a
TERMUX_PKG_DEPENDS="xsltproc"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology

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
