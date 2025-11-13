TERMUX_PKG_HOMEPAGE=http://site.icu-project.org/home
TERMUX_PKG_DESCRIPTION='International Components for Unicode library'
TERMUX_PKG_LICENSE="custom"
# We override TERMUX_PKG_SRCDIR termux_step_post_get_source so need to do
# this hack to be able to find the license file.
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
# Never forget to always bump revision of reverse dependencies and rebuild them
# when bumping "major" version.
TERMUX_PKG_VERSION="78.1"
TERMUX_PKG_SRCURL=https://github.com/unicode-org/icu/releases/download/release-${TERMUX_PKG_VERSION}/icu4c-${TERMUX_PKG_VERSION}-sources.tgz
TERMUX_PKG_SHA256=6217f58ca39b23127605cfc6c7e0d3475fe4b0d63157011383d716cb41617886
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="libicu-dev"
TERMUX_PKG_REPLACES="libicu-dev"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--disable-samples --disable-tests"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-samples --disable-tests --with-cross-build=$TERMUX_PKG_HOSTBUILD_DIR"

termux_step_post_get_source() {
	rm "$TERMUX_PKG_SRCDIR/LICENSE"
	curl -L "https://raw.githubusercontent.com/unicode-org/icu/release-${TERMUX_PKG_VERSION//./-}/LICENSE" -o "$TERMUX_PKG_SRCDIR/LICENSE"
	TERMUX_PKG_SRCDIR+="/source"
	find . -type f -print0 | xargs -0 touch
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libicuuc.so.78"
	if [[ ! -e "${_GUARD_FILE}" ]]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
