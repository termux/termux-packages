TERMUX_PKG_HOMEPAGE=https://github.com/trentbuck/binutils-is-llvm
TERMUX_PKG_DESCRIPTION="Use llvm as binutils"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
# The version number is different from the original one.
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_DEPENDS="lld, llvm"
TERMUX_PKG_PROVIDES="binutils"
TERMUX_PKG_REPLACES="binutils"
TERMUX_PKG_CONFLICTS="binutils"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	ln -sf lld $TERMUX_PREFIX/bin/ld
	local f
	for f in addr2line ar as dwp nm objcopy objdump ranlib readelf size strings strip; do
		ln -sf llvm-${f} $TERMUX_PREFIX/bin/${f}
	done
	ln -sf llvm-cxxfilt $TERMUX_PREFIX/bin/c++filt

	local dir=$TERMUX_PREFIX/share/$TERMUX_PKG_NAME
	mkdir -p $dir
	touch $dir/.placeholder
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		$TERMUX_PKG_BUILDER_DIR/LICENSE
}
