TERMUX_PKG_HOMEPAGE=http://simh.trailing-edge.com/
TERMUX_PKG_DESCRIPTION="A collection of simulators for computer hardware and software from the past"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
_VERSION=3.12-5
TERMUX_PKG_VERSION=1:${_VERSION/-/.}
TERMUX_PKG_SRCURL=http://simh.trailing-edge.com/sources/simhv${_VERSION/.}.zip
TERMUX_PKG_SHA256=561524723b5979c4ba6d1ed58fd33749c47ac2934eba55d98c48f558b71f3ee8
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="DONT_USE_ROMS=1 TESTS=0"

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/LICENSE ./
}

termux_step_pre_configure() {
	CFLAGS+=" -fcommon -fwrapv"
	LDFLAGS+=" -lm"
}

termux_step_make() {
	make -j $TERMUX_PKG_MAKE_PROCESSES \
		GCC="$CC" CFLAGS_O="$CFLAGS $CPPFLAGS" LDFLAGS="$LDFLAGS" \
		$TERMUX_PKG_EXTRA_MAKE_ARGS
}

termux_step_make_install() {
	shopt -s nullglob
	for f in BIN/*; do
		if [ -f "$f" ]; then
			local b="$(basename "$f")"
			install -Dm700 -T "$f" $TERMUX_PREFIX/bin/simh-"$b"
		fi
	done
	for f in */*.bin; do
		install -Dm600 -T "$f" $TERMUX_PREFIX/share/simh/"$f"
	done
	shopt -u nullglob
}
