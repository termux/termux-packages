TERMUX_PKG_HOMEPAGE=https://stedolan.github.io/jq/
TERMUX_PKG_DESCRIPTION="Command-line JSON processor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.1"
TERMUX_PKG_SRCURL=https://github.com/stedolan/jq/releases/download/jq-$TERMUX_PKG_VERSION/jq-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2be64e7129cecb11d5906290eba10af694fb9e3e7f9fc208a311dc33ca837eb0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+(\.\d+)?"
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
