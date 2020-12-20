TERMUX_PKG_HOMEPAGE=https://github.com/adriancable/8086tiny
TERMUX_PKG_DESCRIPTION="A PC XT-compatible emulator/virtual machine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.25
TERMUX_PKG_REVISION=3
# Version tag is unavailable.
TERMUX_PKG_SRCURL=https://github.com/adriancable/8086tiny/archive/c79ca2a34d96931d55ef724c815b289d0767ae3a.tar.gz
TERMUX_PKG_SHA256=ede246503a745274430fdee77ba639bc133a2beea9f161bff3f7132a03544bf6
TERMUX_PKG_DEPENDS="bash, coreutils, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -DNO_GRAPHICS"
}

termux_step_make_install() {
	install -Dm700 8086tiny "$TERMUX_PREFIX"/libexec/8086tiny
	install -Dm600 bios "$TERMUX_PREFIX"/share/8086tiny/bios.bin
	install -Dm600 fd.img "$TERMUX_PREFIX"/share/8086tiny/dos.img

	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@PACKAGE_VERSION@|$TERMUX_PKG_VERSION|g" \
		"$TERMUX_PKG_BUILDER_DIR"/8086tiny.sh > "$TERMUX_PREFIX"/bin/8086tiny
	chmod 700 "$TERMUX_PREFIX"/bin/8086tiny
}
