TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Create an index of scalable font files for X"
TERMUX_PKG_LICENSE="MIT, HPND"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.4"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/app/mkfontscale-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a01492a17a9b6c0ee3f92ee578850e305315b9f298da5f006a1cd4b51db01a5e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="findutils, freetype, libfontenc, zlib"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros, xorgproto"
TERMUX_PKG_CONFLICTS="xorg-mkfontdir"
TERMUX_PKG_REPLACES="xorg-mkfontdir"

termux_step_create_debscripts() {
	for i in postinst postrm triggers; do
		cp "${TERMUX_PKG_BUILDER_DIR}/${i}" ./${i}
		sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" ./${i}
	done
	unset i
	if [[ "$TERMUX_PACKAGE_FORMAT" == "pacman" ]]; then
		echo "post_install" > postupg
	fi
}
