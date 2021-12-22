TERMUX_PKG_HOMEPAGE=https://github.com/MrJoy/ssss
TERMUX_PKG_DESCRIPTION="Simple command-line implementation of Shamir's Secret Sharing Scheme"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.5.7
TERMUX_PKG_SRCURL=https://github.com/MrJoy/ssss/archive/releases/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dbb1f03797cb3fa69594530f9b2c36010f66705b9d5fbbc27293dce72b9c9473
TERMUX_PKG_DEPENDS="libgmp"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 ssss-split "$TERMUX_PREFIX"/bin/
	ln -sfr "$TERMUX_PREFIX"/bin/ssss-split $TERMUX_PREFIX/bin/ssss-combine

	install -Dm600 ssss.1 "$TERMUX_PREFIX"/share/man/man1/ssss.1
	ln -sfr \
		"$TERMUX_PREFIX"/share/man/man1/ssss.1 \
		"$TERMUX_PREFIX"/share/man/man1/ssss-combine.1
	ln -sfr \
		"$TERMUX_PREFIX"/share/man/man1/ssss.1 \
		"$TERMUX_PREFIX"/share/man/man1/ssss-split.1
}
