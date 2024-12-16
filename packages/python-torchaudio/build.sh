TERMUX_PKG_HOMEPAGE=https://github.com/pytorch/audio
TERMUX_PKG_DESCRIPTION="Data manipulation and transformation for audio signal processing, powered by PyTorch"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.5.0
TERMUX_PKG_REVISION=1
# FFmpeg 7 is not yet supported. The subpackage should be removed when FFmpeg 7
# is supported by an upstream release.
# https://github.com/pytorch/audio/issues/3857
_FFMPEG_VERSION=6.1.2
_FFMPEG_SRCURL="https://www.ffmpeg.org/releases/ffmpeg-$_FFMPEG_VERSION.tar.xz"
_FFMPEG_RM_AFTER_INSTALL="
opt/torchaudio/include
opt/torchaudio/lib/pkgconfig
opt/torchaudio/share
"
TERMUX_PKG_SRCURL=(https://github.com/pytorch/audio/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
                   $_FFMPEG_SRCURL)
TERMUX_PKG_SHA256=(fca49590d36966879f37cef29dcc83507e97e7cad68035a851734d93066c018e
                   3b624649725ecdc565c903ca6643d41f33bd49239922e45c9b1442c63dca4e38)
TERMUX_PKG_DEPENDS="libc++, python, python-pip, python-torch, torchaudio-ffmpeg"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, setuptools"
TERMUX_PKG_RM_AFTER_INSTALL=$_FFMPEG_RM_AFTER_INSTALL

_ffmpeg_configure_make_install() {
	export _FFMPEG_PREFIX=${TERMUX_PREFIX}/opt/torchaudio
	LDFLAGS="-Wl,-rpath=${_FFMPEG_PREFIX}/lib ${LDFLAGS}"

	local _ARCH
	case ${TERMUX_ARCH} in
		arm ) _ARCH=armeabi-v7a ;;
		i686 ) _ARCH=x86 ;;
		* ) _ARCH=$TERMUX_ARCH ;;
	esac

	mkdir -p _ffmpeg-${_FFMPEG_VERSION}
	pushd _ffmpeg-${_FFMPEG_VERSION}
	$TERMUX_PKG_SRCDIR/ffmpeg-${_FFMPEG_VERSION}/configure \
		--prefix=${_FFMPEG_PREFIX} \
		--cc=${CC} \
		--pkg-config=false \
		--arch=${_ARCH} \
		--cross-prefix=llvm- \
		--enable-cross-compile \
		--target-os=android \
		--disable-version3 \
		--disable-static \
		--enable-shared \
		--disable-all \
		--disable-autodetect \
		--disable-doc \
		--enable-avcodec \
		--enable-avformat \
		--enable-avdevice \
		--enable-avfilter \
		--disable-asm
	make -j ${TERMUX_PKG_MAKE_PROCESSES}
	make install
	popd
}

_ffmpeg_post_make_install() {
	local _FFMPEG_DOCDIR=$TERMUX_PREFIX/share/doc/torchaudio-ffmpeg
	mkdir -p ${_FFMPEG_DOCDIR}
	ln -sfr ${TERMUX_PREFIX}/share/LICENSES/LGPL-2.1.txt \
		${_FFMPEG_DOCDIR}/LICENSE
}

_ffmpeg_post_massage() {
	rm -rf lib/pkgconfig
}

termux_step_pre_configure() {
	_ffmpeg_configure_make_install
	termux_setup_cmake
	termux_setup_ninja

	export BUILD_VERSION=$TERMUX_PKG_VERSION
	export FFMPEG_ROOT="$_FFMPEG_PREFIX"
	# use this FFMPEG_ROOT when the system ffmpeg package can work
	# export FFMPEG_ROOT="$TERMUX_PREFIX"
	export TORCHAUDIO_CMAKE_PREFIX_PATH="$TERMUX_PYTHON_HOME/site-packages/torch;$TERMUX_PREFIX"
	export host_alias="$TERMUX_HOST_PLATFORM"
}

termux_step_configure() {
	:
}

termux_step_make_install() {
	pip -v install --no-build-isolation --no-deps --prefix "$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}

termux_step_post_make_install() {
	_ffmpeg_post_make_install
}

termux_step_post_massage() {
	_ffmpeg_post_massage
}
