TERMUX_PKG_HOMEPAGE=http://www.gnumeric.org/
TERMUX_PKG_DESCRIPTION="The GNOME spreadsheet"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.12
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.54
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gnumeric/${_MAJOR_VERSION}/gnumeric-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=46904062fd1c4a4c93596d26bf67932cd72fc0f8d2c5a67c17918527fee82b74
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, goffice, gtk3, harfbuzz, libcairo, libgsf, libxml2, pango, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_RECOMMENDS="gnumeric-help"
TERMUX_PKG_SUGGESTS="glpk"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
PYTHON=python
--enable-introspection=yes
--without-gda
--without-psiconv
--without-paradox
--without-long-double
--without-perl
"
TERMUX_PKG_RM_AFTER_INSTALL="
lib/locale
share/glib-2.0/schemas/gschemas.compiled
"

termux_step_pre_configure() {
	termux_setup_gir

	echo "Applying plugins-python-loader-Makefile.in.diff"
	sed "s|@PYTHON_VERSION@|${TERMUX_PYTHON_VERSION}|g" \
		$TERMUX_PKG_BUILDER_DIR/plugins-python-loader-Makefile.in.diff \
		| patch --silent -p1

	export PYTHON_GIOVERRIDESDIR=$TERMUX_PYTHON_HOME/site-packages/gi/overrides
	export PYTHON_CONFIG=$TERMUX_PREFIX/bin/python-config

	CPPFLAGS+=" -D__USE_GNU"
}

termux_step_post_configure() {
	touch ./src/g-ir-scanner

	local ver=$(awk '/^PACKAGE_VERSION =/ { print $3 }' Makefile)
	local so=$TERMUX_PREFIX/lib/libspreadsheet.so
	rm -f ${so}
	echo "INPUT(-lspreadsheet-${ver})" > ${so}

	# Workaround for https://github.com/android/ndk/issues/201
	local plugins_libs="-L$TERMUX_PKG_BUILDDIR/src/.libs -lspreadsheet"
	plugins_libs+=" $($PKG_CONFIG libgoffice-0.10 --libs)"
	plugins_libs+=" $($PKG_CONFIG libgsf-1 --libs)"
	plugins_libs+=" $($PKG_CONFIG gtk+-3.0 --libs)"
	find plugins -name Makefile | xargs -n 1 \
		sed -i 's|^LIBS = |\0'"${plugins_libs}"' |g'
}
