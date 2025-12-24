TERMUX_PKG_HOMEPAGE=https://github.com/opencv/opencv-python
TERMUX_PKG_DESCRIPTION="Python wrapper for Python bindings for OpenCV"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="88"
TERMUX_PKG_REVISION=1
TERMUX_PKG_REPOLOGY_METADATA_VERSION="$(. "$TERMUX_SCRIPTDIR/x11-packages/opencv/build.sh"; echo "$TERMUX_PKG_VERSION").${TERMUX_PKG_VERSION}"
TERMUX_PKG_SRCURL="https://github.com/opencv/opencv-python/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c1cfdef91a45468b1c4404af594e2286ce2bcd343fe318aae287997a395a6c90
TERMUX_PKG_DEPENDS="opencv, opencv-python, python, python-pip"
TERMUX_PKG_PYTHON_COMMON_DEPS="scikit-build"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_cmake

	# prevent any downloading or compiling of opencv source code,
	# but allow the normal installation of all other files
	echo '' > pyproject.toml
	mkdir -p opencv/empty
	echo 'cmake_minimum_required(VERSION 4.0)' > opencv/CMakeLists.txt
	echo 'install(DIRECTORY empty DESTINATION "${CMAKE_INSTALL_PREFIX}")' >> opencv/CMakeLists.txt

	# force version.py to generate
	patch="$TERMUX_PKG_BUILDER_DIR/find_version.py.diff"
	echo "Applying patch: $(basename "$patch")"
	test -f "$patch" && sed \
		-e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		-e "s%\@TERMUX_PKG_VERSION\@%${TERMUX_PKG_VERSION}%g" \
		"$patch" | patch --silent -p1
}

termux_step_post_make_install() {
	# also provide the opencv-contrib-python variant because Termux opencv also has the extra modules,
	# but some python projects might attempt to import either 'opencv-python' or 'opencv-contrib-python'.
	# which have different names
	export ENABLE_CONTRIB=1
	pip install --no-deps . --prefix "$TERMUX_PREFIX"
}
