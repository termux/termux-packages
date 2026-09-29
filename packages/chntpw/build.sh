TERMUX_PKG_HOMEPAGE=https://pogostick.net/~pnh/ntpasswd/
TERMUX_PKG_DESCRIPTION="Offline Windows NT Password & Registry Editor"
TERMUX_PKG_LICENSE="GPL-2.0-only, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@xingguangcuican6666"
TERMUX_PKG_VERSION="140201"
TERMUX_PKG_SRCURL="https://pogostick.net/~pnh/ntpasswd/chntpw-source-$TERMUX_PKG_VERSION.zip"
TERMUX_PKG_SHA256=96e20905443e24cba2f21e51162df71dd993a1c02bfa12b1be2d0801a4ee2ccc
# NOTE: dependency on openssl/libgcrypt is disabled by default because the code associated with
# it only works on the password databases of Windows 2000 and older (?!?)
# See: https://salsa.debian.org/debian/chntpw/-/blob/e00c8dd756fdb6a04d6dd27e7bedf19981a398f8/debian/changelog#L51
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm 755 chntpw "${TERMUX_PREFIX}/bin/chntpw"
	install -Dm 755 cpnt "${TERMUX_PREFIX}/bin/cpnt"
	install -Dm 755 reged "${TERMUX_PREFIX}/bin/reged"
	install -Dm 755 samusrgrp "${TERMUX_PREFIX}/bin/samusrgrp"
	install -Dm 755 sampasswd "${TERMUX_PREFIX}/bin/sampasswd"
	install -Dm 755 samunlock "${TERMUX_PREFIX}/bin/samunlock"

	local doc docdir="${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}"
	mkdir -p "$docdir"
	for doc in *.txt; do
		install -Dm0644 "$doc" "$docdir/$doc"
	done
}
