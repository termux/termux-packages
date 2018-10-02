TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-root-packages
TERMUX_PKG_DESCRIPTION="Package repository containing programs for rooted devices"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/apt/{sources.list.d,trusted.gpg.d}
	echo "deb https://grimler.se root stable" > $TERMUX_PREFIX/etc/apt/sources.list.d/root.list
	cp $TERMUX_PKG_BUILDER_DIR/grimler.gpg $TERMUX_PREFIX/etc/apt/trusted.gpg.d/
}
