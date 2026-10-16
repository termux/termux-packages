TERMUX_PKG_HOMEPAGE=https://forgejo.org/
TERMUX_PKG_DESCRIPTION="Forgejo is a self-hosted lightweight software forge."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="17.0.0"
TERMUX_PKG_SRCURL="https://codeberg.org/forgejo/forgejo/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=cb40c5d47fa34e13022c5cbc91013c92d19ea55d65b2186b925f2b9d5d5f9cd6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dash, git"
TERMUX_PKG_CONFFILES="etc/forgejo/app.ini"

termux_step_pre_configure() {
	termux_setup_nodejs
	termux_setup_golang
}

termux_step_make() {
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p "$GOPATH"/src/forgejo.org
	cp -a "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/forgejo.org/forgejo
	cd "$GOPATH"/src/forgejo.org/forgejo

	go mod init || :
	go mod tidy

	LDFLAGS=""
	LDFLAGS+=" -X forgejo.org/forgejo/modules/setting.CustomConf=$TERMUX_PREFIX/etc/forgejo/app.ini"
	LDFLAGS+=" -X forgejo.org/forgejo/modules/setting.AppWorkPath=$TERMUX_PREFIX/var/lib/forgejo"
	LDFLAGS+=" -X forgejo.org/forgejo/modules/setting.CustomPath=$TERMUX_PREFIX/var/lib/forgejo"
	FORGEJO_VERSION=v"$TERMUX_PKG_VERSION" TAGS="bindata sqlite sqlite_unlock_notify" make all
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/forgejo.org/forgejo/gitea \
		"$TERMUX_PREFIX"/bin/forgejo

	mkdir -p "$TERMUX_PREFIX"/etc/forgejo
	sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		"$TERMUX_PKG_BUILDER_DIR"/app.ini > "$TERMUX_PREFIX"/etc/forgejo/app.ini
}

termux_step_post_massage() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/lib/forgejo
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/log/forgejo
}
