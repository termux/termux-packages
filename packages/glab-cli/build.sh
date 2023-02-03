TERMUX_PKG_HOMEPAGE=https://glab-cli.io
TERMUX_PKG_DESCRIPTION="A GitLab CLI tool bringing GitLab to your command line"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.22.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/profclems/glab/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4b700d46cf9ee8fe6268e7654326053f4366aa3e072b5c3f3d243930a6e89edc
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_MAKE_ARGS="GLAB_VERSION=${TERMUX_PKG_VERSION}"

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin bin/glab

	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/glab.bash
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_glab
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/glab.fish
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		glab completion -s bash > ${TERMUX_PREFIX}/share/bash-completion/completions/glab.bash
		glab completion -s zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_glab
		glab completion -s fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/glab.fish
	EOF
}
