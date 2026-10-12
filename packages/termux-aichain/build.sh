TERMUX_PKG_HOMEPAGE="https://uno-km.vercel.app/lib/aichain/"
TERMUX_PKG_DESCRIPTION="Zero-Dependency AI Chaining and Autonomous Agent Framework for Termux"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Uno Kim <contact@uno-km.com>"
TERMUX_PKG_VERSION="1.1.5"
TERMUX_PKG_SRCURL="https://files.pythonhosted.org/packages/67/e8/41da166fc5957b897bf75e94b1412598babbaef4efcbc40c99d3f47825ec/termux_aichain-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="bd8529f3b1a929819b269480d7cfb043bc66e923ca44bd2fcc9f995be9a94d3e"
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	pip install . --prefix="$TERMUX_PREFIX" --no-deps --no-build-isolation
}
