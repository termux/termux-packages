TERMUX_PKG_HOMEPAGE=https://github.com/mitnk/cicada
TERMUX_PKG_DESCRIPTION="A bash like Unix shell"
TERMUX_PKG_MAINTAINER="Hugo Wang <w@mitnk.com>"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION="0.9.34"
TERMUX_PKG_SRCURL=https://github.com/mitnk/cicada/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0e986d542a57c57e849089ee8386f9863b17f7378b7d565c35174242afc36712
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_pre_configure() {
	rm -f Makefile

	if [ "$TERMUX_ARCH" == "x86_64" ]; then
		local libdir=target/x86_64-linux-android/release/deps
		mkdir -p $libdir
		pushd $libdir
		local libgcc="$($CC -print-libgcc-file-name)"
		echo "INPUT($libgcc -l:libunwind.a)" > libgcc.so
		popd
	fi
}
