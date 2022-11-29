TERMUX_PKG_HOMEPAGE=https://www.terraform.io
TERMUX_PKG_DESCRIPTION="A tool for building, changing, and versioning infrastructure safely and efficiently"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.5
TERMUX_PKG_SRCURL=https://github.com/hashicorp/terraform/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6c44d7b30b31c68333688a794646077842aea94fe6073368824c47d57c22862e
TERMUX_PKG_DEPENDS="git"

termux_step_make() {
	termux_setup_golang

	export GOPATH="${TERMUX_PKG_BUILDDIR}"

	mkdir -p "${GOPATH}"/src/github.com/hashicorp
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}"/src/github.com/hashicorp/terraform

	cd "${GOPATH}"/src/github.com/hashicorp/terraform || exit 1

	go mod init || :
	go mod tidy

	# Backport of https://github.com/lib/pq/commit/6a102c04ac8dc082f1684b0488275575c374cb4c
	termux_download "https://github.com/lib/pq/commit/6a102c04ac8dc082f1684b0488275575c374cb4c.patch" \
		"${TERMUX_PKG_TMPDIR}"/patch1 \
		2812df1db9e42473c30cdbc1f42ae4555027a1e56321189be9f50f52125c146c

	for f in "${GOPATH}"/pkg/mod/github.com/lib/pq@*/user_posix.go; do
		chmod 0755 "$(dirname "$f")"
		chmod 0644 "${f}"
		patch --silent -p1 -d "$(dirname "$f")" <"${TERMUX_PKG_TMPDIR}"/patch1
		# The patch above does not fix build issue for some reason.
		# Alternative workaround:
		rm -f "${f}"
		echo "package pq" > "${f}"
	done

	local GO_LDFLAGS="-X 'github.com/hashicorp/terraform/version.Prerelease='"
	GO_LDFLAGS="${GO_LDFLAGS} -X 'github.com/hashicorp/terraform/version.Version=${TERMUX_PKG_VERSION}'"

	go build -ldflags "${GO_LDFLAGS}" -o terraform .
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "${GOPATH}"/src/github.com/hashicorp/terraform/terraform
}
