TERMUX_PKG_HOMEPAGE=https://gn.googlesource.com/gn
TERMUX_PKG_DESCRIPTION="Meta-build system that generates build files for Ninja"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <yakshbari4@gmail.com>"
# While updating commit hash here also update it in
# termux_setup_gn
_COMMIT=4aa9bdfa05b688c58d3d7d3e496f3f18cbb3d89e
TERMUX_PKG_VERSION=20211116
TERMUX_PKG_RECOMMENDS="ninja"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_get_source() {
	TERMUX_PKG_SRCURL=https://gn.googlesource.com/gn/+archive/$_COMMIT.tar.gz
	# Prevent caching of builds
	rm -rf $TERMUX_PKG_SRCDIR
	# FIXME: We would like to enable checksums when downloading
	# tar files, but they change each time as the tar metadata
	# differs: https://github.com/google/gitiles/issues/84
	GN_TARFILE=$TERMUX_PKG_CACHEDIR/gn_$_COMMIT.tar.gz
	test ! -f $GN_TARFILE && termux_download \
		$TERMUX_PKG_SRCURL \
		$GN_TARFILE \
		SKIP_CHECKSUM
	mkdir -p $TERMUX_PKG_SRCDIR
	tar xf $GN_TARFILE -C $TERMUX_PKG_SRCDIR
}

termux_step_configure() {
	./build/gen.py \
		--no-last-commit-position \
		--no-static-libstdc++

	cat <<- EOF > ./out/last_commit_position.h
	#ifndef OUT_LAST_COMMIT_POSITION_H_
	#define OUT_LAST_COMMIT_POSITION_H_
	#define LAST_COMMIT_POSITION_NUM 1945
	#define LAST_COMMIT_POSITION "1945 ${_COMMIT:0:8}"
	#endif  // OUT_LAST_COMMIT_POSITION_H_
	EOF
}

termux_step_make() {
	termux_setup_ninja
	ninja -C out/
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin out/gn
}
