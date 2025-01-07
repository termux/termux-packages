TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-elf-cleaner
TERMUX_PKG_DESCRIPTION="Cleaner of ELF files for Android"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Please update checksum in termux_step_start_build.sh as well if
# updating the package.
TERMUX_PKG_VERSION=2.2.1
TERMUX_PKG_SRCURL=https://github.com/termux/termux-elf-cleaner/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=105be3c8673fd377ea7fd6becb6782b2ba060ad764439883710a5a7789421c46
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	autoreconf -vfi

	sed "s%@TERMUX_PKG_API_LEVEL@%$TERMUX_PKG_API_LEVEL%g" \
		"$TERMUX_PKG_BUILDER_DIR"/android-api-level.diff | patch --silent -p1
}
