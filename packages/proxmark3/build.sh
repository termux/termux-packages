# Contributor: @s00se
TERMUX_PKG_HOMEPAGE="https://github.com/RfidResearchGroup/proxmark3"
TERMUX_PKG_DESCRIPTION="The Swiss Army Knife of RFID Research - RRG/Iceman repo"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@esque.ca>"
TERMUX_PKG_VERSION="1:4.23346"
TERMUX_PKG_SRCURL="https://github.com/RfidResearchGroup/proxmark3/archive/refs/tags/v${TERMUX_PKG_VERSION:2}.tar.gz"
TERMUX_PKG_SHA256=5d727313d912d8d758365d3528fbf8af7463e5deec23a9bef79f1fab4fd0c66d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libbz2, libc++, liblz4, readline, python"
TERMUX_PKG_BUILD_IN_SRC="true"
TERMUX_PKG_EXCLUDED_ARCHES="i686, x86_64"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_FIRMWARE=OFF -DSKIPQT=1 -DSKIPPTHREAD=1 -DSKIPGD=1"

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_BUILDDIR"/client/proxmark3 "$TERMUX_PREFIX"/bin/proxmark3
	mkdir -p "$TERMUX_PREFIX"/share/proxmark3/
	cp -R "$TERMUX_PKG_BUILDDIR"/client/resources/ "$TERMUX_PREFIX"/share/proxmark3/resources/
	cp -R "$TERMUX_PKG_BUILDDIR"/client/dictionaries/ "$TERMUX_PREFIX"/share/proxmark3/dictionaries/
	cp -R "$TERMUX_PKG_BUILDDIR"/client/pyscripts/ "$TERMUX_PREFIX"/share/proxmark3/pyscripts/
	cp -R "$TERMUX_PKG_BUILDDIR"/client/luascripts/ "$TERMUX_PREFIX"/share/proxmark3/luascripts/
	cp -R "$TERMUX_PKG_BUILDDIR"/client/lualibs/ "$TERMUX_PREFIX"/share/proxmark3/lualibs/
}
