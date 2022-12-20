TERMUX_PKG_HOMEPAGE=https://github.com/go-jira/jira
TERMUX_PKG_DESCRIPTION="Simple jira command line client written in Go"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.28
TERMUX_PKG_SRCURL=https://github.com/go-jira/jira/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=179abe90458281175a482cbd2e1ad662bdf563ef5acfc2cadf215ae32e0bd1e6
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin jira

	install -Dm644 /dev/null $TERMUX_PREFIX/share/bash-completion/completions/jira-go
	install -Dm644 /dev/null $TERMUX_PREFIX/share/zsh/site-functions/_jira_go
}

termux_step_create_debscripts() {
	cat <<- EOF > postinst
		#!$TERMUX_PREFIX/bin/sh
		# \`|| true\` is used since jira exits with non-zero code even if request succeedes.
		jira --completion-script-bash > $TERMUX_PREFIX/share/bash-completion/completions/jira-go || true
		jira --completion-script-zsh > $TERMUX_PREFIX/share/zsh/site-functions/_jira_go || true
	EOF
}
