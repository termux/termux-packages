TERMUX_PKG_HOMEPAGE=https://github.com/its-pointless/gcc_termux
TERMUX_PKG_DESCRIPTION="Package repository containing GNU Compiler Collection (GCC) programs and libraries"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="its-pointless <its-pointless@users.noreply.github.com> @its-pointless"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/apt/{sources.list.d,trusted.gpg.d}
	echo "deb https://its-pointless.github.io/files/ termux extras" > $TERMUX_PREFIX/etc/apt/sources.list.d/gcc.list
	cp $TERMUX_PKG_BUILDER_DIR/pointless.gpg $TERMUX_PREFIX/etc/apt/trusted.gpg.d/
}

termux_step_create_debscripts () {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "echo Downloading updated package list ..." >> postinst
	echo "apt update" >> postinst
	echo "exit 0" >> postinst
}
