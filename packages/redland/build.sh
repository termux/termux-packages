TERMUX_PKG_HOMEPAGE=http://librdf.org/
TERMUX_PKG_DESCRIPTION="Library that provides a high-level interface to RDF data"
TERMUX_PKG_LICENSE="LGPL-2.1, Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.17
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://download.librdf.org/source/redland-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=de1847f7b59021c16bdc72abb4d8e2d9187cd6124d69156f3326dd34ee043681
TERMUX_PKG_DEPENDS="libltdl, libraptor2, librasqal, mariadb, postgresql, sqlite, unixodbc"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-release
--disable-static
--with-raptor=system
--with-rasqal=system
--with-sqlite=3
--with-bdb=no
"

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="
lib/librdf.so.0
lib/librdf.so.0.0.0
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
