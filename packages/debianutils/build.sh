TERMUX_PKG_HOMEPAGE=https://packages.debian.org/debianutils
TERMUX_PKG_DESCRIPTION="Small utilities which are used primarily by the installation scripts of Debian packages"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.23.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=79e524b7526dba2ec5c409d0ee52ebec135815cf5b2907375d444122e0594b69
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
