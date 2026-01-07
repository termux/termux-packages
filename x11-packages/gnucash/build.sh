TERMUX_PKG_HOMEPAGE="https://gnucash.org"
TERMUX_PKG_DESCRIPTION="Personal and small-business financial-accounting software"
TERMUX_PKG_LICENSE="GPL-2.0-or-later" # with OpenSSL linking exceptions
TERMUX_PKG_LICENSE_FILE="LICENSE"     # specified for additional nuance.
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.14"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/Gnucash/gnucash/releases/download/${TERMUX_PKG_VERSION}/gnucash-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=0c6fd20214da86a9a0443359f7b62d9a2bd4ed802fd680853da4b757a371ac91
TERMUX_PKG_DEPENDS="boost, gettext, guile, glib, gtk3, libicu, libsecret, libxml2, libxslt, perl, python, swig, webkit2gtk-4.1, xsltproc, zlib"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs, boost-headers, googletest"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_PYTHON=ON
-DWITH_SQL=OFF
-DWITH_OFX=OFF
-DWITH_AQBANKING=OFF
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	# gnc-autoclear.c:151:22: error: format string is not a string literal (potentially insecure)
	CFLAGS+=" -Wno-format-security"

	# ERROR: ./lib/libgnc-expressions.so contains undefined symbols log, pow, exp...
	LDFLAGS+=" -lm"

	# CANNOT LINK EXECUTABLE "gnucash": library "libgnc-qif-import.so" not found: needed by main executable
	LDFLAGS+=" -Wl,-rpath=$TERMUX__PREFIX__LIB_DIR/$TERMUX_PKG_NAME"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	termux_setup_proot

	export LD_LIBRARY_PATH="$TERMUX_PKG_BUILDDIR/lib:$TERMUX_PKG_BUILDDIR/lib/$TERMUX_PKG_NAME"
	mkdir -p "$TERMUX_PKG_TMPDIR/bin"
	for tool in python guile; do
		# proot will append its own LD_LIBRARY_PATH which is incompatible with bionic
		cat > "$TERMUX_PKG_TMPDIR/bin/$tool" <<-HERE
			#!$(command -v bash)
			LD_LIBRARY_PATH=$LD_LIBRARY_PATH
			exec $(command -v termux-proot-run) env LD_PRELOAD= LD_LIBRARY_PATH=\$LD_LIBRARY_PATH GUILE_LOAD_PATH=\$GUILE_LOAD_PATH GUILE_LOAD_COMPILED_PATH=\$GUILE_LOAD_COMPILED_PATH $TERMUX_PREFIX/bin/$tool "\$@"
		HERE
	done
	chmod +x "$TERMUX_PKG_TMPDIR/bin"/*
	ln -sf "$TERMUX_PREFIX/bin/guild" "$TERMUX_PKG_TMPDIR/bin/guild"
	PATH="$TERMUX_PKG_TMPDIR/bin:$PATH"
}
