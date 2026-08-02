TERMUX_PKG_HOMEPAGE="http://lpg.ticalc.org/prj_tiemu/"
TERMUX_PKG_DESCRIPTION="TiEmu is an emulator for TI89/TI89-Titanium/TI92/TI92+/V200PLT calculators. (no GDB)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION=3.03
TERMUX_PKG_SRCURL="https://master.dl.sourceforge.net/project/gtktiemu/tiemu-linux/TIEmu%20${TERMUX_PKG_VERSION}/tiemu-${TERMUX_PKG_VERSION}-nogdb.tar.gz"
TERMUX_PKG_SHA256=92d2830842278a8df29ab0717f5b89e06b34e88a50c073fe10ff9e6855b8a592
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="glib, gtk2, libticables2, libticalcs2, libtifiles2, libglade2, pedrom"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-sound
--without-kde
--disable-gdb
"

termux_step_create_debscripts() {
		cat <<-EOF > ./postinst
				#!$TERMUX_PREFIX/bin/sh
				echo
				echo "********"
				echo "TiEmu is installed!"
				echo
				echo "By default it uses the open source PedroM OS for m68k-based TI calculators."
				echo "You may also use a ROM dump of your own calculator, or a downloaded"
				echo "upgrade ROM image from Texas Instruments."
				echo
				echo "It is unlawful to share or distribute your ROM image or an official image from"
				echo "Texas Instruments as they are the property of Texas Instruments Inc."
				echo "********"
				echo
		EOF
}
