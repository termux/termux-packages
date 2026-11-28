TERMUX_PKG_HOMEPAGE=https://podman.io
TERMUX_PKG_DESCRIPTION="A tool for managing OCI containers and pods."
# License: GPL-2.0-with-OpenSSL-exception
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@xingguangcuican6666"
TERMUX_PKG_VERSION="6.2.1"
TERMUX_PKG_SRCURL=https://github.com/podman-container-tools/podman/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=10a56f6a36c4f7ea19956d7298615a6ff1f46978fc36d31dfe31be14899d10fb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libseccomp, runc"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="
etc/containers/containers.conf
etc/containers/policy.json
etc/containers/registries.conf
etc/containers/storage.conf
"

termux_step_make() {
	termux_setup_golang
	export GOOS=linux
	export CGO_ENABLED=1
	local BUILDTAGS="netgo osusergo seccomp exclude_graphdriver_btrfs exclude_graphdriver_devicemapper containers_image_openpgp"
	local GOMODULE
	export CGO_LDFLAGS="${CGO_LDFLAGS} -llog"
	cat <<'EOF' > "${TERMUX_PKG_TMPDIR}/tls.ld"
SECTIONS {
  .tdata : ALIGN(64) { *(.tdata .tdata.*) }
  .tbss : ALIGN(64) { *(.tbss .tbss.*) }
} INSERT BEFORE .bss;
EOF
	GOMODULE=$(head -n1 go.mod | awk '{print $2}')
	go build \
		-buildmode=pie \
		-trimpath \
		-tags "${BUILDTAGS}" \
		-ldflags "-s -w -X ${GOMODULE}/libpod/define.gitCommit=termux -extldflags=-Wl,-T,${TERMUX_PKG_TMPDIR}/tls.ld" \
		-o bin/podman \
		./cmd/podman
	readelf -lW bin/podman | grep TLS || true
	local tls_vaddr
	tls_vaddr=$(readelf -lW bin/podman | awk '$1 == "TLS" {print $3}')
	if [ -n "${tls_vaddr}" ] && [ $(( tls_vaddr % 64 )) -ne 0 ]; then
		termux_error_exit "PT_TLS VirtAddr (${tls_vaddr}) is not 64-byte aligned (skew $(( tls_vaddr % 64 )))"
	fi
}

termux_step_make_install() {
	install -Dm700 bin/podman "${TERMUX_PREFIX}/bin/podman"
	install -Dm644 completions/bash/podman \
		"${TERMUX_PREFIX}/share/bash-completion/completions/podman"
	install -Dm644 completions/fish/podman.fish \
		"${TERMUX_PREFIX}/share/fish/vendor_completions.d/podman.fish"
	install -Dm644 completions/zsh/_podman \
		"${TERMUX_PREFIX}/share/zsh/site-functions/_podman"
	mkdir "${TERMUX_PREFIX}/etc/containers/" -p
	mkdir "${TERMUX_PREFIX}/libexec/podman/" -p
	cat <<-'EOF' > "${TERMUX_PREFIX}/etc/containers/policy.json"
{"default":[{"type":"insecureAcceptAnything"}]}
EOF
	cat <<-'EOF' > "${TERMUX_PREFIX}/etc/containers/registries.conf"
unqualified-search-registries = ["docker.io"]
EOF

	cat <<-EOF > "${TERMUX_PREFIX}/etc/containers/containers.conf"
[engine]
cgroup_manager = "cgroupfs"
events_logger = "file"
runtime = "runc"
no_pivot_root = true
helper_binaries_dir = ["${TERMUX_PREFIX}/libexec/podman", "${TERMUX_PREFIX}/bin"]

[containers]
cgroups = "enabled"
pids_limit = 0
netns = "pasta"
dns_servers = ["1.1.1.1", "223.5.5.5"]

[network]
pasta_options = ["-a", "10.88.0.2", "-n", "24", "-g", "10.88.0.1"]
EOF

	cat <<-EOF > "${TERMUX_PREFIX}/etc/containers/storage.conf"
[storage]
driver = "vfs"
runroot = "${TERMUX_PREFIX}/var/run/containers/storage"
graphroot = "${TERMUX_PREFIX}/var/lib/containers/storage"
EOF
	printf '#!%s/bin/sh\nexit 0\n' "${TERMUX_PREFIX}" > "${TERMUX_PREFIX}/libexec/podman/netavark"
	chmod 755 "${TERMUX_PREFIX}/libexec/podman/netavark"
}
