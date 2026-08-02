TERMUX_PKG_HOMEPAGE="https://t3.yaronet.com/?id=19"
TERMUX_PKG_DESCRIPTION="PedroM is an open source Operating System for Ti-68k calculators."
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="0.83"
TERMUX_PKG_SRCURL="https://ticalc.org/pub/89/os/pedrom.zip"
TERMUX_PKG_SHA256=bee0400235ac7c29c890a55be79018f7e561688374a343c01a4fc1f478135cfc
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_configure() {
		:
}

termux_step_make() {
		:
}

termux_step_make_install() {
		local src="$TERMUX_PKG_SRCDIR"
		local pedrom_dir="$TERMUX_PREFIX/share/pedrom"
		local tiemu_dir="$TERMUX_PREFIX/share/tiemu/pedrom"

		mkdir -p "$pedrom_dir" "$tiemu_dir"

		# Install the complete PedroM distribution.
		cp -a "$src"/. "$pedrom_dir"/

		# Make working images available to TiEmu's startup scanner.
		for image in \
				PedroM-89.89u \
				PedroM-89ti.89u \
				PedroM-9x.9xu \
				PedroM-v2.9xu
		do
				install -Dm644 "$src/$image" "$tiemu_dir/$image"
		done
}
