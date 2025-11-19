TERMUX_PKG_HOMEPAGE=https://bellard.org/tcc/
TERMUX_PKG_DESCRIPTION="Tiny C Compiler"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=6a24b762d3e1086dcffd002c68cb5ca3a33a5c6d
_COMMIT_DATE=20230415
TERMUX_PKG_VERSION=1:0.9.27-p${_COMMIT_DATE}
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=git+https://repo.or.cz/tinycc.git
TERMUX_PKG_SHA256=467792219d0172f594ec71bcd6bac9dbb25308cbe9f708bab455b717148b491b
TERMUX_PKG_GIT_BRANCH=mob
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

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

termux_step_pre_configure() {
	cd $TERMUX_PKG_BUILDDIR
	rm -rf _bin
	mkdir _bin
	cd _bin
	local _ar="$TERMUX_HOST_PLATFORM-ar"
	cat > "${_ar}" <<-EOF
		#!$(command -v sh)
		exec $(command -v $AR) "\$@"
	EOF
	chmod 0700 "${_ar}"
	export PATH="$(pwd):$PATH"
}

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
		sysinc=
		otherinc=
		for d in $(echo | $CC -E -x c - -v 2>&1 | \
				sed -n '/^#include <...> search/,/^End/p' | \
				grep '^\s'); do
			p="$(readlink -f "${d}"):"
			if [[ "${d}" = */sysroot/usr/* ]]; then
				sysinc+="${p}"
			else
				otherinc+="${p}"
			fi
		done
		sysinc="${sysinc}${otherinc%:}"
		unset CC CFLAGS LDFLAGS
		./configure \
			--prefix="/tmp/tcc.host" \
			--cpu="${TERMUX_ARCH}" \
			--sysincludepaths="${sysinc}"
		make -j $TERMUX_PKG_MAKE_PROCESSES tcc
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
		--sysincludepaths="$TERMUX_PREFIX/include/$TERMUX_HOST_PLATFORM:$TERMUX_PREFIX/include:$TERMUX_PREFIX/lib/tcc/include" \
		--libpaths="$TERMUX_PREFIX/lib:$TERMUX_PREFIX/lib/tcc:$ANDROID_LIB_PATH"

	mv tcc.host tcc
	touch -d "next minute" tcc
	make -j ${TERMUX_PKG_MAKE_PROCESSES} libtcc1.a

	rm -f tcc
	make -j ${TERMUX_PKG_MAKE_PROCESSES} tcc
}

termux_step_post_make_install() {
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/lib/tcc/crt
	for file in crtbegin_dynamic.o crtbegin_so.o crtend_android.o crtend_so.o; do
		install -Dm600 \
			"${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/$file" \
			"${TERMUX_PREFIX}/lib/tcc/crt/$file"
	done
}
