TERMUX_PKG_HOMEPAGE="http://www.box2d.org/"
TERMUX_PKG_DESCRIPTION="2D rigid body simulation library for games"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.0"
TERMUX_PKG_SRCURL="https://github.com/erincatto/Box2D/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ffec747b27a2267016f8d0240d658c82d187fb2271fa0f69fcbe53fbc067180d
TERMUX_PKG_AUTO_UPDATE=true
# Pure static library package, no need to split
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=OFF
-DBOX2D_SAMPLES=OFF
"

termux_step_post_make_install() {
	# based on https://src.fedoraproject.org/rpms/Box2D/c/30e868270d6eb345cbe2ce650b8359dac80c73e9?branch=rawhide
	mkdir -p $TERMUX_PREFIX/lib/pkgconfig
	cat >$TERMUX_PREFIX/lib/pkgconfig/box2d.pc <<-EOF
		prefix=$TERMUX_PREFIX
		libdir=\${prefix}/lib
		includedir=\${prefix}/include

		Name: box2d
		Description: $TERMUX_PKG_DESCRIPTION
		Version: $TERMUX_PKG_VERSION
		Libs: -L\${libdir} -lbox2d
		Cflags: -I\${includedir}
	EOF
}
