TERMUX_PKG_HOMEPAGE=https://github.com/Yash-Handa/logo-ls
TERMUX_PKG_DESCRIPTION="Modern ls command with vscode like File Icon and Git Integrations"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Yash-Handa/logo-ls/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4753eb26c3e763b20249587a048ea5997544521909968aa082f3ef6f396dc65e
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy 
}

termux_step_make() {
	go build -o logo-ls
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin logo-ls
}

termux_step_create_debscripts() {                   
	cat <<- POSTINST_EOF > ./postinst           
	#!$TERMUX_PREFIX/bin/sh
	echo "Please change font from termux-styling addon"
	POSTINST_EOF
}
