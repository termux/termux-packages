TERMUX_PKG_HOMEPAGE=https://micro-editor.github.io/
TERMUX_PKG_DESCRIPTION="Modern and intuitive terminal-based text editor"
TERMUX_PKG_VERSION=1.3.3
TERMUX_PKG_SHA256=be5a09f00d91bf5203599a4285b0cf709dd61c32e4d2e28e473932ab28664fab
TERMUX_PKG_SRCURL=https://github.com/zyedidia/micro/releases/download/v${TERMUX_PKG_VERSION}/micro-${TERMUX_PKG_VERSION}-src.tar.gz

termux_step_make() {
	return
}

termux_step_make_install() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	local MICRO_SRC=$GOPATH/src/github.com/zyedidia/micro

	cd $TERMUX_PKG_SRCDIR
	mkdir -p $MICRO_SRC
	cp -R . $MICRO_SRC

	cd $MICRO_SRC
	make build-quick
	mv micro $TERMUX_PREFIX/bin/micro
}
