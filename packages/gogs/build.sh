TERMUX_PKG_HOMEPAGE=https://gogs.io
TERMUX_PKG_DESCRIPTION="A painless self-hosted Git service"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.13.2"
TERMUX_PKG_SRCURL=https://github.com/gogs/gogs/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e49050dbabf7496b6f50ed1a92b5df3437190a45fc031b3a612218151f4db55d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dash, git"
TERMUX_PKG_CONFFILES="etc/gogs/app.ini"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_HOSTBUILD_DIR
	mkdir -p $TERMUX_PKG_HOSTBUILD_DIR
	cd $TERMUX_PKG_HOSTBUILD_DIR
	go install github.com/kevinburke/go-bindata/go-bindata@v3.24.0
}

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p "$GOPATH"/src/gogs.io
	cp -a "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/gogs.io/gogs
	cd "$GOPATH"/src/gogs.io/gogs

	LDFLAGS=""
	LDFLAGS+=" -X gogs.io/gogs/internal/conf.CustomConf=$TERMUX_PREFIX/etc/gogs/app.ini"
	LDFLAGS+=" -X gogs.io/gogs/internal/conf.AppWorkPath=$TERMUX_PREFIX/var/lib/gogs"
	LDFLAGS+=" -X gogs.io/gogs/internal/conf.CustomPath=$TERMUX_PREFIX/var/lib/gogs"

	PATH=$PATH:$TERMUX_PKG_HOSTBUILD_DIR/bin go build -ldflags "${LDFLAGS}" -tags "bindata sqlite" -trimpath -o gogs
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/gogs.io/gogs/gogs \
		"$TERMUX_PREFIX"/bin/gogs

	mkdir -p "$TERMUX_PREFIX"/etc/gogs
	sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		"$TERMUX_PKG_BUILDER_DIR"/app.ini > "$TERMUX_PREFIX"/etc/gogs/app.ini
}

termux_step_post_massage() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/lib/gogs
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/log/gogs
}
