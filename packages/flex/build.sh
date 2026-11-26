TERMUX_PKG_HOMEPAGE=https://github.com/westes/flex
TERMUX_PKG_DESCRIPTION="Fast lexical analyser generator"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.7.10"
TERMUX_PKG_SRCURL="https://github.com/westes/flex/releases/download/v${TERMUX_PKG_VERSION}/flex-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d303c2956792acd8bf3601effef76cadc85a7876852cb66da411c0d5d2f868f4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="m4"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="ac_cv_path_M4=$TERMUX_PREFIX/bin/m4"
TERMUX_PKG_CONFLICTS="flex-dev"
TERMUX_PKG_REPLACES="flex-dev"
TERMUX_PKG_GROUPS="base-devel"

# Work around https://github.com/westes/flex/issues/241 when building
# under ubuntu 17.10:
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="CFLAGS=-D_GNU_SOURCE=1"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=2

	local e=$(sed -En 's/^SHARED_VERSION_INFO="?([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
			configure.ac)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	mkdir -p $TERMUX_PKG_BUILDDIR/src/
	cp $TERMUX_PKG_HOSTBUILD_DIR/src/stage1flex $TERMUX_PKG_BUILDDIR/src/stage1flex
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/src/stage1flex

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_MAKE_ARGS+=" m4=$(command -v m4)"
	fi
}
