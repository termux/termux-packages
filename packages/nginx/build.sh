TERMUX_PKG_HOMEPAGE=https://www.nginx.org
TERMUX_PKG_DESCRIPTION="Lightweight HTTP server"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_VERSION=1.15.10
TERMUX_PKG_SHA256=b865743abd52bce4745d0f7e7fedde3cafbaaab617b022c105e3e4e456537c3c
TERMUX_PKG_SRCURL=http://nginx.org/download/nginx-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libandroid-glob, libcrypt, pcre, openssl"
TERMUX_PKG_CONFFILES="etc/nginx/fastcgi.conf etc/nginx/fastcgi_params etc/nginx/koi-win etc/nginx/koi-utf
etc/nginx/mime.types etc/nginx/nginx.conf etc/nginx/scgi_params etc/nginx/uwsgi_params etc/nginx/win-utf"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"

termux_step_pre_configure() {
	CPPFLAGS="$CPPFLAGS -DIOV_MAX=1024"
	LDFLAGS="$LDFLAGS -landroid-glob"

	# remove config from previouse installs
	rm -rf "$TERMUX_PREFIX/etc/nginx"
}

termux_step_configure() {
	DEBUG_FLAG=""
	test -n "$TERMUX_DEBUG" && DEBUG_FLAG="--with-debug"

	./configure \
		--prefix=$TERMUX_PREFIX \
		--crossbuild="Linux:3.16.1:$TERMUX_ARCH" \
		--crossfile="$TERMUX_PKG_SRCDIR/auto/cross/Android" \
		--with-cc=$CC \
		--with-cpp=$CPP \
		--with-cc-opt="$CPPFLAGS $CFLAGS" \
		--with-ld-opt="$LDFLAGS" \
		--with-pcre \
		--with-pcre-jit \
		--with-threads \
		--with-ipv6 \
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
		--with-http_auth_request_module \
		--with-http_ssl_module \
		--with-http_v2_module \
		--with-http_gunzip_module \
		$DEBUG_FLAG
}

termux_step_post_make_install() {
	# many parts are taken directly from Arch PKGBUILD
	# https://git.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD?h=packages/nginx

	# set default port to 8080
	sed -i "s| 80;| 8080;|" "$TERMUX_PREFIX/etc/nginx/nginx.conf"
	cp conf/mime.types "$TERMUX_PREFIX/etc/nginx/"
	rm "$TERMUX_PREFIX"/etc/nginx/*.default

	# move default html dir
	sed -e "44s|html|$TERMUX_PREFIX/share/nginx/html|" \
		-e "54s|html|$TERMUX_PREFIX/share/nginx/html|" \
		-i "$TERMUX_PREFIX/etc/nginx/nginx.conf"
	rm -rf "$TERMUX_PREFIX/share/nginx"
	mkdir -p "$TERMUX_PREFIX/share/nginx"
	mv "$TERMUX_PREFIX/html/" "$TERMUX_PREFIX/share/nginx"

	# install vim contrib
	for i in ftdetect indent syntax; do
		install -Dm644 "$TERMUX_PKG_SRCDIR/contrib/vim/${i}/nginx.vim" \
			"$TERMUX_PREFIX/share/vim/vimfiles/${i}/nginx.vim"
	done

	# install man pages
	mkdir -p "$TERMUX_PREFIX/share/man/man8"
	cp "$TERMUX_PKG_SRCDIR/man/nginx.8" "$TERMUX_PREFIX/share/man/man8/"
}

termux_step_post_massage() {
	# keep empty dirs which were deleted in massage
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var/log/nginx"
	for dir in client-body proxy fastcgi scgi uwsgi; do
		mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var/lib/nginx/$dir"
	done
}

