TERMUX_PKG_HOMEPAGE=https://github.com/iputils/iputils
TERMUX_PKG_DESCRIPTION="Tool to trace the network path to a remote host"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="20240905"
TERMUX_PKG_SRCURL=https://github.com/iputils/iputils/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=055b4e6e4f298c97fd5848898099e59b4590db63fac3f7ad4fa796354ad44403
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d{8}"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	return
}

termux_step_make() {
	return
}

termux_step_make_install() {
	CPPFLAGS+=" -DPACKAGE_VERSION=\"$TERMUX_PKG_VERSION\" -DHAVE_ERROR_H"
	$CC $CFLAGS $CPPFLAGS $LDFLAGS -o $TERMUX_PREFIX/bin/tracepath iputils_common.c tracepath.c

	local MANDIR=$TERMUX_PREFIX/share/man/man8
	mkdir -p $MANDIR
	cd $TERMUX_PKG_SRCDIR/doc
	xsltproc \
		--stringparam man.output.quietly 1 \
		--stringparam funcsynopsis.style ansi \
		--stringparam man.th.extra1.suppress 1 \
		--stringparam iputils.version $TERMUX_PKG_VERSION \
		custom-man.xsl \
		tracepath.xml
	cp tracepath.8 $MANDIR/

	# `traceroute` command is now provided by the package of the same name.
	# Please do not make `traceroute` an alias of `tracepath`.
}
