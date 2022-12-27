TERMUX_PKG_HOMEPAGE=https://github.com/libass/libass
TERMUX_PKG_DESCRIPTION="A portable library for SSA/ASS subtitles rendering"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.17.0"
TERMUX_PKG_SRCURL=https://github.com/libass/libass/releases/download/$TERMUX_PKG_VERSION/libass-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=971e2e1db59d440f88516dcd1187108419a370e64863f70687da599fdf66cc1a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fontconfig, fribidi, glib, harfbuzz"
TERMUX_PKG_BREAKS="libass-dev"
TERMUX_PKG_REPLACES="libass-dev"
# Avoid text relocations.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_prog_nasm_check=no"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=9

	local a
	for a in LT_CURRENT LT_AGE; do
		local _${a}=$(sed -En 's/^LIBASS_'"${a}"'\s+=\s+([0-9]+).*/\1/p' \
				libass/Makefile_library.am)
	done
	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
