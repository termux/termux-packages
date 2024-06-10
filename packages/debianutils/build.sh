TERMUX_PKG_HOMEPAGE=https://packages.debian.org/debianutils
TERMUX_PKG_DESCRIPTION="Small utilities which are used primarily by the installation scripts of Debian packages"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.19"
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1f5552d3f7ecc811a37ba3a70a446bd988fdce64813a475f4038646d126b2019
TERMUX_PKG_AUTO_UPDATE=true

TERMUX_PKG_RM_AFTER_INSTALL="
bin/add-shell
bin/installkernel
bin/remove-shell
bin/update-shells
bin/which
share/man/man1/which.1
share/man/man8/add-shell.8
share/man/man8/installkernel.8
share/man/man8/remove-shell.8
share/man/man8/update-shells.8
"

termux_step_pre_configure() {
	autoreconf -vfi
}
