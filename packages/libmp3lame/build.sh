TERMUX_PKG_HOMEPAGE=https://lame.sourceforge.io/
TERMUX_PKG_DESCRIPTION="High quality MPEG Audio Layer III (MP3) encoder"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.100
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/lame/lame/${TERMUX_PKG_VERSION}/lame-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ddfe36cab873794038ae2c1210557ad34857a4b6bdc515785d1da9e175b1da1e
TERMUX_PKG_BREAKS="libmp3lame-dev"
TERMUX_PKG_REPLACES="libmp3lame-dev"

termux_step_pre_configure() {
	# Avoid build error: version script assignment of 'global' to symbol 'lame_init_old' failed: symbol not defined
	LDFLAGS+=" -Wl,-undefined-version"
}

termux_step_post_make_install() {
	local _pkgconfig_dir=$TERMUX_PREFIX/lib/pkgconfig
	mkdir -p ${_pkgconfig_dir}
	cat <<-EOF > ${_pkgconfig_dir}/lame.pc
		prefix=$TERMUX_PREFIX
		exec_prefix=\${prefix}
		libdir=\${exec_prefix}/lib
		includedir=\${prefix}/include

		Name: lame
		Description: MP3 encoding library
		Requires:
		Version: $TERMUX_PKG_VERSION
		Libs: -L\${libdir} -lmp3lame
		Cflags: -I\${includedir}
	EOF
}

termux_step_post_massage() {
	# Some programs, e.g. Audacity, try to dlopen(3) `libmp3lame.so.0`.
	cd ${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib || exit 1
	if [ ! -e "./libmp3lame.so.0" ]; then
		ln -sf libmp3lame.so libmp3lame.so.0
	fi
}
