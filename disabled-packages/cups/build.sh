TERMUX_PKG_HOMEPAGE=https://www.cups.org
TERMUX_PKG_VERSION=2.2.4
TERMUX_PKG_DEPENDS=krb5
TERMUX_PKG_SRCURL=https://github.com/apple/cups/releases/download/v$TERMUX_PKG_VERSION/cups-$TERMUX_PKG_VERSION-source.tar.gz
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_SHA256=596d4db72651c335469ae5f37b0da72ac9f97d73e30838d787065f559dea98cc
TERMUX_PKG_DEPENDS="libandroid-support, libcrypt"
TERMUX_PKG_FOLDERNAME=cups-$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-option-checking
--disable-gssapi
--with-components=core
"

termux_step_pre_configure() {
	LDFLAGS="$LDFLAGS -llog -lcrypt"
}

termux_step_post_make_install() {
	mv "$TERMUX_PREFIX"/lib64/libcups.so* "$TERMUX_PREFIX"/lib/
}
