TERMUX_PKG_HOMEPAGE="https://uno-km.vercel.app/"
TERMUX_PKG_DESCRIPTION="Unified Sovereign On-Device AI Suite Meta-Package for Termux"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Uno Kim <contact@uno-km.com>"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_DEPENDS="termux-tts, termux-stt, termux-bitnet, termux-llamacpp, termux-diffusion, termux-vision, termux-aichain, termux-train"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX/bin"
	cat <<- 'EOF' > "$TERMUX_PREFIX/bin/termux-ai-suite"
#!/data/data/com.termux/files/usr/bin/bash
echo "AMEVA Sovereign On-Device AI Suite (8-in-1 Modalities Active)"
echo "Available CLI tools: termux-tts, termux-stt, termux-bitnet, termux-llamacpp, termux-diffusion, termux-vision, termux-aichain, termux-train"
EOF
	chmod 755 "$TERMUX_PREFIX/bin/termux-ai-suite" 
}
