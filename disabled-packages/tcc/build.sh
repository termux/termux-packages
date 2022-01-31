TERMUX_PKG_HOMEPAGE=https://bellard.org/tcc/
TERMUX_PKG_DESCRIPTION="Tiny C Compiler"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:0.9.27
TERMUX_PKG_REVISION=10
TERMUX_PKG_SRCURL=https://repo.or.cz/tinycc.git/snapshot/fef838db2d124db3f1357385972371ccba7af2c6.tar.gz
TERMUX_PKG_SHA256=f6a022994b9903485a1777540c0c9e0571990fc339a2b325be6127b616534f33
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_configure() {
	unset CFLAGS CXXFLAGS

	if [ "${TERMUX_ARCH}" = "arm" ] || [ "${TERMUX_ARCH}" = "i686" ]; then
		ELF_INTERPRETER_PATH="/system/bin/linker"
		ANDROID_LIB_PATH="/system/lib:/system/vendor/lib"
	else
		ELF_INTERPRETER_PATH="/system/bin/linker64"
		ANDROID_LIB_PATH="/system/lib64:/system/vendor/lib64"
	fi
}

termux_step_make() {
	(
		unset CC CFLAGS LDFLAGS
		./configure --prefix="/tmp/tcc.host" --cpu="${TERMUX_ARCH}"
		make -j $TERMUX_MAKE_PROCESSES tcc
		mv -f tcc tcc.host
		make distclean
	)

	./configure \
		--prefix="$TERMUX_PREFIX" \
		--cross-prefix="${CC//clang}" \
		--cc="clang" \
		--cpu="$TERMUX_ARCH" \
		--disable-rpath \
		--elfinterp="$ELF_INTERPRETER_PATH" \
		--crtprefix="$TERMUX_PREFIX/lib/tcc/crt" \
		--sysincludepaths="$TERMUX_PREFIX/include:$TERMUX_PREFIX/lib/tcc/include" \
		--libpaths="$TERMUX_PREFIX/lib:$TERMUX_PREFIX/lib/tcc:$ANDROID_LIB_PATH"

	mv tcc.host tcc
	touch -d "next minute" tcc
	make -j ${TERMUX_MAKE_PROCESSES} libtcc1.a

	rm -f tcc
	make -j ${TERMUX_MAKE_PROCESSES} tcc

	make install

	for file in crtbegin_dynamic.o crtbegin_so.o crtend_android.o crtend_so.o; do
		install -Dm600 \
			"${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/$file" \
			"${TERMUX_PREFIX}/lib/tcc/crt/$file"
	done
}
