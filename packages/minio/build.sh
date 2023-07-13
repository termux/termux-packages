TERMUX_PKG_HOMEPAGE=https://min.io/
TERMUX_PKG_DESCRIPTION="Multi-Cloud Object Storage"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
_DATE=2023-05-04
_TIME=21-44-30
TERMUX_PKG_VERSION=${_DATE//-/.}.${_TIME//-/.}
TERMUX_PKG_SRCURL=https://github.com/minio/minio/archive/refs/tags/RELEASE.${_DATE}T${_TIME}Z.tar.gz
TERMUX_PKG_SHA256=b906049e51f4870edaa2f7f91b4745a54cbc051588d2fa3a9a33f5256c13c454
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang
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
	install -Dm700 -t "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/bin minio
}
