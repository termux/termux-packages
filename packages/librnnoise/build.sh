TERMUX_PKG_HOMEPAGE=https://jmvalin.ca/demo/rnnoise/
TERMUX_PKG_DESCRIPTION="RNN-based noise suppression"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.xiph.org/xiph/rnnoise/-/archive/v$TERMUX_PKG_VERSION/rnnoise-v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fafc947fdd24109a6e72b5f25e4224b54bc74660a2620af5548def85be8c733a
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-examples
--disable-doc
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local a
	for a in CURRENT AGE; do
		local _LT_${a}=$(sed -En 's/^OP_LT_'"${a}"'=([0-9]+).*/\1/p' \
				configure.ac)
	done
	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ ! "${_LT_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed. Expected: $v, got: $_SOVERSION"
	fi

	bash download_model.sh
}

termux_step_pre_configure() {
	autoreconf -fi
}
