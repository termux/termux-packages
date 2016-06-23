TERMUX_PKG_HOMEPAGE=https://golang.org/
TERMUX_PKG_DESCRIPTION="Go programming language compiler"
_MAJOR_VERSION=1.7
# Use the ~ deb versioning construct in the future:
TERMUX_PKG_VERSION=2:${_MAJOR_VERSION}~beta2
TERMUX_PKG_SRCURL=https://storage.googleapis.com/golang/go${_MAJOR_VERSION}beta2.src.tar.gz
TERMUX_PKG_FOLDERNAME=go
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true

termux_step_make_install () {
	termux_setup_golang

	TERMUX_GOLANG_DIRNAME=${GOOS}_$GOARCH
	TERMUX_GODIR=$TERMUX_PREFIX/lib/go
	rm -Rf $TERMUX_GODIR
	mkdir -p $TERMUX_GODIR/{src,pkg/tool/$TERMUX_GOLANG_DIRNAME,pkg/include,pkg/${TERMUX_GOLANG_DIRNAME}_shared}

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
	cp pkg/include/* $TERMUX_GODIR/pkg/include/
	cp -Rf pkg/${TERMUX_GOLANG_DIRNAME}_shared/* $TERMUX_GODIR/pkg/${TERMUX_GOLANG_DIRNAME}_shared/
}

termux_step_post_massage () {
	find . -path '*/testdata*' -delete
}
