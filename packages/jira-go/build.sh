TERMUX_PKG_HOMEPAGE=https://github.com/go-jira/jira
TERMUX_PKG_DESCRIPTION="Simple jira command line client written in Go"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.27"
TERMUX_PKG_SRCURL=https://github.com/go-jira/jira/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c5bcf7b61300b67a8f4e42ab60e462204130c352050e8551b1c23ab2ecafefc7
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin jira
}

termux_step_create_debscripts() {
	cat <<- EOF > postinst
		#!$TERMUX_PREFIX/bin/sh
		mkdir -p $TERMUX_PREFIX/share/bash-completion/completions
		# \`|| true\` is used since jira exits with non-zero code even if request succeedes.
		jira --completion-script-bash > $TERMUX_PREFIX/share/bash-completion/completions/jira-go || true
		mkdir -p $TERMUX_PREFIX/share/zsh/site-functions
		jira --completion-script-zsh > $TERMUX_PREFIX/share/zsh/site-functions/_jira_go || true
	EOF

	cat <<- EOF > prerm
		#!$TERMUX_PREFIX/bin/sh
		rm -f $TERMUX_PREFIX/share/bash-completion/completions/jira-go
		rm -f $TERMUX_PREFIX/share/zsh/site-functions/_jira_go
	EOF
}
