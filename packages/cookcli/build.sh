TERMUX_PKG_HOMEPAGE=https://cooklang.org
TERMUX_PKG_DESCRIPTION="A suite of tools to create shopping lists and maintain food recipes"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@buttaface"
TERMUX_PKG_VERSION=0.1.5
TERMUX_PKG_SRCURL=https://github.com/CookLang/CookCLI/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=443441bc7302096a667159df6535aadb655944165315110e0c1103496f1a3f9c
TERMUX_PKG_DEPENDS="swift"
TERMUX_PKG_BUILD_DEPENDS="swift"
TERMUX_PKG_BLACKLISTED_ARCHES="i686"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_swift

	# This will check out the package dependencies, so they can be patched.
	$SWIFT_BINDIR/swift package update

	patch -p1 < $TERMUX_PKG_BUILDER_DIR/cook-dependencies.diff

	local SWIFT_FLAGS=""
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		SWIFT_FLAGS="--destination $SWIFT_CROSSCOMPILE_CONFIG "
		SWIFT_FLAGS+="-Xlinker -rpath -Xlinker \$ORIGIN/../lib:\$ORIGIN/../lib/swift/android"
		export PKG_CONFIG_PATH=$PKG_CONFIG_LIBDIR
	fi
	$SWIFT_BINDIR/swift build -c release -j $TERMUX_MAKE_PROCESSES $SWIFT_FLAGS
}
termux_step_make_install() {
	install -Dm700 \
		$TERMUX_PKG_SRCDIR/.build/$SWIFT_TARGET_TRIPLE/release/cook \
		$TERMUX_PREFIX/bin
}
