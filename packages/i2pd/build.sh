TERMUX_PKG_HOMEPAGE=https://i2pd.website/
TERMUX_PKG_DESCRIPTION="A full-featured C++ implementation of the I2P router"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.44.0"
TERMUX_PKG_SRCURL=https://github.com/PurpleI2P/i2pd/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b653c845ac7a16fefab2ace78e3ae496c12b05304bb66e41e776071635d4e070
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, libc++, miniupnpc, openssl, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_UPNP:BOOL=ON"
TERMUX_PKG_RM_AFTER_INSTALL="src"

TERMUX_PKG_CONFFILES="
etc/i2pd/i2pd.conf
etc/i2pd/tunnels.conf
"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/build"
	CXXFLAGS="${CXXFLAGS/-Oz/-O2}"
}

termux_step_post_make_install() {
	cd $TERMUX_PKG_SRCDIR/../

	install -Dm600 -t "$TERMUX_PREFIX"/etc/i2pd \
		./contrib/i2pd.conf \
		./contrib/tunnels.conf

	local _file _dir
	while read -r -d '' _file; do
		_dir="${_file#contrib/certificates}"
		_dir="${_dir%/*}"
		install -Dm600 "$_file" -t "${TERMUX_PREFIX}/share/i2pd/certificates/${_dir}"
	done < <(find contrib/certificates -type f -print0)

	install -Dm600 -t "${TERMUX_PREFIX}"/share/doc/i2pd/tunnels.d \
		./contrib/tunnels.d/README \
		./contrib/tunnels.d/IRC-Ilita.conf \
		./contrib/tunnels.d/IRC-Irc2P.conf

	install -Dm600 -t "${TERMUX_PREFIX}"/share/man/man1 ./debian/i2pd.1
}
