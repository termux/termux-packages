TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/libidn/
TERMUX_PKG_DESCRIPTION="GNU Libidn library, implementation of IETF IDN specifications"
TERMUX_PKG_VERSION=1.33
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/libidn/libidn-${TERMUX_PKG_VERSION}.tar.gz
# Remove the idn tool for now, add it as subpackage if desired::
TERMUX_PKG_RM_AFTER_INSTALL="bin/idn share/man/man1/idn.1 share/emacs"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-ld-version-script"
