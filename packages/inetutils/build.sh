TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/inetutils/
TERMUX_PKG_DESCRIPTION="Collection of common network programs"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/inetutils/inetutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=87697d60a31e10b5cb86a9f0651e1ec7bee98320d048c0739431aac3d5764fb6
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_BUILD_DEPENDS="libandroid-glob"
TERMUX_PKG_SUGGESTS="whois"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/whois share/man/man1/whois.1"
# These are old cruft / not suited for android
# (we --disable-traceroute as it requires root
# in favour of tracepath, which sets up traceroute
# as a symlink to tracepath):
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-ifconfig
--disable-ping
--disable-ping6
--disable-rcp
--disable-rexec
--disable-rexecd
--disable-rlogin
--disable-rsh
--disable-traceroute
--disable-uucpd
ac_cv_lib_crypt_crypt=no
gl_cv_have_weak=no
"

termux_step_host_build() {
	# help2man fails to get mans from our binaries
	# let's build binaries it can launch for generating mans
	
	cp -r "$TERMUX_PKG_SRCDIR"/* .
	aclocal --force
	autoreconf -fi

	# For some reason I get undefined reference to `crypt` so I make it noop
	echo "__attribute__((weak)) void crypt(void) {}" | gcc -x c -c - -o crypt.o

	sed -i 's/PATH_LOG/"logcat"/g' ./src/logger.c
	LDFLAGS=" $TERMUX_PKG_HOSTBUILD_DIR/crypt.o" \
	./configure $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	make
}

termux_step_pre_configure() {
	aclocal --force
	autoreconf -fi

	# Reuse binaries from host-build to generate mans
	sed -i 's,@HOSTBUILD@,'"$TERMUX_PKG_HOSTBUILD_DIR"',' "$TERMUX_PKG_SRCDIR/man/Makefile.am"
	CFLAGS+=" -DNO_INLINE_GETPASS=1"
	CPPFLAGS+=" -DNO_INLINE_GETPASS=1 -DLOGIN_PROCESS=6 -DDEAD_PROCESS=8 -DLOG_NFACILITIES=24 -fcommon"
	LDFLAGS+=" -landroid-glob -llog"
	touch -d "next hour" ./man/whois.1
}

termux_step_post_configure() {
	cp $TERMUX_PKG_BUILDER_DIR/malloc.h $TERMUX_PKG_BUILDDIR/lib/
}
