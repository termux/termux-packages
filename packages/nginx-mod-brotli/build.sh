TERMUX_PKG_HOMEPAGE=https://github.com/google/ngx_brotli
TERMUX_PKG_DESCRIPTION="NGINX module for Brotli compression"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.0~rc"
TERMUX_PKG_SRCURL="https://github.com/google/ngx_brotli/archive/refs/tags/v${TERMUX_PKG_VERSION//\~/}.tar.gz"
TERMUX_PKG_SHA256=c85cdcfd76703c95aa4204ee4c2e619aa5b075cac18f428202f65552104add3b
# weird tag format
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="brotli, nginx"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/nginx/modules.d/20-brotli.conf"

# translation of Arch Linux PKGBUILD to Termux build.sh of this logic:
# https://gitlab.archlinux.org/archlinux/packaging/packages/nginx-mod-brotli/-/blob/ba3a39d69e1a35843ef99553d98f3d2c6c0113fb/PKGBUILD
# nginx source code is acquired, melded with the plugin source code, then
# patched and configured the same way it's built in the main nginx package,
# then make modules is used with the configured nginx to build the plugin

termux_step_configure() {
	sed "s@/usr@${TERMUX_PREFIX}@" -i filter/config

	(
		. "$TERMUX_SCRIPTDIR/packages/nginx/build.sh"
		TERMUX_PKG_BUILDER_DIR="$TERMUX_SCRIPTDIR/packages/nginx"
		termux_step_get_source
		termux_step_patch_package
		termux_step_pre_configure
	)

	local DEBUG_FLAG=""
	if [[ "$TERMUX_DEBUG_BUILD" == "true" ]]; then
		DEBUG_FLAG="--with-debug"
	fi

	# copied from nginx termux_step_configure, with the addition of --add-dynamic-module=.
	./configure \
		--prefix="$TERMUX_PREFIX" \
		--crossbuild="Linux:3.16.1:$TERMUX_ARCH" \
		--crossfile="$TERMUX_PKG_SRCDIR/auto/cross/Android" \
		--with-cc="$CC" \
		--with-cpp="$CPP" \
		--with-cc-opt="$CPPFLAGS $CFLAGS" \
		--with-ld-opt="$LDFLAGS" \
		--with-threads \
		--sbin-path="$TERMUX_PREFIX/bin/nginx" \
		--conf-path="$TERMUX_PREFIX/etc/nginx/nginx.conf" \
		--http-log-path="$TERMUX_PREFIX/var/log/nginx/access.log" \
		--pid-path="$TERMUX_PREFIX/tmp/nginx.pid" \
		--lock-path="$TERMUX_PREFIX/tmp/nginx.lock" \
		--error-log-path="$TERMUX_PREFIX/var/log/nginx/error.log" \
		--http-client-body-temp-path="$TERMUX_PREFIX/var/lib/nginx/client-body" \
		--http-proxy-temp-path="$TERMUX_PREFIX/var/lib/nginx/proxy" \
		--http-fastcgi-temp-path="$TERMUX_PREFIX/var/lib/nginx/fastcgi" \
		--http-scgi-temp-path="$TERMUX_PREFIX/var/lib/nginx/scgi" \
		--http-uwsgi-temp-path="$TERMUX_PREFIX/var/lib/nginx/uwsgi" \
		--add-dynamic-module=. \
		$DEBUG_FLAG
}

termux_step_make() {
	make modules -j "$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_make_install() {
	rm -f "$TERMUX_PREFIX/etc/nginx/modules.d/20-brotli.conf"
	install -dm755 "${TERMUX_PREFIX}/etc/nginx/modules.d"
	pushd objs
	local mod
	for mod in ngx_*.so; do
		install -Dm755 "$mod" "${TERMUX_PREFIX}/lib/nginx/modules/$mod"
		echo "load_module \"${TERMUX_PREFIX}/lib/nginx/modules/$mod\";" >> \
			"$TERMUX_PREFIX/etc/nginx/modules.d/20-brotli.conf"
	done
	popd
}
