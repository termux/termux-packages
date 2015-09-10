TERMUX_PKG_HOMEPAGE=https://golang.org/
TERMUX_PKG_DESCRIPTION="Go programming language compiler"
_MAJOR_VERSION=1.5.1
# Need to be considered a higher version than "1.5rc1":
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.rel
TERMUX_PKG_SRCURL=https://storage.googleapis.com/golang/go${_MAJOR_VERSION}.src.tar.gz
TERMUX_PKG_FOLDERNAME=go
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true

TERMUX_HOST_GOLANG_DIR=$TERMUX_PKG_CACHEDIR/go-host-$TERMUX_PKG_VERSION

termux_step_post_extract_package () {
	if [ ! -d $TERMUX_HOST_GOLANG_DIR ]; then
		cd $TERMUX_PKG_CACHEDIR
		curl -o go-host.tar.gz https://storage.googleapis.com/golang/go${_MAJOR_VERSION}.linux-amd64.tar.gz
		tar xf go-host.tar.gz
		mv go $TERMUX_HOST_GOLANG_DIR
	fi
}

termux_step_make_install () {
	if [ "$TERMUX_ARCH" = "arm" ]; then
		export GOOS=android
	    	export CGO_ENABLED=1
		export GOARCH=arm
		export GOARM=7
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		export GOOS=linux
	    	export CGO_ENABLED=0
		export GOARCH=386
		export GO386=sse2
	else
		echo "ERROR: Unsupported arch: $TERMUX_ARCH"
		exit 1
	fi

	TERMUX_GOLANG_DIRNAME=${GOOS}_$GOARCH

	TERMUX_GODIR=$TERMUX_PREFIX/lib/go
	rm -Rf $TERMUX_GODIR
	mkdir -p $TERMUX_GODIR/{src,pkg/tool/$TERMUX_GOLANG_DIRNAME,pkg/include,pkg/$TERMUX_GOLANG_DIRNAME}

	cd $TERMUX_PKG_SRCDIR/src
	env CC_FOR_TARGET=$CC \
	    CXX_FOR_TARGET=$CXX \
	    CC=gcc \
	    GO_LDFLAGS="-extldflags=-pie" \
	    GOROOT_BOOTSTRAP=$TERMUX_HOST_GOLANG_DIR \
            GOROOT_FINAL=$TERMUX_GODIR \
	    ./make.bash

	cd ..
	cp bin/$TERMUX_GOLANG_DIRNAME/{go,gofmt} $TERMUX_PREFIX/bin
	cp VERSION $TERMUX_GODIR/
	cp pkg/tool/$TERMUX_GOLANG_DIRNAME/* $TERMUX_GODIR/pkg/tool/$TERMUX_GOLANG_DIRNAME/
	cp -Rf src/* $TERMUX_GODIR/src/
	cp pkg/include/* $TERMUX_GODIR/pkg/include/
	cp -Rf pkg/$TERMUX_GOLANG_DIRNAME/* $TERMUX_GODIR/pkg/$TERMUX_GOLANG_DIRNAME/
}

termux_step_post_massage () {
	find . -path '*/testdata*' -delete
}
