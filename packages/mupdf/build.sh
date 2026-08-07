TERMUX_PKG_HOMEPAGE=https://mupdf.com/
TERMUX_PKG_DESCRIPTION="Lightweight PDF and XPS viewer (library)"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.2"
TERMUX_PKG_SRCURL="https://mupdf.com/downloads/archive/mupdf-${TERMUX_PKG_VERSION}-source.tar.gz"
TERMUX_PKG_SHA256=44075a84e329db55b9bef5f342a70fd26d69e48ad1d33cb89d9664581c641156
TERMUX_PKG_DEPENDS="brotli, freetype, gumbo-parser, harfbuzz, jbig2dec, leptonica, libandroid-shmem, libc++, libjpeg-turbo, openjpeg, tesseract, zlib"
TERMUX_PKG_BUILD_DEPENDS="python-pipcl"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="clang"
# clang crash occurs if removed
# Arch Linux also sets this
TERMUX_PKG_MAKE_PROCESSES=1
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
prefix=$TERMUX_PREFIX
pydir=$TERMUX_PYTHON_HOME/site-packages
build=release
libs
c++
shared=yes
tesseract=yes
VENV_FLAG=
V=1
"

# Automatic updates break k2pdfopt on regular basis
TERMUX_PKG_AUTO_UPDATE=false

termux_step_post_get_source() {
	mv pyproject.toml{,.unused}
	mv setup.py{,.unused}
	sed -i "s/HAVE_OBJCOPY := yes/HAVE_OBJCOPY := no/g" $TERMUX_PKG_SRCDIR/Makerules
}

termux_step_pre_configure() {
	rm -rf thirdparty/{brotli,freeglut,freetype,harfbuzz,jbig2dec,leptonica,libjpeg,openjpeg,tesseract,zlib}
	export USE_SYSTEM_LIBS=yes
	LDFLAGS+=" -llog -landroid-shmem"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		patch="$TERMUX_PKG_BUILDER_DIR/libclang.diff"
		echo "Applying patch: $(basename "$patch")"
		sed -e "s%\@TERMUX_HOST_LLVM_MAJOR_VERSION\@%${TERMUX_HOST_LLVM_MAJOR_VERSION}%g" \
			"$patch" | patch --silent -p1
	fi
}

termux_step_post_make_install() {
	# needs to be after everything else because it needs to find
	# libmupdfcpp.so inside $TERMUX_PREFIX/lib
	make $TERMUX_PKG_EXTRA_MAKE_ARGS python
	make $TERMUX_PKG_EXTRA_MAKE_ARGS install-shared-python
}
