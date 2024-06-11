TERMUX_PKG_HOMEPAGE=https://containerd.io/
TERMUX_PKG_DESCRIPTION="An open and reliable container runtime"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Be sure to test docker before pushing an update. With 1.6.24 or
# 1.7.7 we get the following error:
# $ sudo docker run -it ubuntu bash
# docker: Error response from daemon: failed to create task for container: failed to start shim: start failed: io.containerd.runc.v2: create new shim socket: listen unix /data/data/com.termux/files/usr/var/run/containerd/s/3f71828f1d6c1ead43fded842abc9c3cf5857c74c3e0704cd83ab177e17cfe6c: bind: invalid argument: exit status 1: unknown.
TERMUX_PKG_VERSION=1.6.21
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=git+https://github.com/containerd/containerd
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="runc"
TERMUX_PKG_CONFFILES="etc/containerd/config.toml"

termux_step_post_get_source() {
	echo "github.com/cpuguy83/go-md2man/v2" >> vendor/modules.txt
}

termux_step_make() {
	# setup go build environment
	termux_setup_golang
	go env -w GO111MODULE=auto
	export GOPATH="${PWD}/go"
	mkdir -p "${GOPATH}/src/github.com/containerd"
	ln -sf "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/containerd/containerd"
	cd "${GOPATH}/src/github.com/containerd/containerd"

	# issue the build command
	export BUILDTAGS=no_btrfs
	make -j ${TERMUX_PKG_MAKE_PROCESSES}
	(unset GOOS GOARCH CGO_LDFLAGS CC CXX CFLAGS CXXFLAGS LDFLAGS
	make -j ${TERMUX_PKG_MAKE_PROCESSES} man)

}

termux_step_make_install() {
	cd "${GOPATH}/src/github.com/containerd/containerd"
	DESTDIR= make install
	DESTDIR= make install-man
	install -Dm 600 ${TERMUX_PKG_BUILDER_DIR}/config.toml ${TERMUX_PREFIX}/etc/containerd/config.toml
}
