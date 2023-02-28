TERMUX_PKG_HOMEPAGE=https://gogs.io
TERMUX_PKG_DESCRIPTION="A painless self-hosted Git service"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Injamul Mohammad Mollah <mrinjamul@gmail.com>"
TERMUX_PKG_VERSION="0.13.0"
TERMUX_PKG_SRCURL=https://github.com/gogs/gogs/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=59a8c4349ed104ccd44985e940a6cdb25fca1a6019212e7f65b30f1252f627ce
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dash, git"
TERMUX_PKG_CONFFILES="etc/gogs/app.ini"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_HOSTBUILD_DIR
	mkdir -p $TERMUX_PKG_HOSTBUILD_DIR
	cd $TERMUX_PKG_HOSTBUILD_DIR
	go install github.com/kevinburke/go-bindata/go-bindata@latest
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
