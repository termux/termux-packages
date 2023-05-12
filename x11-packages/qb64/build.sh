TERMUX_PKG_HOMEPAGE=https://www.qb64.org/
TERMUX_PKG_DESCRIPTION="BASIC for the modern era."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="licenses/COPYING.TXT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.2
TERMUX_PKG_SRCURL=https://github.com/QB64Team/qb64/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ba4ce7a7a7574ff065707f85c8d5cb741063eae7f7b7e55eb79f9037f300e991
TERMUX_PKG_DEPENDS="glu, clang"
TERMUX_PKG_ANTI_BUILD_DEPENDS="clang"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	rm -rf internal/c/mingw{32,64}
}

termux_step_pre_configure() {
	local d=$TERMUX_PKG_TMPDIR/path
	mkdir $d
	PATH="$d:$PATH"

	cat <<-EOF > $d/gcc
	exec $TERMUX_STANDALONE_TOOLCHAIN/bin/$CC -I$TERMUX_PREFIX/include "\$@"
	EOF
	chmod +x $d/gcc

	cat <<-EOF > $d/g++
	exec $TERMUX_STANDALONE_TOOLCHAIN/bin/$CXX -I$TERMUX_PREFIX/include "\$@"
	EOF
	chmod +x $d/g++

	_QB64_DIR=$TERMUX_PREFIX/share/qb64
}

termux_step_make() {
	install -d $TERMUX_PREFIX/share/applications/
	_pwd=$_QB64_DIR bash -e setup_lnx.sh

	rm internal/source/*
	mv internal/temp/* internal/source/
	find . -type f -iname "*.a" -exec rm {} \;
	find . -type f -iname "*.o" -exec rm {} \;
}

termux_step_make_install() {
	rm -rf $_QB64_DIR
	install -Dt $_QB64_DIR ./qb64 ./run_qb64.sh
	cp -r internal licenses source $_QB64_DIR
	ln -s $_QB64_DIR/qb64 $TERMUX_PREFIX/bin/qb64
}

termux_step_create_debscripts() {
	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = purge ]; then
		rm -rf $_QB64_DIR
	fi
	EOF
}
