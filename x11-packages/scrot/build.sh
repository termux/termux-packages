TERMUX_PKG_HOMEPAGE=https://github.com/dreamer/scrot
TERMUX_PKG_DESCRIPTION="Simple command-line screenshot utility for X"
# License: MIT-feh
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12.1"
TERMUX_PKG_SRCURL=https://github.com/resurrecting-open-source-projects/scrot/releases/download/${TERMUX_PKG_VERSION}/scrot-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=45bed70abd74ffeeec08b75089ba44900291e9c86309bcce892ccc7ece8f1e61
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="imlib2, libx11, libxcomposite, libxext, libxfixes, libxinerama"

termux_step_pre_configure() {
	local _inc="$TERMUX_PKG_SRCDIR/_getsubopt/include"
	rm -rf "${_inc}"
	mkdir -p "${_inc}"
	cp "$TERMUX_PKG_BUILDER_DIR/getsubopt.h" "${_inc}"

	CPPFLAGS+=" -I${_inc} -D__force= -UANDROID"

	local _lib="$TERMUX_PKG_BUILDDIR/_getsubopt/lib"
	rm -rf "${_lib}"
	mkdir -p "${_lib}"
	pushd "${_lib}"/..
	$CC $CFLAGS $CPPFLAGS "$TERMUX_PKG_BUILDER_DIR/getsubopt.c" \
		-fvisibility=hidden -c -o ./getsubopt.o
	$AR cru "${_lib}"/libgetsubopt.a ./getsubopt.o
	popd

	LDFLAGS+=" -L${_lib} -l:libgetsubopt.a"
}
