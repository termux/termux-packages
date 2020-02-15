TERMUX_PKG_HOMEPAGE=https://micro-editor.github.io/
TERMUX_PKG_DESCRIPTION="Modern and intuitive terminal-based text editor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.0.1
TERMUX_PKG_SRCURL=https://github.com/zyedidia/micro/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=dabbc94f58f63b2b2c4589cdfc83e265019f3ac02e13654bf91927f4bc6434ec

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

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/editor editor $TERMUX_PREFIX/bin/micro 25
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove editor $TERMUX_PREFIX/bin/micro
		fi
	fi
	EOF
}
