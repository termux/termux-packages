TERMUX_PKG_HOMEPAGE=http://www.hpng.org
TERMUX_PKG_DESCRIPTION="hping is a command-line oriented TCP/IP packet assembler/analyzer."
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_DEPENDS="libandroid-shmem, libpcap"
TERMUX_PKG_SHA256=f1684e568b6d00ba096e1c77b18be4500ca2b8d2715bb2059aff22b8b8717eff
TERMUX_PKG_SRCURL=https://hax4us.github.io/hping/hping3-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-tcl"
termux_step_pre_configure {
  sudo apt-get install -y libpcap0.8-dev
  }
