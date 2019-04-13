TERMUX_PKG_HOMEPAGE=https://httpd.apache.org
TERMUX_PKG_DESCRIPTION="Apache Web Server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=2.4.39
TERMUX_PKG_SHA256=b4ca9d05773aa59b54d66cd8f4744b945289f084d3be17d7981d1783a5decfa2
TERMUX_PKG_SRCURL=https://www.apache.org/dist/httpd/httpd-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_DEPENDS="apr, apr-util, pcre, openssl, libcrypt, libandroid-support, libnghttp2, libexpat, libuuid"
TERMUX_PKG_CONFFILES="
etc/apache2/httpd.conf
etc/apache2/extra/httpd-autoindex.conf
etc/apache2/extra/httpd-dav.conf
etc/apache2/extra/httpd-default.conf
etc/apache2/extra/httpd-info.conf
etc/apache2/extra/httpd-languages.conf
etc/apache2/extra/httpd-manual.conf
etc/apache2/extra/httpd-mpm.conf
etc/apache2/extra/httpd-multilang-errordoc.conf
etc/apache2/extra/httpd-ssl.conf
etc/apache2/extra/httpd-userdir.conf
etc/apache2/extra/httpd-vhosts.conf
etc/apache2/extra/proxy-html.conf
etc/apache2/mime.types
etc/apache2/magic
"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
# providing manual paths to libs because it picks up host libs on some systems
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-apr=$TERMUX_PREFIX
--with-apr-util=$TERMUX_PREFIX
--with-pcre=$TERMUX_PREFIX
--enable-suexec
--enable-layout=Termux
--enable-so
--enable-authnz-fcgi
--enable-cache
--enable-disk-cache
--enable-mem-cache
--enable-file-cache
--enable-ssl
--with-ssl
--enable-deflate
--enable-cgi
--enable-cgid
--enable-proxy
--enable-proxy-connect
--enable-proxy-http
--enable-proxy-ftp
--enable-dbd
--enable-imagemap
--enable-ident
--enable-cern-meta
--enable-http2
--enable-mpms-shared=all
--enable-modules=all
--enable-mods-shared=all
--disable-brotli
--disable-lua
--disable-mods-static
--disable-md
--with-port=8080
--with-sslport=8443
--enable-unixd
--without-libxml2
--libexecdir=$TERMUX_PREFIX/libexec/apache2
ac_cv_func_getpwnam=yes
ac_cv_have_threadsafe_pollset=no
"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="share/apache2/manual etc/apache2/original share/man/man8/suexec.8 libexec/httpd.exp"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="share/apache2/build"
TERMUX_PKG_EXTRA_MAKE_ARGS="-s"

termux_step_pre_configure() {
	# remove old files
	rm -rf "$TERMUX_PREFIX"/{libexec,share,etc}/apache2
	rm -rf "$TERMUX_PREFIX"/lib/cgi-bin

	if [ $TERMUX_ARCH_BITS -eq 32 ]; then
		export ap_cv_void_ptr_lt_long=4
	else
		export ap_cv_void_ptr_lt_long=8
	fi

	LDFLAGS="$LDFLAGS -llog -lapr-1 -laprutil-1"

	# use custom layout
	cat $TERMUX_PKG_BUILDER_DIR/Termux.layout > $TERMUX_PKG_SRCDIR/config.layout
}

termux_step_post_configure() {
	# thanks to @JetBalsa
	gcc -O2 -DCROSS_COMPILE $TERMUX_PKG_SRCDIR/server/gen_test_char.c -o $TERMUX_PKG_BUILDDIR/server/gen_test_char
	touch -d "1 hour" $TERMUX_PKG_BUILDDIR/server/gen_test_char
}

termux_step_post_make_install() {
	sed -e "s#/$TERMUX_PREFIX/libexec/apache2/#modules/#" \
		-e 's|#\(LoadModule negotiation_module \)|\1|' \
		-e 's|#\(LoadModule include_module \)|\1|' \
		-e 's|#\(LoadModule userdir_module \)|\1|' \
		-e 's|#\(LoadModule slotmem_shm_module \)|\1|' \
		-e 's|#\(Include extra/httpd-multilang-errordoc.conf\)|\1|' \
		-e 's|#\(Include extra/httpd-autoindex.conf\)|\1|' \
		-e 's|#\(Include extra/httpd-languages.conf\)|\1|' \
		-e 's|#\(Include extra/httpd-userdir.conf\)|\1|' \
		-e 's|#\(Include extra/httpd-default.conf\)|\1|' \
		-e 's|#\(Include extra/httpd-mpm.conf\)|\1|' \
		-e 's|User daemon|#User daemon|' \
		-e 's|Group daemon|#Group daemon|' \
		-i "$TERMUX_PREFIX/etc/apache2/httpd.conf"
}

termux_step_post_massage() {
	# sometimes it creates a $TERMUX_PREFIX/bin/sh -> /bin/sh
	rm ${TERMUX_PKG_MASSAGEDIR}${TERMUX_PREFIX}/bin/sh || true

	mkdir -p ${TERMUX_PKG_MASSAGEDIR}${TERMUX_PREFIX}/var/run/apache2
	mkdir -p ${TERMUX_PKG_MASSAGEDIR}${TERMUX_PREFIX}/var/log/apache2
}
