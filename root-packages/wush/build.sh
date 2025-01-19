TERMUX_PKG_HOMEPAGE=https://github.com/coder/wush/
TERMUX_PKG_DESCRIPTION="simplest & fastest way to transfer files between computers"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.1"
TERMUX_PKG_SRCURL=https://github.com/coder/wush/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=77d5a912465d1e8ec478252a9a69a04d39af75a126ac9ed94823f33a60b3d8f9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	export GOOS="android"
	cd $TERMUX_PKG_SRCDIR/cmd/wush
	go get
	chmod +w $GOPATH -R
}

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR/cmd/wush
	local _Commit=$(git ls-remote --tags https://github.com/coder/wush.git | grep refs/tags/v$TERMUX_PKG_VERSION | grep '\^{}' | awk '{print $1}')
	local _UnixTimeStamp=$(date +%s)
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go build -o wush -ldflags="-s -w -X main.version=$TERMUX_PKG_VERSION -X main.commit=$_Commit -X main.commitDate=$_UnixTimeStamp"
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin "$TERMUX_PKG_SRCDIR/cmd/wush/wush"
}
