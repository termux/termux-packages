TERMUX_PKG_HOMEPAGE=https://github.com/aishwaryapasde-max/MobileClaw
TERMUX_PKG_DESCRIPTION="MobileClaw - AI writing assistant for Termux (OpenClaw alternative for mobile)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@aishwaryapasde-max"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/aishwaryapasde-max/MobileClaw/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_DEPENDS="python, python-pip, curl"
TERMUX_PKG_BUILD_IN_SRC=false
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	# Install main script
	install -Dm700 $TERMUX_PKG_SRCDIR/mobileclaw $TERMUX_PREFIX/bin/mobileclaw
	
	# Install AI modules
	mkdir -p $TERMUX_PREFIX/share/mobileclaw
	cp -r $TERMUX_PKG_SRCDIR/mobileclaw_modules $TERMUX_PREFIX/share/mobileclaw/ 2>/dev/null || true
	
	# Install config
	mkdir -p $TERMUX_PREFIX/etc/mobileclaw
}

termux_step_create_debscripts() {
	cat > postinst << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║     🤖 MobileClaw AI - Installed!        ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "MobileClaw is an AI writing assistant for Termux"
echo "Alternative to OpenClaw (openclaw.ai) for mobile"
echo ""
echo "Usage: mobileclaw --help"
echo ""
EOF
}
