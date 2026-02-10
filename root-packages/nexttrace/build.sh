TERMUX_PKG_HOMEPAGE=https://github.com/nxtrace/Ntrace-V1
TERMUX_PKG_DESCRIPTION="An open source visual routing tool that pursues light weight"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.1~rc.1"
TERMUX_PKG_SRCURL=https://github.com/nxtrace/Ntrace-V1/archive/refs/tags/v${TERMUX_PKG_VERSION//\~/-}.tar.gz
TERMUX_PKG_SHA256=18c3ecdf191797d51062c4d598ac518397a804bed6d87c3a884e1701d938a3cf
TERMUX_PKG_BREAKS="nexttrace-enhanced"
TERMUX_PKG_REPLACES="nexttrace-enhanced"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	local _BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
	local _COMMIT_SHA1=$(git ls-remote https://github.com/nxtrace/Ntrace-V1 refs/tags/v$TERMUX_PKG_VERSION | head -c 9)
	go build -trimpath -o nexttrace \
	-ldflags "-X 'github.com/nxtrace/NTrace-core/config.Version=${TERMUX_PKG_VERSION}' \
	-X 'github.com/nxtrace/NTrace-core/config.BuildDate=${_BUILD_DATE}' \
	-X 'github.com/nxtrace/NTrace-core/config.CommitID=${_COMMIT_SHA1}' -w -s"
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin nexttrace
}
