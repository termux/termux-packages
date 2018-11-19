TERMUX_PKG_HOMEPAGE=https://golang.org/
TERMUX_PKG_DESCRIPTION="Go programming language compiler"
local _MAJOR_VERSION=1.11.2
TERMUX_PKG_SHA256=042fba357210816160341f1002440550e952eb12678f7c9e7e9d389437942550
# Use the ~ deb versioning construct in the future:
TERMUX_PKG_VERSION=2:${_MAJOR_VERSION}
TERMUX_PKG_SRCURL=https://storage.googleapis.com/golang/go${_MAJOR_VERSION}.src.tar.gz
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true
TERMUX_PKG_DEPENDS="clang"

termux_step_make_install () {
	termux_setup_golang

	TERMUX_GOLANG_DIRNAME=${GOOS}_$GOARCH
	TERMUX_GODIR=$TERMUX_PREFIX/lib/go
	rm -Rf $TERMUX_GODIR
	mkdir -p $TERMUX_GODIR/{src,doc,lib,pkg/tool/$TERMUX_GOLANG_DIRNAME,pkg/include,pkg/${TERMUX_GOLANG_DIRNAME}}

	cd $TERMUX_PKG_SRCDIR/src
	env CC_FOR_TARGET=$CC \
	    CXX_FOR_TARGET=$CXX \
	    CC=gcc \
	    GO_LDFLAGS="-extldflags=-pie" \
	    GOROOT_BOOTSTRAP=$GOROOT \
	    GOROOT_FINAL=$TERMUX_GODIR \
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

termux_step_post_massage () {
	find . -path '*/testdata*' -delete
}
