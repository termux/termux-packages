TERMUX_PKG_HOMEPAGE=https://tox.chat
TERMUX_PKG_DESCRIPTION="Backend library for the Tox protocol"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Match commit SHA with toxic/blob/master/script/build-minimal-static-toxic.sh
# (for example, toxic 0.16.2 has the commit of c-toxcore version 0.2.22 in it)
# https://github.com/JFreegman/toxic/blob/07dba324aa06916c6c96ed5104240d304a662050/script/build-minimal-static-toxic.sh#L146
TERMUX_PKG_VERSION="0.2.22"
TERMUX_PKG_SRCURL="https://github.com/TokTok/c-toxcore/releases/download/v$TERMUX_PKG_VERSION/c-toxcore-v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=276d447eb94e9d76e802cecc5ca7660c6c15128a83dfbe4353b678972aeb950a
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_DEPENDS="libsodium, libopus, libvpx"
TERMUX_PKG_BREAKS="c-toxcore-dev"
TERMUX_PKG_REPLACES="c-toxcore-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
-DBOOTSTRAP_DAEMON=off
-DDHT_BOOTSTRAP=off
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=2

	local a
	for a in CURRENT AGE; do
		local _LT_${a}=$(sed -En 's/^'"${a}"'=([0-9]+).*/\1/p' \
				so.version)
	done
	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ ! "${_LT_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
