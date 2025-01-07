TERMUX_PKG_HOMEPAGE=http://iverilog.icarus.com/
TERMUX_PKG_DESCRIPTION="Icarus Verilog compiler and simulation tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=12.0
TERMUX_PKG_SRCURL=https://github.com/steveicarus/iverilog/archive/v${TERMUX_PKG_VERSION/./_}.tar.gz
TERMUX_PKG_SHA256=a68cb1ef7c017ef090ebedb2bc3e39ef90ecc70a3400afb4aa94303bc3beaa7d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+_\d+"
TERMUX_PKG_DEPENDS="libbz2, libc++, readline, zlib"
TERMUX_PKG_BREAKS="iverilog-dev"
TERMUX_PKG_REPLACES="iverilog-dev"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
	aclocal
	autoconf
	export CFLAGS+=" -fcommon"

	local _BUILD_LIB=$TERMUX_PKG_BUILDDIR/_build/lib
	mkdir -p $_BUILD_LIB
	for l in bz2 termcap; do
		echo '!<arch>' > $_BUILD_LIB/lib${l}.a
	done
	export LDFLAGS_FOR_BUILD+=" -L$_BUILD_LIB"
}

termux_step_post_configure() {
	find . -name Makefile | xargs -n 1 sed -i \
		-e 's:@EXTRALIBS@::g' \
		-e 's:@MINGW32@:no:g' \
		-e 's:@PICFLAG@:-fPIC:g' \
		-e 's:@install_suffix@::g' \
		-e 's:@rdynamic@:-rdynamic:g' \
		-e 's:@shared@:-shared:g'
}
