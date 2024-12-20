TERMUX_PKG_HOMEPAGE=https://github.com/hbldh/bleak
TERMUX_PKG_DESCRIPTION="A cross platform Bluetooth Low Energy Client for Python using asyncio"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.22.2
TERMUX_PKG_SRCURL=https://github.com/hbldh/bleak/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=89aa893f3fda7f49435ba1cb836ab68180503dd308d23c9e04f667050ce0588c
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PYTHON_BUILD_DEPS="poetry"
TERMUX_PKG_DEPENDS="python, pyjnius"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

termux_step_pre_configure() {
	_ANDROID_JAR="$ANDROID_HOME/platforms/android-28/android.jar"
	patch -p1 < "$TERMUX_PKG_BUILDER_DIR/defs.py.diff"
	patch -p1 < "$TERMUX_PKG_BUILDER_DIR/utils.py.diff"
	patch -p1 < "$TERMUX_PKG_BUILDER_DIR/pyproject.toml.diff"
	curl -L https://github.com/hbldh/bleak/pull/1642.diff | patch -p1
	curl -L https://github.com/hbldh/bleak/pull/1644.diff | patch -p1
}

termux_step_make() {
	javac -encoding UTF-8 -source 1.8 -target 1.8 $(find . -name "*.java") -bootclasspath $_ANDROID_JAR
	$ANDROID_HOME/build-tools/33.0.1/d8 $(find . -name "*.class") \
		--lib $_ANDROID_JAR \
		--release \
		--output bleak/backends/p4android
}

termux_step_make_install() {
	pip install --no-deps --no-build-isolation . --prefix $TERMUX_PREFIX
}
