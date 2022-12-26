TERMUX_PKG_HOMEPAGE=https://libexpat.github.io/
TERMUX_PKG_DESCRIPTION="XML parsing C library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.0"
TERMUX_PKG_SRCURL=https://github.com/libexpat/libexpat/releases/download/R_${TERMUX_PKG_VERSION//./_}/expat-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=6f0e6e01f7b30025fa05c85fdad1e5d0ec7fd35d9f61b22f34998de11969ff67
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_BREAKS="libexpat-dev"
TERMUX_PKG_REPLACES="libexpat-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-xmlwf --without-docbook"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1

	local a
	for a in LIBCURRENT LIBAGE; do
		local _${a}=$(sed -En 's/^'"${a}"'=([0-9]+).*/\1/p' configure.ac)
	done
	local v=$(( _LIBCURRENT - _LIBAGE ))
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_post_make_install() {
	sed  -r 's/.[0-9]+(\.[0-9]+)*//' -i $TERMUX_PREFIX/lib/cmake/expat-$TERMUX_PKG_VERSION/expat-noconfig.cmake
}
