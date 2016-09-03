TERMUX_PKG_HOMEPAGE=http://www.ltrace.org/
TERMUX_PKG_DESCRIPTION="Tracks runtime library calls in dynamically linked programs"
TERMUX_PKG_VERSION=0.7.3.20160411
TERMUX_PKG_DEPENDS="elfutils"
_COMMIT=2def9f1217374cc8371105993003b2c663aefda7
TERMUX_PKG_SRCURL=https://github.com/dkogan/ltrace/archive/${_COMMIT}.zip
TERMUX_PKG_FOLDERNAME=ltrace-${_COMMIT}
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_host=$TERMUX_ARCH-generic-linux-gnu"

termux_step_pre_configure () {
	CFLAGS+=" -Wno-error=maybe-uninitialized"
	# rindex is obsolete name of strrchr which is not available in Android
	# function signature stays same, so I'm replacing it with C preprocessor
	# instead of patch
	CFLAGS+=" -Drindex=strrchr"

	autoreconf -i ../src
}
