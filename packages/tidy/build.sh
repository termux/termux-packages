TERMUX_PKG_HOMEPAGE=http://www.html-tidy.org/
TERMUX_PKG_DESCRIPTION="A tool to tidy down your HTML code to a clean style"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="README/LICENSE.md"
TERMUX_PKG_MAINTAINER="@termux"
# Using unstable API version due to CVE-2021-33391.
# Please revbump revdeps to rebuild when bumping version.
TERMUX_PKG_VERSION=5.9.14-next
TERMUX_PKG_SRCURL=https://github.com/htacg/tidy-html5/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=83cc9d9cdfa59bfe400dc745dea14eb1e1be4ca088facfb911eac8b78e75f2b4
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libxslt"
TERMUX_PKG_BREAKS="tidy-dev"
TERMUX_PKG_REPLACES="tidy-dev"
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=

	local _MAJOR=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1)
	local _MINOR=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 2)
	local v=
	if [ $(( _MINOR % 2 )) == 0 ]; then
		v="${_MAJOR}${_MINOR}"
	fi
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_host_build() {
	## Host build required to generate man pages.
	termux_setup_cmake
	cmake "$TERMUX_PKG_SRCDIR" && make
}

termux_step_post_make_install() {
	install -Dm600 \
		"$TERMUX_PKG_HOSTBUILD_DIR"/tidy.1 \
		"$TERMUX_PREFIX"/share/man/man1/
}
