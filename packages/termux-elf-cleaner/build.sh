TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-elf-cleaner
TERMUX_PKG_DESCRIPTION="Cleaner of ELF files for Android"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Please update checksum in termux_step_start_build.sh as well if
# updating the package.
TERMUX_PKG_VERSION=3.0.1
TERMUX_PKG_SRCURL=https://github.com/termux/termux-elf-cleaner/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1c3c6fb33ad8d1fdfe035eee3a5419f54442b93b1a97c4151b31b82c5626a06a
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	sed "s%@TERMUX_PKG_API_LEVEL@%$TERMUX_PKG_API_LEVEL%g" \
		"$TERMUX_PKG_BUILDER_DIR"/android-api-level.diff | patch --silent -p1
}
