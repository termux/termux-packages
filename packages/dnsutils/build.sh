TERMUX_PKG_HOMEPAGE=https://www.isc.org/bind/
TERMUX_PKG_DESCRIPTION="Clients provided with BIND"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.20.5"
TERMUX_PKG_SRCURL="https://downloads.isc.org/isc/bind9/${TERMUX_PKG_VERSION}/bind-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=19274fd739c023772b4212a0b6c201cf4364855fa7e6a7d3db49693f55db1ab8
TERMUX_PKG_DEPENDS="json-c, libandroid-glob, libcap, libnghttp2, liburcu, libuv, libxml2, openssl, readline, resolv-conf, zlib"
TERMUX_PKG_BREAKS="dnsutils-dev"
TERMUX_PKG_REPLACES="dnsutils-dev"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ax_cv_have_func_attribute_constructor=yes
ax_cv_have_func_attribute_destructor=yes
lt_cv_prog_compiler_pic_works=yes
--disable-static
--with-json-c
--with-libxml2
"

termux_step_pre_configure() {
	_RESOLV_CONF=$TERMUX_PREFIX/etc/resolv.conf
	CFLAGS+=" $CPPFLAGS -DRESOLV_CONF=\\\"$_RESOLV_CONF\\\""
	LDFLAGS+=" -landroid-glob"
}

termux_step_post_configure() {
	# Android linker is unable to directly resolve versioned libraries.
	# This will create a symlink to versioned library via `libname.so`.
	sed -i 's|library_names_spec=.*|library_names_spec="\\\$libname\\\$release\\\$shared_ext \\\$libname\\\$shared_ext"|g' ./libtool
}
