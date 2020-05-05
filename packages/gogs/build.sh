TERMUX_PKG_HOMEPAGE=https://gogs.io/
TERMUX_PKG_DESCRIPTION="A painless self-hosted Git service."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=0.11.91
TERMUX_PKG_SRCURL=https://github.com/gogs/gogs/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6808db68a5952504b81f35fda29ddadde676a91d792262dcf7c3d90be85453eb

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"
	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/gogs
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/gogs/gogs"
	cd "$GOPATH"/src/github.com/gogs/gogs
	go get -d -v
	go build
}

termux_step_make_install() {
	echo '#!/bin/bash' >> $TERMUX_PREFIX/bin/gogs
	echo -e "\n"'$PREFIX/etc/gogs/gogs $@'"" >> $TERMUX_PREFIX/bin/gogs
	chmod +x $PREFIX/bin/gogs
	mkdir -p $TERMUX_PREFIX/etc/gogs
	install -Dm700 \
		"$GOPATH"/src/github.com/gogs/gogs/gogs \
		"$TERMUX_PREFIX"/etc/gogs/

	cp -r "$TERMUX_PKG_SRCDIR"/conf "$TERMUX_PREFIX"/etc/gogs/
	cp -r "$TERMUX_PKG_SRCDIR"/models "$TERMUX_PREFIX"/etc/gogs/
	cp -r  "$TERMUX_PKG_SRCDIR"/public "$TERMUX_PREFIX"/etc/gogs/
	cp -r  "$TERMUX_PKG_SRCDIR"/scripts "$TERMUX_PREFIX"/etc/gogs/
	cp -r  "$TERMUX_PKG_SRCDIR"/routes "$TERMUX_PREFIX"/etc/gogs/
	cp -r "$TERMUX_PKG_SRCDIR"/templates "$TERMUX_PREFIX"/etc/gogs/
	cp -r  "$TERMUX_PKG_SRCDIR"/packager "$TERMUX_PREFIX"/etc/gogs/
}
