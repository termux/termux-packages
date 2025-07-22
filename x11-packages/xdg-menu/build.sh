TERMUX_PKG_HOMEPAGE=https://wiki.archlinux.org/title/Xdg-menu
TERMUX_PKG_DESCRIPTION="Tool that generates XDG Desktop Menus for icewm and other window managers"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.6.6"
TERMUX_PKG_SRCURL="https://arch.p5n.pp.ru/~sergej/dl/2023/arch-xdg-menu-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=01cbd3749939c180fed33783f0f7c4f47ac9563af2d1c4b39e23cb6cba792b40
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFFILES="
etc/update-menus.conf
etc/xdg/menus/termux-applications.menu
"

# The original "termux_extract_src_archive" always strips the first components
# but the source of xdg-menu is directly under the root directory of the tar file
termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "$TERMUX_PKG_SRCURL")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	tar -xf "$file" -C "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	install -D -m 0755 xdg_menu "$TERMUX_PREFIX"/bin/xdg_menu
	install -D -m 0755 xdg_menu_su "$TERMUX_PREFIX"/bin/xdg_menu_su
	install -D -m 0755 update-menus "$TERMUX_PREFIX"/bin/update-menus
	install -D -m 0644 update-menus.conf "$TERMUX_PREFIX"/etc/update-menus.conf
	mkdir -p "$TERMUX_PREFIX"/share/desktop-directories/
	cp termux-desktop-directories/* "$TERMUX_PREFIX"/share/desktop-directories/
	mkdir -p "$TERMUX_PREFIX"/etc/xdg/menus/
	cp termux-xdg-menu/* "$TERMUX_PREFIX"/etc/xdg/menus/
}

termux_step_create_debscripts()  {
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/bash
	set -e

	echo "Sideloading Perl XML::Parser..."
	cpan install XML::Parser

	exit 0
	POSTINST_EOF
	chmod +x ./postinst
}
