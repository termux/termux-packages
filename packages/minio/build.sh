TERMUX_PKG_HOMEPAGE=https://min.io/
TERMUX_PKG_DESCRIPTION="Multi-Cloud Object Storage"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
_DATE=2022-12-02
_TIME=19-19-22
TERMUX_PKG_VERSION=${_DATE//-/.}.${_TIME//-/.}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/minio/minio/archive/refs/tags/RELEASE.${_DATE}T${_TIME}Z.tar.gz
TERMUX_PKG_SHA256=0cc787305e317951c8c2f6de1ae14938b750817b310b75e2265195ac00244eb1
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

        go install -v golang.org/x/tools/cmd/stringer@latest
        go install -v github.com/tinylib/msgp@f3635b96e4838a6c773babb65ef35297fe5fe2f9
}

termux_step_make() {
        local _COMMITID=$(git ls-remote https://github.com/minio/minio refs/tags/RELEASE.${_DATE}T${_TIME}Z | cut -f1)
        local _SHORTCOMMITID=$(git ls-remote https://github.com/minio/minio refs/tags/RELEASE.${_DATE}T${_TIME}Z | head -c 12)

        MINIOLDFLAGS="\
        -w -s \
        -X 'github.com/minio/minio/cmd.Version=${_DATE}T${_TIME}Z' \
        -X 'github.com/minio/minio/cmd.CopyrightYear=$(date +%Y)' \
        -X 'github.com/minio/minio/cmd.ReleaseTag=RELEASE.${_DATE}T${_TIME}Z'\
        -X 'github.com/minio/minio/cmd.CommitID=${_COMMITID}' \
        -X 'github.com/minio/minio/cmd.ShortCommitID=${_SHORTCOMMITID}' \
        -X 'github.com/minio/minio/cmd.GOPATH=$(go env GOPATH)' \
        -X 'github.com/minio/minio/cmd.GOROOT=$(go env GOROOT)' \
        "
        CGO_ENABLED=0 go build -tags kqueue -trimpath --ldflags="$MINIOLDFLAGS" -o minio
}
termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin minio
}
