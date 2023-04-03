TERMUX_PKG_HOMEPAGE=http://stedolan.github.io/jq/
TERMUX_PKG_DESCRIPTION="Command-line JSON processor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/stedolan/jq/releases/download/jq-$TERMUX_PKG_VERSION/jq-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5de8c8e29aaa3fb9cc6b47bb27299f271354ebb72514e3accadc7d38b5bbaa72
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+"
TERMUX_PKG_DEPENDS="oniguruma"
TERMUX_PKG_BREAKS="jq-dev"
TERMUX_PKG_REPLACES="jq-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-oniguruma"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1

	local e=$(sed -En 's/^libjq_la_LDFLAGS\s*=.*\s+-version-info\s+([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
			Makefile.am)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
