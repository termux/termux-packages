TERMUX_PKG_HOMEPAGE=https://micro-editor.github.io/
TERMUX_PKG_DESCRIPTION="Modern and intuitive terminal-based text editor"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_SHA256=abf9f65107fac696fb5d0525ed5a3669724910f8300e0c67ee3ff89c243a57e3
TERMUX_PKG_SRCURL=https://github.com/zyedidia/micro/releases/download/v${TERMUX_PKG_VERSION}/micro-${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_FOLDERNAME=micro
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
	return
}

termux_step_make_install() {
	termux_setup_golang

	local HASH="$(git rev-parse --short HEAD)"
	local VERSION="$TERMUX_PKG_VERSION"
	local DATE=`date -I`

	go get -d ./cmd/micro
	go build -ldflags "-s -w -X main.Version=$VERSION -X main.CommitHash=$HASH -X 'main.CompileDate=$DATE'" \
		-o $TERMUX_PREFIX/bin/micro \
		./cmd/micro
}
