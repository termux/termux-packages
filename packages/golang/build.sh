TERMUX_PKG_HOMEPAGE=https://golang.org/
TERMUX_PKG_DESCRIPTION="Go programming language compiler"
TERMUX_PKG_LICENSE="BSD 3-Clause"
local _MAJOR_VERSION=1.12.7
TERMUX_PKG_SHA256=95e8447d6f04b8d6a62de1726defbb20ab203208ee167ed15f83d7978ce43b13
# Use the ~ deb versioning construct in the future:
TERMUX_PKG_VERSION=2:${_MAJOR_VERSION}
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://storage.googleapis.com/golang/go${_MAJOR_VERSION}.src.tar.gz
TERMUX_PKG_DEPENDS="clang"
TERMUX_PKG_NO_STATICSPLIT=yes

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if [ -n "$TERMUX_ON_DEVICE_BUILD" ]; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_make_install() {
	termux_setup_golang

	TERMUX_GOLANG_DIRNAME=${GOOS}_$GOARCH
	TERMUX_GODIR=$TERMUX_PREFIX/lib/go
	rm -Rf $TERMUX_GODIR
	mkdir -p $TERMUX_GODIR/{src,doc,lib,pkg/tool/$TERMUX_GOLANG_DIRNAME,pkg/include,pkg/${TERMUX_GOLANG_DIRNAME}}

	cd $TERMUX_PKG_SRCDIR/src
	# Unset PKG_CONFIG to avoid the path being hardcoded into src/cmd/cgo/zdefaultcc.go,
	# see https://github.com/termux/termux-packages/issues/3505.
	env CC_FOR_TARGET=$CC \
	    CXX_FOR_TARGET=$CXX \
	    CC=gcc \
	    GO_LDFLAGS="-extldflags=-pie" \
	    GOROOT_BOOTSTRAP=$GOROOT \
	    GOROOT_FINAL=$TERMUX_GODIR \
	    PKG_CONFIG= \
	    ./make.bash

	cd ..
	cp bin/$TERMUX_GOLANG_DIRNAME/{go,gofmt} $TERMUX_PREFIX/bin
	cp VERSION $TERMUX_GODIR/
	cp pkg/tool/$TERMUX_GOLANG_DIRNAME/* $TERMUX_GODIR/pkg/tool/$TERMUX_GOLANG_DIRNAME/
	cp -Rf src/* $TERMUX_GODIR/src/
	cp -Rf doc/* $TERMUX_GODIR/doc/
	cp pkg/include/* $TERMUX_GODIR/pkg/include/
	cp -Rf lib/* $TERMUX_GODIR/lib
	cp -Rf pkg/${TERMUX_GOLANG_DIRNAME}/* $TERMUX_GODIR/pkg/${TERMUX_GOLANG_DIRNAME}/
}

termux_step_post_massage() {
	find . -path '*/testdata*' -delete
}
