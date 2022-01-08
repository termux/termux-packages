TERMUX_PKG_HOMEPAGE=http://x3270.bgp.nu/
TERMUX_PKG_DESCRIPTION="A family of IBM 3270 terminal emulators and related tools"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="include/copyright.h"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.1ga11
TERMUX_PKG_SRCURL=https://prdownloads.sourceforge.net/x3270/suite3270-${TERMUX_PKG_VERSION}-src.tgz
TERMUX_PKG_SHA256=c36d12fcf211cce48c7488b06d806b0194c71331abdce6da90953099acb1b0bf
TERMUX_PKG_DEPENDS="less, libexpat, libiconv, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-windows
--disable-x3270
--disable-tcl3270 
ac_cv_path_LESSPATH=$TERMUX_PREFIX/bin/less
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DNCURSES_WIDECHAR"

	find $TERMUX_PKG_SRCDIR -name '*.c' | xargs -n 1 sed -i \
		-e 's:"\(/bin/sh"\):"'$TERMUX_PREFIX'\1:g' \
		-e 's:"\(/tmp\):"'$TERMUX_PREFIX'\1:g'
}

termux_step_post_configure() {
	local bin=$TERMUX_PKG_BUILDDIR/_prefix/bin
	mkdir -p $bin
	pushd $TERMUX_PKG_SRCDIR/Common
	$CC_FOR_BUILD mkicon.c -o mkicon
	cp mkicon $bin/
	pushd c3270
	$CC_FOR_BUILD mkkeypad.c -o mkkeypad
	cp mkkeypad $bin/
	popd
	popd
	PATH=$bin:$PATH
}
