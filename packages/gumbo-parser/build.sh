TERMUX_PKG_HOMEPAGE=https://codeberg.org/gumbo-parser/gumbo-parser
TERMUX_PKG_DESCRIPTION="An HTML5 parsing library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Revbump revdeps after updating
TERMUX_PKG_VERSION=0.14.1
TERMUX_PKG_SRCURL=https://codeberg.org/gumbo-parser/gumbo-parser/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ba5d13b9b508ec693613b3b61518163aced38f8e885f7e28dc047348a4e61365
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=4

	local e=$(sed -En 's/^AC_SUBST\(gumbo_version_info,\s*\[([0-9]+):([0-9]+):([0-9]+)\]\).*/\1-\3/p' \
			configure.ac)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	./autogen.sh
}
