TERMUX_PKG_HOMEPAGE=https://www.rust-lang.org/
TERMUX_PKG_DESCRIPTION="Systems programming language focused on safety, speed and concurrency"
TERMUX_PKG_VERSION=1.29.2
TERMUX_PKG_SRCURL=https://static.rust-lang.org/dist/rustc-$TERMUX_PKG_VERSION-src.tar.gz
TERMUX_PKG_SHA256=5088e796aa2e47478cdf41e7243fc5443fafab0a7c70a11423e57c80c04167c9
TERMUX_PKG_DEPENDS="clang, openssl"

termux_step_configure () {
	termux_setup_cmake

	if [ "$TERMUX_ARCH" = "arm" ]; then
		TRIPLE="armv7-linux-androideabi"
	else
		TRIPLE="$TERMUX_HOST_PLATFORM"
	fi

	sed "s%\\@TERMUX_PREFIX\\@%$TERMUX_PREFIX%g" \
		$TERMUX_PKG_BUILDER_DIR/config.toml \
		| sed "s%\\@TERMUX_STANDALONE_TOOLCHAIN\\@%$TERMUX_STANDALONE_TOOLCHAIN%g" \
		| sed "s%\\@TERMUX_STANDALONE_TOOLCHAIN\\@%$TERMUX_STANDALONE_TOOLCHAIN%g" \
		| sed "s%\\@TRIPLE\\@%$TRIPLE%g" \
		> config.toml

	export LD_LIBRARY_PATH=$TERMUX_PKG_BUILDDIR/build/x86_64-unknown-linux-gnu/llvm/lib
	export OPENSSL_DIR=$TERMUX_PREFIX

	unset CC CXX CPP LD CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
}

termux_step_make () {
	$TERMUX_PKG_SRCDIR/x.py dist

}

termux_step_make_install () {
	$TERMUX_PKG_SRCDIR/x.py install
}
