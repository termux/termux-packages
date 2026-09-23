TERMUX_PKG_HOMEPAGE=https://calibre-ebook.com
TERMUX_PKG_DESCRIPTION="The one stop solution to all your e-book needs"
TERMUX_PKG_LICENSE="GPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.15.0"
TERMUX_PKG_SRCURL="https://download.calibre-ebook.com/${TERMUX_PKG_VERSION}/calibre-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9f02d36decaf46b176a1bef74349232508bcc2b4b06d1662bbd1fd426c57d559
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ffmpeg, fontconfig, freetype, hunspell, libhyphen, libicu, libmtp, libstemmer, libuchardet, libusb, libxml2, libxslt, openssl, podofo, pyqt6, python, python-apsw, python-brotli, python-lxml, python-msgpack, python-pillow, python-pip, python-psutil, python-pycryptodomex, python-pyppmd, python-pyqt6-webengine, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qtdeclarative-cross-tools, qt6-qttools-cross-tools"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, sip, PyQt-builder"
TERMUX_PKG_PYTHON_TARGET_DEPS="beautifulsoup4, chardet, css-parser, dnspython, feedparser, feedparser-sgmllib, fonttools, html2text, html5-parser, html5lib, jeepney, markdown, mechanize, netifaces, py7zr, pygments, pystache, python-dateutil, regex, soupsieve, texttable, tzdata, tzlocal, xxhash, zeroconf"
TERMUX_PKG_SETUP_PYTHON=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
	CXXFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -L$TERMUX_PREFIX/lib"
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		export QMAKE="$TERMUX_PREFIX/bin/qmake6"
	else
		export QMAKE="$TERMUX_PREFIX/lib/qt6/bin/host-qmake6"
	fi
}

termux_step_make() {
	export PODOFO_INC_DIR="$TERMUX_PREFIX/include/podofo"
	export PODOFO_LIB_DIR="$TERMUX_PREFIX/lib"
	export CALIBRE_CONFIG_DIRECTORY="$TERMUX_PKG_TMPDIR/calibre-config"
	python setup.py build
	python setup.py iso639
	python setup.py iso3166
}

termux_step_make_install() {
	python setup.py install \
		--prefix="$TERMUX_PREFIX" \
		--staging-root="$TERMUX_PREFIX" \
		--no-postinstall \
		--no-compile
}
