TERMUX_PKG_HOMEPAGE=https://gitea.io
TERMUX_PKG_DESCRIPTION="Git with a cup of tea, painless self-hosted git service"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.10.3
TERMUX_PKG_SRCURL=https://github.com/go-gitea/gitea/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=564b676163077dfc2c1d0175c9766cf118b8fc917f49e7e7e2e5b2b33d8b6539
TERMUX_PKG_DEPENDS="dash, git"
TERMUX_PKG_CONFFILES="etc/gitea/app.ini"

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
	(
		LDFLAGS=""
		LDFLAGS+=" -X code.gitea.io/gitea/modules/setting.CustomConf=$TERMUX_PREFIX/etc/gitea/app.ini"
		LDFLAGS+=" -X code.gitea.io/gitea/modules/setting.AppWorkPath=$TERMUX_PREFIX/var/lib/gitea"
		LDFLAGS+=" -X code.gitea.io/gitea/modules/setting.CustomPath=$TERMUX_PREFIX/var/lib/gitea"
		TAGS="bindata sqlite" make all
	)
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/code.gitea.io/gitea/gitea \
		"$TERMUX_PREFIX"/bin/gitea

	mkdir -p "$TERMUX_PREFIX"/etc/gitea
	sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		"$TERMUX_PKG_BUILDER_DIR"/app.ini > "$TERMUX_PREFIX"/etc/gitea/app.ini
}

termux_step_post_massage() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/lib/gitea
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/log/gitea
}
