TERMUX_PKG_HOMEPAGE=https://www.erlang.org/
TERMUX_PKG_DESCRIPTION="General-purpose concurrent functional programming language"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="28.3.1"
TERMUX_PKG_SRCURL=https://github.com/erlang/otp/archive/refs/tags/OTP-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0174210eef9db97d41fc277ee272d707f6ee4e07850225e6973216215946aad9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='OTP-\d+(\.\d+)+'
TERMUX_PKG_DEPENDS="libc++, openssl, ncurses, zlib"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-javac
--with-ssl=${TERMUX_PREFIX}
--with-termcap
erl_xcomp_sysroot=${TERMUX_PREFIX}
"
# for some reason, these do not work properly, and are duplicates
# of ones patched to work which are installed into $TERMUX_PREFIX/share/man/man1
TERMUX_PKG_RM_AFTER_INSTALL="
lib/erlang/man
"
# were present in erlang 26
# were not present in erlang 27 through erlang 28.2
# reappeared in erlang 28.3
# https://github.com/erlang/otp/pull/10237
# conflict with zlib
# conflict with perl
# conflict with libowfat
# conflict with manpages
TERMUX_PKG_RM_AFTER_INSTALL+="
share/man/man3/zlib.3
share/man/man3/re.3
share/man/man3/array.3
share/man/man3/inet.3
share/man/man3/queue.3
share/man/man3/rand.3
share/man/man3/random.3
share/man/man3/rpc.3
share/man/man3/string.3
"
# will overwrite man pages of perl and zlib
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

termux_step_post_get_source() {
	# We need a host build every time, because we dont know the full output of host build and have no idea to cache it.
	rm -Rf "$TERMUX_PKG_HOSTBUILD_DIR"
}

termux_step_host_build() {
	cd $TERMUX_PKG_BUILDDIR
	# Erlang cross compile reference: https://github.com/erlang/otp/blob/master/HOWTO/INSTALL-CROSS.md#building-a-bootstrap-system
	# Build erlang bootstrap system.
	# the prefix must be set to $TERMUX_PREFIX here to install the documentation where desired
	# without making a mess.
	./configure --prefix="$TERMUX_PREFIX" --without-javac --with-termcap
	make -j $TERMUX_PKG_MAKE_PROCESSES
	make RELSYS_MANDIR="$TERMUX_PREFIX/share/man" install-docs
}

termux_step_pre_configure() {
	# Add --build flag for erlang cross build
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --build=$(./erts/autoconf/config.guess)"

	# https://android.googlesource.com/platform/bionic/+/master/docs/32-bit-abi.md#is-32_bit-on-lp32-y2038
	if [ $TERMUX_ARCH_BITS = 32 ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-year2038"
	fi

	# Use a wrapper CC to move `-I@TERMUX_PREFIX@/include` to the last include param
	mkdir -p $TERMUX_PKG_TMPDIR/_fake_bin
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		-e "s|@COMPILER@|$(command -v ${CC})|g" \
		"$TERMUX_PKG_BUILDER_DIR"/wrapper.py.in \
		> $TERMUX_PKG_TMPDIR/_fake_bin/"$(basename ${CC})"
	chmod +x $TERMUX_PKG_TMPDIR/_fake_bin/"$(basename ${CC})"
	export PATH="$TERMUX_PKG_TMPDIR/_fake_bin:$PATH"
}
