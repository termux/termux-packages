TERMUX_PKG_HOMEPAGE=https://gitea.io
TERMUX_PKG_DESCRIPTION="Git with a cup of tea, painless self-hosted git service"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.27.2"
TERMUX_PKG_SRCURL=https://github.com/go-gitea/gitea/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=343cea5b32511b4bba9e721acf5fe4f726d83ec5ea09aa65ccce6a7fb35dfc7b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dash, git"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/gitea/app.ini"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_setup_nodejs

	export DISABLE_V8_COMPILE_CACHE=1
	(unset PREFIX prefix
	npm install pnpm)
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/node_modules/.bin:$PATH"
}

termux_step_configure() {
	termux_setup_nodejs
	termux_setup_golang

	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/node_modules/.bin:$PATH"
}

termux_step_make() {
	LDFLAGS=""
	LDFLAGS+=" -X gitea.dev/modules/setting.CustomConf=$TERMUX_PREFIX/etc/gitea/app.ini"
	LDFLAGS+=" -X gitea.dev/modules/setting.AppWorkPath=$TERMUX_PREFIX/var/lib/gitea"
	LDFLAGS+=" -X gitea.dev/modules/setting.CustomPath=$TERMUX_PREFIX/var/lib/gitea"
	GITEA_VERSION=v"$TERMUX_PKG_VERSION" TAGS="bindata sqlite sqlite_unlock_notify" make all
}

termux_step_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR"/gitea \
		"$TERMUX_PREFIX"/bin/gitea

	mkdir -p "$TERMUX_PREFIX"/etc/gitea
	sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		"$TERMUX_PKG_BUILDER_DIR"/app.ini > "$TERMUX_PREFIX"/etc/gitea/app.ini
}

termux_step_post_massage() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/lib/gitea
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/log/gitea
}
