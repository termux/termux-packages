TERMUX_PKG_HOMEPAGE=https://mmonit.com/monit/
TERMUX_PKG_DESCRIPTION="Utility for managing and monitoring processes, programs, files, directories and filesystems"
TERMUX_PKG_LICENSE="AGPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.0.0"
TERMUX_PKG_SRCURL="https://mmonit.com/monit/dist/monit-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="ddacd2a8120aeb2351e4486ee04a17782b5004aee99f2041d829bc4dcf2a5b3b"
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-support, zlib, openssl, libcrypt"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/monitrc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-pam
--with-ssl=yes
--with-ssl-dir=$TERMUX_PREFIX
--with-ssl-incl-dir=$TERMUX_PREFIX/include
--with-ssl-lib-dir=$TERMUX_PREFIX/lib
--oldincludedir=$TERMUX_PREFIX/include
--enable-optimized
--prefix=$TERMUX_PREFIX
--sysconfdir=$TERMUX_PREFIX/etc
LIBS=-landroid-glob
"

termux_step_pre_configure() {
	export LIBS="-lssl -lcrypto"
}

termux_step_configure() {
	"$TERMUX_PKG_SRCDIR/bootstrap"
	"$TERMUX_PKG_SRCDIR/configure" \
		--host="$TERMUX_HOST_PLATFORM" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_post_make_install() {
	cp "$TERMUX_PKG_SRCDIR/monitrc" "$TERMUX_PREFIX/etc/monitrc"
	chmod 600 "$TERMUX_PREFIX/etc/monitrc"
	mkdir -pv "$TERMUX_PREFIX/"{etc/monit.d,var/lib/monit/events}
	touch "$TERMUX_PREFIX/"{etc/monit.d,var/lib/monit/events}/.keep
	chmod 700 "$TERMUX_PREFIX/"{etc/monit.d,/var/lib/monit,var/lib/monit/events}

	local service_dir="$TERMUX_PREFIX/var/service/monit"
	mkdir -p "$service_dir/log"

	cat << 'EOF' > "$service_dir/run"
#!/bin/sh
exec monit -I
EOF
	chmod +x "$service_dir/run"

	ln -sf "$TERMUX_PREFIX/share/termux-services/svlogger" "$service_dir/log/run"
	touch "$service_dir/down"
}
