TERMUX_PKG_HOMEPAGE=https://www.opencontainers.org/
TERMUX_PKG_DESCRIPTION="A tool for spawning and running containers according to the OCI specification"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.14"
TERMUX_PKG_SRCURL=https://github.com/opencontainers/runc/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=563cf57c38d2e7149234dbe6f63ca0751eb55ef8f586ed12a543dedc1aceba68
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="libseccomp-static"

termux_step_make() {
	cat > fakes.c << EOF
#include <stdio.h>
#include <stdlib.h>
#include <sys/system_properties.h>

int __android_log_vprint(int prio, const char* tag, const char* fmt, va_list ap) {
    char buf[1024];
    vsnprintf(buf, sizeof(buf), fmt, ap);
    fprintf(stdout, "%s: %s\n", tag, buf);
    return 0;
}

void* dlopen(const char* filename, int flag) {
    return (void*)1;
}

void* dlsym(void* handle, const char* symbol) {
	// https://github.com/golang/go/issues/59942
	if (strcmp(symbol, "android_get_device_api_level") != 0) {
		fprintf(stderr, "Error: Unexpected symbol requested: %s\n", symbol);
		exit(1);
	}
	char buff[PROP_VALUE_MAX];
	int n = __system_property_get("ro.build.version.sdk", buff);
	if (n <= 0) {
		fprintf(stderr, "Error: Failed to get device API level\n");
		exit(1);
	}
	int api_level = atoi(buff);
	if (api_level < 29) {
		return NULL;
	}
	return (void*)1;
}

int dlclose(void* handle) {
    return 0;
}
EOF

	${CC:-gcc} -c -o fakes.o fakes.c
	${AR:-ar} rcs liblog.a fakes.o

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
