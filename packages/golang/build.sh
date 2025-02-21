TERMUX_PKG_HOMEPAGE=https://golang.org/
TERMUX_PKG_DESCRIPTION="Go programming language compiler"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3:1.24.0
TERMUX_PKG_SRCURL=https://storage.googleapis.com/golang/go${TERMUX_PKG_VERSION#*:}.src.tar.gz
TERMUX_PKG_SHA256=d14120614acb29d12bcab72bd689f257eb4be9e0b6f88a8fb7e41ac65f8556e5
TERMUX_PKG_DEPENDS="clang"
TERMUX_PKG_ANTI_BUILD_DEPENDS="clang"
TERMUX_PKG_RECOMMENDS="resolv-conf"
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_post_get_source() {
	. $TERMUX_PKG_BUILDER_DIR/patch-script/fix-hardcoded-etc-resolv-conf.sh
	. $TERMUX_PKG_BUILDER_DIR/patch-script/remove-pidfd.sh
}

termux_step_make_install() {
	termux_setup_golang

	TERMUX_GOLANG_DIRNAME=${GOOS}_$GOARCH
	TERMUX_GODIR=$TERMUX_PREFIX/lib/go
	local LINKER=/system/bin/linker
	if [ "${TERMUX_ARCH}" == "x86_64" ] || [ "${TERMUX_ARCH}" == "aarch64" ]; then
		LINKER+=64
	fi
	cd $TERMUX_PKG_SRCDIR/src
	# Unset PKG_CONFIG to avoid the path being hardcoded into src/cmd/cgo/zdefaultcc.go,
	# see https://github.com/termux/termux-packages/issues/3505.
	env CC_FOR_TARGET=$CC \
		CXX_FOR_TARGET=$CXX \
		CC=gcc \
		GO_LDFLAGS="-extldflags=-pie" \
		GO_LDSO="$LINKER" \
		GOROOT_BOOTSTRAP=$GOROOT \
		GOROOT_FINAL=$TERMUX_GODIR \
		PKG_CONFIG= \
		./make.bash

	cd ..
	rm -Rf $TERMUX_GODIR
	mkdir -p $TERMUX_GODIR/{bin,src,doc,lib,pkg/tool/$TERMUX_GOLANG_DIRNAME,pkg/include}
	cp bin/$TERMUX_GOLANG_DIRNAME/{go,gofmt} $TERMUX_GODIR/bin/
	ln -sfr $TERMUX_GODIR/bin/go $TERMUX_PREFIX/bin/go
	ln -sfr $TERMUX_GODIR/bin/gofmt $TERMUX_PREFIX/bin/gofmt
	cp go.env $TERMUX_GODIR/
	cp VERSION $TERMUX_GODIR/
	cp pkg/tool/$TERMUX_GOLANG_DIRNAME/* $TERMUX_GODIR/pkg/tool/$TERMUX_GOLANG_DIRNAME/
	cp -Rf src/* $TERMUX_GODIR/src/
	cp -Rf doc/* $TERMUX_GODIR/doc/
	cp pkg/include/* $TERMUX_GODIR/pkg/include/
	cp -Rf lib/* $TERMUX_GODIR/lib
	cp -Rf misc/ $TERMUX_GODIR/
}

termux_step_post_massage() {
	find . -path '*/testdata*' -delete
}
