TERMUX_PKG_HOMEPAGE=https://github.com/cloudflare/cloudflared
TERMUX_PKG_DESCRIPTION="A tunneling daemon that proxies traffic from the Cloudflare network to your origins"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.8.3"
TERMUX_PKG_SRCURL=https://github.com/cloudflare/cloudflared/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=04cd85af52c2c012f08212c878b4c403eadf410865f2356a80f361d475d2fc92
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	local _DATE=$(date -u '+%Y.%m.%d-%H:%M UTC')
	go build -v -ldflags "-X \"main.Version=$TERMUX_PKG_VERSION\" -X \"main.BuildTime=$_DATE\"" \
		./cmd/cloudflared
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin cloudflared
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/var/service/cloudflared/log"
	ln -sf "$TERMUX_PREFIX/share/termux-services/svlogger" "$TERMUX_PREFIX/var/service/cloudflared/log/run"
	sed "s%@TERMUX_PREFIX@%$TERMUX_PREFIX%g" "$TERMUX_PKG_BUILDER_DIR/sv/cloudflared.run.in" > "$TERMUX_PREFIX/var/service/cloudflared/run"
	chmod 700 "$TERMUX_PREFIX/var/service/cloudflared/run"
	touch "$TERMUX_PREFIX/var/service/cloudflared/down"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./prerm
		#!${TERMUX_PREFIX}/bin/sh
		cd ${TERMUX_PREFIX}
		if [ -x "${TERMUX_PREFIX}/bin/sv" ]; then
			sv-disable cloudflared || :
			sv down cloudflared || :
		fi
		rm -rf ${TERMUX_PREFIX}/var/service/cloudflared
	EOF
	chmod 0700 prerm
}
