TERMUX_PKG_HOMEPAGE=https://nasm.us
TERMUX_PKG_DESCRIPTION="A cross-platform x86 assembler with an Intel-like syntax"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.16.03"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.nasm.us/pub/nasm/releasebuilds/${TERMUX_PKG_VERSION}/nasm-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5bc940dd8a4245686976a8f7e96ba9340a0915f2d5b88356874890e207bdb581
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# Autotools generate clang commandline like `$CC -c -I$TERMUX_PREFIX/include -std=c17 ...`
	# so $TERMUX_PREFIX/include takes precedense in header search paths.
	# It becomes a problem in the case if we build `nasm` in the same env where `libmd` was built
	# because `libmd` installs it's own `md5.h` to `$TERMUX_PREFIX/include`, clang picks it and fails with the following error:
	# nasmlib/md5c.c:46:10: error: no member named 'buf' in 'struct MD5Context'
	#    46 |     ctx->buf[0] = 0x67452301;
	#       |     ~~~  ^
	
	# We should move `-I$TERMUX_PREFIX/include` argument to the end of argument list to make sure it will not take precedense
	# and make sure it will pick `md5.h` from `./include` folder.
	mkdir -p "$TERMUX_PKG_SRCDIR/bin"
	cat <<-EOF > "$TERMUX_PKG_SRCDIR/bin/$CC"
		#!$(readlink /proc/$$/exe)

		# Move -I$TERMUX_PREFIX/include to the end of argument list.
		set -- \$(printf "%s\n" "\$@" | grep -v "\-I$TERMUX_PREFIX/include")
		exec "$(command -v $CC)" "\$@" "-I$TERMUX_PREFIX/include"
	EOF
	chmod +x "$TERMUX_PKG_SRCDIR/bin/$CC"
	export PATH="$TERMUX_PKG_SRCDIR/bin:$PATH"
}
