TERMUX_PKG_HOMEPAGE=https://fmt.dev/latest/index.html
TERMUX_PKG_DESCRIPTION="Open-source formatting library for C++"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:11.0.2
TERMUX_PKG_SRCURL=https://github.com/fmtlib/fmt/archive/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=6cb1e6d37bdcb756dbbe59be438790db409cdb4868c66e888d5df9f13f7c027f
# Avoid silently breaking build of revdeps:
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DFMT_TEST=OFF -DBUILD_SHARED_LIBS=TRUE"
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SONAME is changed.
	local _EXPECTED_SOVERSION=11
	local _FMT_VERSION=$(grep '#define FMT_VERSION' $TERMUX_PKG_SRCDIR/include/fmt/base.h  | cut -d ' ' -f 3)
	# The fmt library version in the form major * 10000 + minor * 100 + patch:
	local _ACTUAL_SOVERSION=$(( _FMT_VERSION / 10000 ))
	if [ "$_EXPECTED_SOVERSION" != "$_ACTUAL_SOVERSION" ]; then
		termux_error_exit "SONAME changed: expected=$_EXPECTED_SOVERSION, actual=$_ACTUAL_SOVERSION"
	fi
}
