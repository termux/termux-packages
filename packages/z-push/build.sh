TERMUX_PKG_HOMEPAGE=https://z-push.org/
TERMUX_PKG_DESCRIPTION="An open-source application to synchronize ActiveSync compatible devices and Outlook"
TERMUX_PKG_LICENSE="AGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.7.7"
TERMUX_PKG_SRCURL="https://github.com/Z-Hub/Z-Push/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=36afda54d8ad5ed0c87e2e0648007425d73ec13f33c866a5e28a82771d285105
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="apache2, php"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	cp -rT src "$TERMUX_PREFIX/share/z-push"
	local f
	for f in z-push-{admin,top}; do
		ln -sfr "$TERMUX_PREFIX/share/z-push/${f}.php" "$TERMUX_PREFIX/bin/${f}"
		install -Dm600 -t "$TERMUX_PREFIX/share/man/man8" "man/${f}.8"
	done
	install -Dm600 -t "$TERMUX_PREFIX/etc/apache2/conf.d" config/apache2/*.conf
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	mkdir -p $TERMUX_PREFIX/var/lib/z-push
	mkdir -p $TERMUX_PREFIX/var/log/z-push
	EOF
}
