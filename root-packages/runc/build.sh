TERMUX_PKG_HOMEPAGE=https://www.opencontainers.org/
TERMUX_PKG_DESCRIPTION="A tool for spawning and running containers according to the OCI specification"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.4"
TERMUX_PKG_SRCURL=https://github.com/opencontainers/runc/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9785c144c97974b52b6091b7a79168b73681ff574bc8438b44f3f5f8c112f171
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="libseccomp-static"

termux_step_make() {
	${CC} -c -o stubs.o "$TERMUX_PKG_BUILDER_DIR/stubs.c"
	${AR} rcs liblog.a stubs.o

	export CGO_LDFLAGS="-L$TERMUX_PKG_BUILDDIR"

	termux_setup_golang

	export GOPATH="${PWD}/go"

	mkdir -p "${GOPATH}/src/github.com/opencontainers"
	ln -sf "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/opencontainers/runc"

	cd "${GOPATH}/src/github.com/opencontainers/runc" && make static
}

termux_step_make_install() {
	cd "${GOPATH}/src/github.com/opencontainers/runc"
	install -Dm755 runc "${TERMUX_PREFIX}/bin/runc"
}

termux_step_create_debscripts() {
	{
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "echo"
		echo 'echo "RunC requires support for devices cgroup support in kernel."'
		echo "echo"
		echo 'echo "If CONFIG_CGROUP_DEVICE was enabled during compile time,"'
		echo 'echo "you need to run the following commands (as root) in order"'
		echo 'echo "to use the RunC:"'
		echo "echo"
		echo 'echo "  mount -t tmpfs -o mode=755 tmpfs /sys/fs/cgroup"'
		echo 'echo "  mkdir -p /sys/fs/cgroup/devices"'
		echo 'echo "  mount -t cgroup -o devices cgroup /sys/fs/cgroup/devices"'
		echo "echo"
		echo 'echo "If you got error when running commands listed above, this"'
		echo 'echo "usually means that your kernel lacks CONFIG_CGROUP_DEVICE."'
		echo "echo"
		echo "exit 0"
	} > postinst
}
