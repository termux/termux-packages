TERMUX_PKG_HOMEPAGE=https://android.googlesource.com/platform/bionic/+/refs/heads/master/libm/upstream-netbsd/lib/libm/complex
TERMUX_PKG_DESCRIPTION="A shared library providing libm complex math functions"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_AUTO_UPDATE=false

# https://android.googlesource.com/platform/bionic/+/9ee6adb003eb5a9855ff6c47f9c150b415a11299
# https://android.googlesource.com/platform/bionic/+/refs/tags/android-8.1.0_r81/libm/upstream-netbsd/lib/libm/complex/
# https://android.googlesource.com/platform/bionic/+/main/libm/libm.map.txt
# https://android.googlesource.com/platform/bionic/+/main/docs/status.md#libm

# Use the full NetBSD implementation as is from Android O
# instead of matching the latest Android implementation which is a mix of FreeBSD and NetBSD

termux_step_pre_configure() {
	CPPFLAGS+=" -D__USE_GNU"
	CFLAGS+=" -fPIC"
	LDFLAGS+=" -lm"
}

termux_step_make() {
	$CC $CFLAGS $CPPFLAGS -c $TERMUX_PKG_BUILDER_DIR/upstream-netbsd/lib/libm/complex/*.c
	$CC $CFLAGS -shared $LDFLAGS -o libandroid-complex-math.so *.o
	$AR cru libandroid-complex-math.a *.o
	cp -f $TERMUX_PKG_BUILDER_DIR/LICENSE $TERMUX_PKG_SRCDIR/
}

termux_step_make_install() {
	install -Dm644 -t $TERMUX_PREFIX/lib libandroid-complex-math.{a,so}
}
