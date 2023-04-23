TERMUX_PKG_HOMEPAGE=https://bellard.org/tcc/
TERMUX_PKG_DESCRIPTION="Tiny C Compiler"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=bb93bf8cd29140610f0d94f6565501d30215bd98
_COMMIT_DATE=20230425
TERMUX_PKG_VERSION=1:0.9.27-p${_COMMIT_DATE}
TERMUX_PKG_SRCURL=git+https://repo.or.cz/tinycc.git
TERMUX_PKG_SHA256=ed447c67ae71a7ebc0754a6cbd3bd11eb06cd24b70b81ac9227eb0e2d01dabdf
TERMUX_PKG_GIT_BRANCH=mob
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_DEPENDS="ndk-sysroot"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local pdate="p$(git log -1 --format=%cs | sed 's/-//g')"
	if [[ "$TERMUX_PKG_VERSION" != *"${pdate}" ]]; then
		echo -n "ERROR: The version string \"$TERMUX_PKG_VERSION\" is"
		echo -n " different from what is expected to be; should end"
		echo " with \"${pdate}\"."
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_configure() {

        echo "configuring later..."
}

termux_step_make() {

	if [ "${TERMUX_ARCH}" = "arm" ] || [ "${TERMUX_ARCH}" = "i686" ]; then
		ELF_INTERPRETER_PATH="/system/bin/linker"
		ANDROID_LIB_PATH="/system/lib:/system/vendor/lib"
	else
		ELF_INTERPRETER_PATH="/system/bin/linker64"
		ANDROID_LIB_PATH="/system/lib64:/system/vendor/lib64"
	fi

	# armeabi needs specific configuration
	if [ "${TERMUX_ARCH}" = "arm" ]; then
		TCC_CONFIG="--cpu=armv7a --config-arm_eabi --config-arm_vfp"
	else
		TCC_CONFIG="--cpu=$TERMUX_ARCH"
	fi

	TCC_CONFIG="$TCC_CONFIG --config-Android --config-new-dtags"

	if [ "${TERMUX_ARCH}" != "i686" ]; then
		TCC_CONFIG="$TCC_CONFIG --config-pie"
	fi

	(
		# hope to find 'include' there
		local NDK_SYSROOT="${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr"

		unset CC CFLAGS LDFLAGS
		# make runtime (libtcc1.a and b*.o) for target
		./configure \
			$TCC_CONFIG \
			--sysroot="$NDK_SYSROOT" \
			--sysincludepaths="{B}/include:{R}/include/$TERMUX_HOST_PLATFORM:{R}/include"

		make -j $TERMUX_MAKE_PROCESSES libtcc1.a
	)

	# cross-compile tcc for target
	./configure \
		--cross-prefix="${CC%-*}-" --cc="${CC##*-}" \
		$TCC_CONFIG \
		--prefix="$TERMUX_PREFIX" \
		--sysroot="$TERMUX_PREFIX" \
		--disable-rpath \
		--disable-static \
		--sysincludepaths="{B}/include:{R}/include/$TERMUX_HOST_PLATFORM:{R}/include" \
		--libpaths="{B}:{R}/lib:$ANDROID_LIB_PATH" \
		--crtprefix="{R}/lib" \
		--elfinterp="$ELF_INTERPRETER_PATH" \
		--tcc-switches="-Wl,-rpath=$TERMUX_PREFIX/lib,-section-alignment=0x1000"

	# override AR from config.mak and LIBS (-lpthread not needed)
	make -j ${TERMUX_MAKE_PROCESSES} tcc AR="$AR" LIBS="-lm -ldl"
	make doc
}

termux_step_make_install() {

	make install
}
