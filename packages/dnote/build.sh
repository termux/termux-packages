TERMUX_PKG_HOMEPAGE=https://www.getdnote.com/
TERMUX_PKG_DESCRIPTION="A simple command line notebook for programmers"
TERMUX_PKG_LICENSE="AGPL-V3,GPL-3.0"
TERMUX_PKG_MAINTAINER="2096779623 <admin@utermux.dev>"
TERMUX_PKG_VERSION=2.0.1
TERMUX_PKG_SRCURL=https://github.com/dnote/dnote/archive/refs/tags/server-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=28cc3bf93b3849b9a4a5e65e531f8a34d6be6048427d924c56ab8c7887676bad
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dnote-server,dnote-client,postgresql"

termux_step_pre_configure() {
        termux_setup_nodejs
        termux_setup_golang

        go mod download
        # build assets for dnote-server:
        cd "$TERMUX_PKG_SRCDIR/pkg/server/assets"
        npm update && npm i
}

termux_step_make() {
        cd "$TERMUX_PKG_SRCDIR"
        export GOOS=android
        $TERMUX_PKG_SRCDIR/scripts/cli/build.sh ${TERMUX_PKG_VERSION}
        $TERMUX_PKG_SRCDIR/scripts/server/build.sh ${TERMUX_PKG_VERSION}

}

termux_step_make_install() {
        install -Dm700 $TERMUX_PKG_SRCDIR/build/server/android-$GOARCH/dnote-server "$TERMUX_PREFIX/bin/dnote-server"
        install -Dm700 $TERMUX_PKG_SRCDIR/build/cli/android-$GOARCH/dnote "$TERMUX_PREFIX/bin/dnote"

        install -Dm644 /dev/null "${TERMUX_PREFIX}/share/bash-completion/completions/dnote.bash"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/zsh/site-functions/_dnote"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/fish/vendor_completions.d/dnote.fish"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		dnote completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/dnote.bash
		dnote completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_dnote
		dnote completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/dnote.fish
	EOF
}

termux_step_install_license() {
	install -Dm600 -t "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}" \
		"${TERMUX_PKG_SRCDIR}/licenses/GPLv3.txt"
        install -Dm600 -t "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}" \
		"${TERMUX_PKG_SRCDIR}/licenses/AGPLv3.txt"
        install -Dm600 -t "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}" \
		"${TERMUX_PKG_SRCDIR}/LICENSE"
}
