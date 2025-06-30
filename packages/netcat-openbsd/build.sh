TERMUX_PKG_HOMEPAGE=https://packages.debian.org/sid/netcat-openbsd
TERMUX_PKG_DESCRIPTION="TCP/IP swiss army knife. OpenBSD variant."
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.229-1"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://salsa.debian.org/debian/netcat-openbsd/-/archive/debian/${TERMUX_PKG_VERSION}/netcat-openbsd-debian-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4984c52882affcc638678a887964f7ab1d21901a2c5c37a38363138370d4dbda
TERMUX_PKG_PROVIDES="nc, ncat, netcat"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP="s/_/-/"
TERMUX_PKG_DEPENDS="libbsd"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	local p
	for p in $(cat debian/patches/series); do
		echo "Applying debian/patches/$p"
		patch -p1 -i "debian/patches/$p"
	done

	sed -i -e 's@-lresolv@@g' \
		-e 's@CFLAGS=@CFLAGS?=@g' \
		Makefile

	CFLAGS+=" $CPPFLAGS $LDFLAGS"
}

termux_step_make_install() {
	install -Dm700 nc "$TERMUX_PREFIX/bin/netcat-openbsd"
	install -Dm700 nc.1 "$TERMUX_PREFIX/share/man/man1/netcat-openbsd.1"
}

termux_step_install_license() {
	mkdir -p "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME"
	head -n28 netcat.c | tail -n+2 > "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/LICENSE"
}
