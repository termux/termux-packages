TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libidn/
TERMUX_PKG_DESCRIPTION="GNU Libidn library, implementation of IETF IDN specifications"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-3.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.44"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libidn/libidn-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=499608bab3a65650a0ea52888c13a8deebe3f71408e319acd9ec52e02eb13959
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_BREAKS="libidn-dev"
TERMUX_PKG_REPLACES="libidn-dev"

# Remove the idn tool for now, add it as subpackage if desired::
TERMUX_PKG_RM_AFTER_INSTALL="bin/idn share/man/man1/idn.1 share/emacs"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-ld-version-script"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=12

	local a
	for a in LT_CURRENT LT_AGE; do
		local _${a}=$(sed -En 's/^AC_SUBST\('"${a}"',\s*([0-9]+).*/\1/p' \
				configure.ac)
	done
	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ ! "${_LT_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
