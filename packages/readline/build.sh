TERMUX_PKG_HOMEPAGE="https://tiswww.case.edu/php/chet/readline/rltop.html"
TERMUX_PKG_DESCRIPTION="Library that allow users to edit command lines as they are typed in"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_BREAKS="bash (<< 5.0), readline-dev"
TERMUX_PKG_REPLACES="readline-dev"
_MAIN_VERSION=8.2
_PATCH_VERSION=10
TERMUX_PKG_VERSION=$_MAIN_VERSION.$_PATCH_VERSION
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/readline/readline-${_MAIN_VERSION}.tar.gz
TERMUX_PKG_SHA256=3feb7171f16a84ee82ca18a36d7b9be109a52c04f492a053331d7d1095007c35
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-curses --enable-multibyte bash_cv_wcwidth_broken=no"
TERMUX_PKG_EXTRA_MAKE_ARGS="SHLIB_LIBS=-lncursesw"
TERMUX_PKG_CONFFILES="etc/inputrc"

termux_step_pre_configure() {
	declare -A PATCH_CHECKSUMS

	PATCH_CHECKSUMS[001]=bbf97f1ec40a929edab5aa81998c1e2ef435436c597754916e6a5868f273aff7
	PATCH_CHECKSUMS[002]=e06503822c62f7bc0d9f387d4c78c09e0ce56e53872011363c74786c7cd4c053
	PATCH_CHECKSUMS[003]=24f587ba46b46ed2b1868ccaf9947504feba154bb8faabd4adaea63ef7e6acb0
	PATCH_CHECKSUMS[004]=79572eeaeb82afdc6869d7ad4cba9d4f519b1218070e17fa90bbecd49bd525ac
	PATCH_CHECKSUMS[005]=622ba387dae5c185afb4b9b20634804e5f6c1c6e5e87ebee7c35a8f065114c99
	PATCH_CHECKSUMS[006]=c7b45ff8c0d24d81482e6e0677e81563d13c74241f7b86c4de00d239bc81f5a1
	PATCH_CHECKSUMS[007]=5911a5b980d7900aabdbee483f86dab7056851e6400efb002776a0a4a1bab6f6
	PATCH_CHECKSUMS[008]=a177edc9d8c9f82e8c19d0630ab351f3fd1b201d655a1ddb5d51c4cee197b26a
	PATCH_CHECKSUMS[009]=3d9885e692e1998523fd5c61f558cecd2aafd67a07bd3bfe1d7ad5a31777a116
	PATCH_CHECKSUMS[010]=758e2ec65a0c214cfe6161f5cde3c5af4377c67d820ea01d13de3ca165f67b4c

	for PATCH_NUM in $(seq -f '%03g' ${_PATCH_VERSION}); do
		PATCHFILE=$TERMUX_PKG_CACHEDIR/readline_patch_${PATCH_NUM}.patch
		termux_download \
			"http://mirrors.kernel.org/gnu/readline/readline-$_MAIN_VERSION-patches/readline${_MAIN_VERSION/./}-$PATCH_NUM" \
			$PATCHFILE \
			${PATCH_CHECKSUMS[$PATCH_NUM]}
		patch -p0 -i $PATCHFILE
	done

	CFLAGS+=" -fexceptions"
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/lib/pkgconfig
	cp readline.pc $TERMUX_PREFIX/lib/pkgconfig/

	mkdir -p $TERMUX_PREFIX/etc
	cp $TERMUX_PKG_BUILDER_DIR/inputrc $TERMUX_PREFIX/etc/
}
