TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/libidn/
TERMUX_PKG_DESCRIPTION="GNU Libidn library, implementation of IETF IDN specifications"
TERMUX_PKG_VERSION=2.0.3
TERMUX_PKG_SRCURL=http://mirrors.kernel.org/gnu/libidn/libidn2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4335149ce7a5c615edb781574d38f658672780331064fb17354a10e11a5308cd
# Remove the idn tool for now, add it as subpackage if desired::
TERMUX_PKG_RM_AFTER_INSTALL="bin/idn share/man/man1/idn.1 share/emacs"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-ld-version-script"
