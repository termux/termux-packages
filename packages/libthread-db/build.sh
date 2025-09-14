TERMUX_PKG_HOMEPAGE=https://android.googlesource.com/platform/ndk/
TERMUX_PKG_DESCRIPTION="Thread debugging library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=22 # removed in NDK r23
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://android.googlesource.com/platform/ndk/+archive/refs/tags/ndk-r${TERMUX_PKG_VERSION}/sources/android/libthread_db.tar.gz
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_BUILD_IN_SRC=true

termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "${TERMUX_PKG_SRCURL}")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	tar xf "$file" -C "$TERMUX_PKG_SRCDIR" libthread_db.c thread_db.h
}

termux_step_post_get_source() {
	sha256sum -c $TERMUX_PKG_BUILDER_DIR/src.sha256sum
	cp $TERMUX_PKG_BUILDER_DIR/td_init.c ./
}

termux_step_make() {
	$CC $CPPFLAGS -I. $CFLAGS libthread_db.c td_init.c \
		-shared -o libthread_db.so $LDFLAGS
}

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/include "$TERMUX_PKG_SRCDIR/thread_db.h"
	install -Dm600 -t $TERMUX_PREFIX/lib "$TERMUX_PKG_BUILDDIR/libthread_db.so"
	ln -sf libthread_db.so $TERMUX_PREFIX/lib/libthread_db.so.1
}
