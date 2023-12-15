TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-elf-cleaner
TERMUX_PKG_DESCRIPTION="Cleaner of ELF files for Android"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Please update checksum in termux_step_start_build.sh as well if
# updating the package.
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_SRCURL=https://github.com/termux/termux-elf-cleaner/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=84b88d52811cd86e33c42458e0374d375912403e4035893dd57e9cac335114a5
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	autoreconf -vfi

	sed "s%@TERMUX_PKG_API_LEVEL@%$TERMUX_PKG_API_LEVEL%g" \
		"$TERMUX_PKG_BUILDER_DIR"/android-api-level.diff | patch --silent -p1
}
