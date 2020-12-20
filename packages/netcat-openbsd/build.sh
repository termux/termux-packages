TERMUX_PKG_HOMEPAGE=https://packages.debian.org/sid/netcat-openbsd
TERMUX_PKG_DESCRIPTION="TCP/IP swiss army knife. OpenBSD variant."
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.217-2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://salsa.debian.org/debian/netcat-openbsd/-/archive/debian/${TERMUX_PKG_VERSION}/netcat-openbsd-debian-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bb6427c49015c8d485c013898b08808192bf5719c40a79676162e5c2d971a34e
TERMUX_PKG_DEPENDS="libbsd"
TERMUX_PKG_CONFLICTS="netcat"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	local p
	for p in $(cat debian/patches/series); do
		echo "Applying debian/patches/$p"
		patch -p1 -i debian/patches/$p
	done

	sed -i -e 's@-lresolv@@g' \
		-e 's@CFLAGS=@CFLAGS?=@g' \
		Makefile

	CFLAGS+=" $CPPFLAGS $LDFLAGS"
}

termux_step_make_install() {
	install -Dm700 nc $TERMUX_PREFIX/bin/netcat-openbsd
	ln -sfr $TERMUX_PREFIX/bin/netcat-openbsd $TERMUX_PREFIX/bin/netcat
	ln -sfr $TERMUX_PREFIX/bin/netcat-openbsd $TERMUX_PREFIX/bin/nc
	install -Dm600 nc.1 $TERMUX_PREFIX/share/man/man1/netcat-openbsd.1
	ln -sfr $TERMUX_PREFIX/share/man/man1/netcat-openbsd.1 \
		$TERMUX_PREFIX/share/man/man1/netcat.1
	ln -sfr $TERMUX_PREFIX/share/man/man1/netcat-openbsd.1 \
		$TERMUX_PREFIX/share/man/man1/nc.1
}

termux_step_install_license() {
	mkdir -p $TERMUX_PREFIX/share/doc/netcat-openbsd
	head -n28 netcat.c | tail -n+2 > $TERMUX_PREFIX/share/doc/netcat-openbsd/LICENSE
}
