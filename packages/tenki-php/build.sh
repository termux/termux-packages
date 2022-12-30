TERMUX_PKG_HOMEPAGE=https://github.com/dmpop/tenki
TERMUX_PKG_DESCRIPTION="A simple PHP application for logging current weather conditions, notes, and waypoints"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=cb07deb9d8c8fc5849f8752f6f0605f72f96fd9b
TERMUX_PKG_VERSION=2022.05.26
TERMUX_PKG_SRCURL=git+https://github.com/dmpop/tenki
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_DEPENDS="apache2, php"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
}

termux_step_make_install() {
	local _TENKI_ROOT=$TERMUX_PREFIX/share/tenki-php
	rm -rf ${_TENKI_ROOT}
	mkdir -p ${_TENKI_ROOT}
	cp -a $TERMUX_PKG_SRCDIR/* ${_TENKI_ROOT}/
	local _APACHE_CONF_DIR=$TERMUX_PREFIX/etc/apache2/conf.d
	mkdir -p ${_APACHE_CONF_DIR}
	sed -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		$TERMUX_PKG_BUILDER_DIR/tenki-php.conf \
		> ${_APACHE_CONF_DIR}/tenki-php.conf
}
