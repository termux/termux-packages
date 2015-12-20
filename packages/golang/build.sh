TERMUX_PKG_HOMEPAGE=https://golang.org/
TERMUX_PKG_DESCRIPTION="Go programming language compiler"
_MAJOR_VERSION=1.6beta1
# Need to be considered a higher version than "1.5rc1":
TERMUX_PKG_VERSION=1:$_MAJOR_VERSION
TERMUX_PKG_SRCURL=https://storage.googleapis.com/golang/go${_MAJOR_VERSION}.src.tar.gz
TERMUX_PKG_FOLDERNAME=go
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true

termux_step_make_install () {
	export GOOS=android
	export CGO_ENABLED=1
	if [ "$TERMUX_ARCH" = "arm" ]; then
		export GOARCH=arm
		export GOARM=7
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		export GOARCH=386
		export GO386=sse2
	else
		echo "ERROR: Unsupported arch: $TERMUX_ARCH"
		exit 1
	fi

	TERMUX_GOLANG_DIRNAME=${GOOS}_$GOARCH

	TERMUX_GODIR=$TERMUX_PREFIX/lib/go
	rm -Rf $TERMUX_GODIR
	mkdir -p $TERMUX_GODIR/{src,pkg/tool/$TERMUX_GOLANG_DIRNAME,pkg/include,pkg/${TERMUX_GOLANG_DIRNAME}_shared}

	termux_setup_golang

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
