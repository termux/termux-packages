TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/mint-themes
TERMUX_PKG_DESCRIPTION="Mint Mint-X, Mint-Y for cinnamon"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/linuxmint/mint-themes/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=13ea29bdbf9efd62b45e3704e9bc36a45258f4a9b6fabbd3a46bf0a543dfd6d6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_PYTHON_BUILD_DEPS="pysass"
TERMUX_PKG_BUILD_DEPENDS="python-libsass"
TERMUX_PKG_SUGGESTS="mint-x-icon-theme, mint-y-icon-theme"

termux_pkg_auto_update() {
	local latest_release
	latest_release="$(git ls-remote --tags "$TERMUX_PKG_HOMEPAGE.git" \
		| grep -oP "refs/tags/\K${TERMUX_PKG_UPDATE_VERSION_REGEXP}$" \
		| sort -V \
		| tail -n1)"

	if [[ "${latest_release}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	termux_pkg_upgrade_version "${latest_release}"
}

termux_step_pre_configure() {
	# allow use of GNU/Linux pysass (TERMUX_PKG_PYTHON_BUILD_DEPS="pysass") during cross-compilation
	# but bionic-libc pysass (TERMUX_PKG_BUILD_DEPENDS="python-sass") during on-device build
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export PYTHONPATH="${TERMUX_PYTHON_CROSSENV_PREFIX}/cross/lib/python${TERMUX_PYTHON_VERSION}/site-packages"
	fi
}

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR
	make -j$TERMUX_PKG_MAKE_PROCESSES
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/themes/
	cp -r $TERMUX_PKG_SRCDIR/usr/share/themes/* $TERMUX_PREFIX/share/themes/
}
