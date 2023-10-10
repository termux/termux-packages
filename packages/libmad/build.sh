TERMUX_PKG_HOMEPAGE=http://www.underbit.com/products/mad/
TERMUX_PKG_DESCRIPTION="MAD is a high-quality MPEG audio decoder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.4"
TERMUX_PKG_SRCURL=https://codeberg.org/tenacityteam/libmad/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f4eb229452252600ce48f3c2704c9e6d97b789f81e31c37b0c67dd66f445ea35
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libmad-dev"
TERMUX_PKG_REPLACES="libmad-dev"

termux_post_configure() {
	cd $TERMUX_PKG_SRCDIR
	sed -i -e 's/-force-mem//g' Makefile
}

termux_step_post_make_install() {
	local _pkgconfig_dir=$TERMUX_PREFIX/lib/pkgconfig
	mkdir -p ${_pkgconfig_dir}
	cat > ${_pkgconfig_dir}/mad.pc <<-EOF
		prefix=$TERMUX_PREFIX
		exec_prefix=\${prefix}
		libdir=$TERMUX_PREFIX/lib
		includedir=\${prefix}/include

		Name: mad
		Description: MPEG Audio Decoder
		Requires:
		Version: $TERMUX_PKG_VERSION
		Libs: -L\${libdir} -lmad
		Cflags: -I\${includedir}
	EOF
}
