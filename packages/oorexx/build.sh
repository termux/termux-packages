TERMUX_PKG_HOMEPAGE=https://www.oorexx.org/
TERMUX_PKG_DESCRIPTION="Open Object Rexx"
TERMUX_PKG_LICENSE="CPL-1.0"
TERMUX_PKG_LICENSE_FILE="CPLv1.0.txt, NOTICE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.2.0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/oorexx/oorexx/${TERMUX_PKG_VERSION}/oorexx-${TERMUX_PKG_VERSION}-13156.tar.gz
TERMUX_PKG_SHA256=0c1378ee212ffae7a192412e908849c0df38fa9c4009f6400e6a5d43a53fbd73
TERMUX_PKG_DEPENDS="libandroid-posix-semaphore, libandroid-spawn, libandroid-wordexp, libc++, libcrypt, ncurses"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DORX_PREBUILT_IMAGE=$TERMUX_PKG_HOSTBUILD_DIR/lib/rexx.img
"

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja
	cmake -G Ninja -DCMAKE_BUILD_TYPE=Release "$TERMUX_PKG_SRCDIR"
	cmake --build . --target rexx_img -j "$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_pre_configure() {
	CFLAGS+=" -fwrapv -fno-strict-aliasing"
	CXXFLAGS+=" -fwrapv -fno-strict-aliasing"
	LDFLAGS+=" -landroid-posix-semaphore -landroid-spawn -landroid-wordexp -lcrypt"
}
