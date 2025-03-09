TERMUX_PKG_HOMEPAGE=https://github.com/kivy/pyjnius
TERMUX_PKG_DESCRIPTION="Access Java classes from Python"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_SRCURL=https://github.com/kivy/pyjnius/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5f14fe3cc0e37fb15dae1ffd6c4c5f7bfec2bfaff0f82af21feec25b4d46c0ef
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PYTHON_BUILD_DEPS="poetry"
TERMUX_PKG_PYTHON_COMMON_DEPS="Cython"
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	_ANDROID_JAR="$ANDROID_HOME/platforms/android-28/android.jar"
	curl -L https://github.com/kivy/pyjnius/pull/732.diff | patch -p1
	curl -L https://github.com/kivy/pyjnius/pull/733.diff | patch -p1
}

termux_step_make() {
	python setup.py sdist
	$ANDROID_HOME/build-tools/33.0.1/d8 $(find . -name "*.class") \
		--lib $_ANDROID_JAR \
		--release \
		--output jnius/src/org/jnius/
}
