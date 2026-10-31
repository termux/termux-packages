TERMUX_PKG_HOMEPAGE=https://github.com/michaelamoetoevsky/PDN
TERMUX_PKG_DESCRIPTION="PRoot Distro Next - Next-generation container platform for Termux/Android"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@michaelamoetoevsky"
TERMUX_PKG_VERSION="0.1.0"
TERMUX_PKG_SRCURL=https://github.com/michaelamoetoevsky/PDN/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8bc0bb931cfb07b7e11aba92ec20f8250e0c4ff2ba0af665d0ce14863e58b63e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="proot, proot-distro"
TERMUX_PKG_BUILD_DEPENDS="rust, clang, lld, cmake, ninja, protobuf, pkg-config, libssl-dev, libclang-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --workspace --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	# Install podnext binary
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/podnext"

	# Install podnext-daemon binary if it exists
	if [ -f "target/${CARGO_TARGET_NAME}/release/podnext-daemon" ]; then
		install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/podnext-daemon"
	fi

	# Install pn-gateway binary if it exists
	if [ -f "target/${CARGO_TARGET_NAME}/release/pn-gateway" ]; then
		install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/pn-gateway"
	fi

	# Create directories for service supervisor
	mkdir -p "$TERMUX_PREFIX/etc/pn-next/services"
	mkdir -p "$TERMUX_PREFIX/var/run/pn-next"
	mkdir -p "$TERMUX_PREFIX/var/log/pn-next"

	# Install default service configuration
	cat > "$TERMUX_PREFIX/etc/pn-next/supervisor.toml" << 'EOF'
# PDN Service Supervisor Configuration
services_dir = "/data/data/com.termux/files/home/.config/pn-next/services"
runtime_dir = "/data/data/com.termux/files/home/.local/run/pn-next"
log_dir = "/data/data/com.termux/files/home/.local/log/pn-next"
supervision_interval_ms = 1000
shutdown_timeout_secs = 30
enable_cgroups = true
max_concurrent_ops = 10
EOF

	# Install shell completions
	mkdir -p "$TERMUX_PREFIX/share/bash-completion/completions"
	mkdir -p "$TERMUX_PREFIX/share/zsh/site-functions"
	mkdir -p "$TERMUX_PREFIX/share/fish/vendor_completions.d"

	# Generate completions
	"$TERMUX_PREFIX/bin/podnext" completion bash > "$TERMUX_PREFIX/share/bash-completion/completions/podnext"
	"$TERMUX_PREFIX/bin/podnext" completion zsh > "$TERMUX_PREFIX/share/zsh/site-functions/_podnext"
	"$TERMUX_PREFIX/bin/podnext" completion fish > "$TERMUX_PREFIX/share/fish/vendor_completions.d/podnext.fish"
}

termux_step_create_debscripts() {
	# Create Termux:Boot script for auto-start
	mkdir -p "$TERMUX_PREFIX/etc/termux/boot"
	cat > "$TERMUX_PREFIX/etc/termux/boot/pdn-services" << 'EOF'
#!/bin/sh
# Auto-start PDN services on Termux boot
export PN_NEXT_SERVICES_DIR=/data/data/com.termux/files/home/.config/pn-next/services
export PN_NEXT_RUNTIME_DIR=/data/data/com.termux/files/home/.local/run/pn-next
export PN_NEXT_LOG_DIR=/data/data/com.termux/files/home/.local/log/pn-next

# Start the supervisor daemon
podnext-daemon start &
EOF
	chmod +x "$TERMUX_PREFIX/etc/termux/boot/pdn-services"
}