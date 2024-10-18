TERMUX_PKG_HOMEPAGE=https://github.com/Yash-Handa/logo-ls
TERMUX_PKG_DESCRIPTION="Modern ls command with vscode like File Icon and Git Integrations"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=f8cd9997ebfad185d5668ed0403702540828199c
TERMUX_PKG_VERSION="2024.07.17"
TERMUX_PKG_SRCURL=git+https://github.com/canta2899/logo-ls
TERMUX_PKG_SHA256=b71da1a634f8e22f500cc37c99ae26d173f8b49a6bd3c1ee4dd49b21d30fdd66
TERMUX_PKG_GIT_BRANCH="main"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git -c log.showSignature=false log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build -o logo-ls ./cmd/logo-ls
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
