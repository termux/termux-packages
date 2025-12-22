TERMUX_PKG_HOMEPAGE=https://github.com/ggdev-ops/ggdev-agent
TERMUX_PKG_DESCRIPTION="AI Agent Collaboration Protocol + Development Tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@ggdev-ops"
TERMUX_PKG_VERSION=1.0.0
_COMMIT=9b8219b86a1dd279c68692b8c1c2cfe5dcd75011
TERMUX_PKG_SRCURL=https://github.com/ggdev-ops/ggdev-agent/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=c505b360f3d9388f5e47478bfb1a451caa989821fdd1bbaf2904c8ba4f399bb0
TERMUX_PKG_DEPENDS="bash, coreutils"
TERMUX_PKG_SUGGESTS="git, nodejs, python, clang, make"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	:
}

termux_step_make_install() {
	# Install scripts to share directory
	local INSTALL_DIR="$TERMUX_PREFIX/share/ggdev-agent"
	mkdir -p "$INSTALL_DIR"
	
	# Copy package content
	cp -r packages/ggdev-agent/* "$INSTALL_DIR/"
	
	# Make scripts executable
	find "$INSTALL_DIR" -name "*.sh" -exec chmod +x {} \;
	
	# Create symlinks in bin
	ln -sf "$INSTALL_DIR/ggdev.sh" "$TERMUX_PREFIX/bin/ggdev"
	ln -sf "$INSTALL_DIR/ggdev-agent.sh" "$TERMUX_PREFIX/bin/ggdev-agent"
	
	# Install docs
	mkdir -p "$TERMUX_PREFIX/share/doc/ggdev-agent"
	cp README.md "$TERMUX_PREFIX/share/doc/ggdev-agent/"
}

