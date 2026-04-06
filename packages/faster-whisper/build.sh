TERMUX_PKG_HOMEPAGE=https://github.com/SYSTRAN/faster-whisper
TERMUX_PKG_DESCRIPTION="Faster Whisper transcription with CTranslate2"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER=@termux
TERMUX_PKG_VERSION="1.0.3"
TERMUX_PKG_SRCURL=https://github.com/SYSTRAN/faster-whisper/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=53d2630992e551caf66081f8e93fad1c45c90edb3739c6f2c0636c70c1f629b7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python, python-pip, ctranslate2, onnxruntime, python-numpy"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, setuptools"

# Runtime dependencies that will be pulled by pip during installation:
# - av (PyAV) - audio/video processing
# - huggingface-hub - model downloading
# - tokenizers - text tokenization

termux_step_make_install() {
    pip install --no-deps --prefix=$TERMUX_PREFIX .
}

termux_step_create_debscripts() {
    cat <<- EOF > ./postinst
#!${TERMUX_PREFIX}/bin/sh
echo ""
echo "========================================="
echo "faster-whisper installation complete!"
echo "========================================="
echo ""
echo "Installing additional Python dependencies..."
pip install --no-build-isolation 'av>=11.0.0' 'huggingface-hub>=0.13' 'tokenizers>=0.13'
echo ""
echo "For CPU usage on Android/Termux, use:"
echo "  from faster_whisper import WhisperModel"
echo "  model = WhisperModel('tiny', device='cpu', compute_type='int8')"
echo ""
echo "Available models: tiny, base, small, medium, large-v1, large-v2, large-v3"
echo "Smaller models (tiny/base) work best on mobile devices."
echo ""
EOF

    cat <<- EOF > ./prerm
#!${TERMUX_PREFIX}/bin/sh
echo "Removing faster-whisper..."
EOF

    chmod 0755 postinst prerm
}
