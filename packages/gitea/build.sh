TERMUX_PKG_HOMEPAGE=https://gitea.io
TERMUX_PKG_DESCRIPTION="Git with a cup of tea, painless self-hosted git service"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.9.2
TERMUX_PKG_SHA256=229e3614bf50bc9fee7f378d422b4dea18d6cf607f94f100070fdfec6d0f2c05
TERMUX_PKG_SRCURL=https://github.com/go-gitea/gitea/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="dash, git"

termux_step_make() {
	echo 'replace github.com/go-macaron/cors v0.0.0-20190309005821-6fd6a9bfe14e9 => github.com/go-macaron/cors 6fd6a9bfe14e' >> $TERMUX_PKG_SRCDIR/go.mod

	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p "$GOPATH"/src/code.gitea.io
	cp -a "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/code.gitea.io/gitea
	cd "$GOPATH"/src/code.gitea.io/gitea

	# go-bindata shoudn't be cross-compiled
	GOOS=linux GOARCH=amd64 go get -u github.com/jteeuwen/go-bindata/...
	export PATH="$PATH:$GOPATH/bin"

	CGO_ENABLED=0 CGO_LDFLAGS="" CGO_CFLAGS="" GOOS=linux GOARCH=amd64 make generate
	#CGO_ENABLED=0 CGO_LDFLAGS="" CGO_CFLAGS="" LDFLAGS="" TAGS="bindata sqlite" make all
	LDFLAGS="" TAGS="bindata sqlite" make all
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/code.gitea.io/gitea/gitea \
		"$TERMUX_PREFIX"/bin/gitea

	mkdir -p "$TERMUX_PREFIX"/etc/gitea
	sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		"$TERMUX_PKG_BUILDER_DIR"/app.ini > "$TERMUX_PREFIX"/etc/gitea/app.ini

	sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		"$TERMUX_PKG_BUILDER_DIR"/gitea-service.sh > "$TERMUX_PREFIX"/bin/gitea-service.sh
	chmod 700 ${TERMUX_PREFIX}/bin/gitea-service.sh
}

termux_step_post_massage() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/gitea
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/log/gitea
}
