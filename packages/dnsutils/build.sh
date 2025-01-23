TERMUX_PKG_HOMEPAGE=https://www.isc.org/downloads/bind/
TERMUX_PKG_DESCRIPTION="Clients provided with BIND"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.20.4
TERMUX_PKG_SRCURL="https://ftp.isc.org/isc/bind9/${TERMUX_PKG_VERSION}/bind-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=3a8e1a05e00e3e9bc02bdffded7862faf7726ba76ba997f42ab487777bd8210b
TERMUX_PKG_DEPENDS="openssl, readline, resolv-conf, zlib, libuv, liburcu, libcap, libandroid-glob, libnghttp2"
TERMUX_PKG_BREAKS="dnsutils-dev"
TERMUX_PKG_REPLACES="dnsutils-dev"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ax_cv_have_func_attribute_constructor=yes
ax_cv_have_func_attribute_destructor=yes
lt_cv_prog_compiler_pic_works=yes
--disable-static
"

termux_step_pre_configure() {
	_RESOLV_CONF=$TERMUX_PREFIX/etc/resolv.conf
	CFLAGS+=" $CPPFLAGS -DRESOLV_CONF=\\\"$_RESOLV_CONF\\\""
	LDFLAGS+=" -landroid-glob"
}

termux_step_post_configure() {
	# Android linker is unable to driectly reslove versoined libraries.
	# This will create a symlink to versoined library via `libname.so`.
	sed -i 's|library_names_spec=.*|library_names_spec="\\\$libname\\\$release\\\$shared_ext \\\$libname\\\$shared_ext"|g' ./libtool
}
