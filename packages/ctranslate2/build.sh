TERMUX_PKG_HOMEPAGE=https://github.com/OpenNMT/CTranslate2
TERMUX_PKG_DESCRIPTION="A fast inference engine for Transformer models"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.8.1
TERMUX_PKG_SRCURL=git+https://github.com/OpenNMT/CTranslate2
TERMUX_PKG_GIT_BRANCH=v${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="libandroid-posix-semaphore, libopenblas, libc++, python"
TERMUX_PKG_BUILD_DEPENDS="half"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="build, 'pybind11==2.11.1'"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_MKL=OFF
-DWITH_OPENBLAS=ON
-DOPENBLAS_INCLUDE_DIR=${TERMUX_PREFIX}/include
-DOPENMP_RUNTIME=NONE
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_pre_configure() {
	export CXXFLAGS+=" -I${TERMUX_PREFIX}/include/openblas -D_GNU_SOURCE"
	export LDFLAGS+=" -lc++_shared -landroid-posix-semaphore"
}

termux_step_post_make_install() {
	cd "$TERMUX_PKG_SRCDIR/python"
	export CTRANSLATE2_ROOT="$TERMUX_PREFIX"
	python -m build --wheel --no-isolation
	pip install dist/*.whl --no-deps --force-reinstall --prefix="$TERMUX_PREFIX"
	ln -sf "$TERMUX_PREFIX/lib/libctranslate2.so" \
		"$TERMUX_PYTHON_HOME/site-packages/ctranslate2/libctranslate2.so"
}
