TERMUX_PKG_HOMEPAGE=https://github.com/ReFirmLabs/binwalk
TERMUX_PKG_DESCRIPTION="Firmware Analysis Tool - identify and extract files embedded in firmware images"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.0"
TERMUX_PKG_SRCURL=https://github.com/ReFirmLabs/binwalk/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=06f595719417b70a592580258ed980237892eadc198e02363201abe6ca59e49a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

# Runtime dependencies
TERMUX_PKG_DEPENDS="fontconfig, libc++, zlib"

# Recommended dependencies for full functionality
TERMUX_PKG_RECOMMENDS="p7zip, lzop, lz4, xz-utils, bzip2, gzip, tar, cpio, arj, cabextract, cramfsswap, sasquatch, squashfs-tools, sleuthkit"

termux_step_pre_configure() {
	# Setup Rust toolchain for cross-compilation
	termux_setup_rust

	# Disable fonts in plotters
	sed -i 's/plotters = "0.3.6"/plotters = { version = "0.3.6", default-features = false, features = ["bitmap_backend"] }/' Cargo.toml
}

termux_step_post_make_install() {
	# Install magic signatures if they exist
	if [ -f "dependencies/binwalk.magic" ]; then
		mkdir -p ${TERMUX_PREFIX}/share/binwalk
		install -Dm644 dependencies/binwalk.magic \
			${TERMUX_PREFIX}/share/binwalk/magic
	fi
	
	# Install documentation
	install -Dm644 README.md \
		${TERMUX_PREFIX}/share/doc/binwalk/README.md
	
	install -Dm644 LICENSE \
		${TERMUX_PREFIX}/share/licenses/binwalk/LICENSE
}
