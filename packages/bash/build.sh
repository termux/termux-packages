TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/bash/
TERMUX_PKG_DESCRIPTION="A sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION=5.3.15
TERMUX_PKG_REVISION=9
TERMUX_PKG_KEEP_SHARE_LOCALE=true
TERMUX_PKG_SRCURL="https://mirrors.kernel.org/gnu/bash/bash-${TERMUX_PKG_VERSION%.*}.tar.gz"
TERMUX_PKG_SHA256=0d5cd86965f869a26cf64f4b71be7b96f90a3ba8b3d74e27e8e9d9d5550f31ba
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, readline (>= 8.3), termux-tools, libintl"
TERMUX_PKG_RECOMMENDS="command-not-found, bash-completion"
TERMUX_PKG_BREAKS="bash-dev"
TERMUX_PKG_REPLACES="bash-dev"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-nls --enable-multibyte --without-bash-malloc --with-installed-readline --enable-progcomp --with-libintl-prefix=$TERMUX_PREFIX"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" gt_cv_func_dgettext_libc=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" gt_cv_func_dgettext_libintl=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" gt_cv_func_gnugettext_libintl=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_mblen=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_setgrent=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_getgrent=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_endgrent=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_job_control_missing=present"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_sys_siglist=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_func_sigsetjmp=present"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_unusable_rtsigs=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_mbsnrtowcs=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_getdtablesize=no"
# Use bash_cv_dev_fd=whacky to use /proc/self/fd instead of /dev/fd.
# After making this change process substitution such as in 'cat <(ls)' works.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_dev_fd=whacky"
# Bash assumes that getcwd is broken and provides a wrapper which
# does not work when not all parent directories up to root are
# accessible, which they are not under Android (/data). See
# - http://permalink.gmane.org/gmane.linux.embedded.yocto.general/25204
# - https://github.com/termux/termux-app/issues/200
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_getcwd_malloc=yes"

TERMUX_PKG_CONFFILES="etc/bash.bashrc etc/profile"

TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1/bashbug.1 bin/bashbug"

termux_step_pre_configure() {
	CPPFLAGS+=" -I$TERMUX_PREFIX/include"
	LDFLAGS+=" -lintl"
	sed -i 's/getdtablesize ()/sysconf(_SC_OPEN_MAX)/g' examples/loadables/fdflags.c
	sed -i 's/internal_warning.*setlocale.*/(void)0;/g' locale.c
	sed -i 's/locale_mb_cur_max = MB_CUR_MAX;/locale_mb_cur_max = 4; locale_utf8locale = 1;/g' locale.c
	sed -i 's/locale_isutf8 (char \*lspec)/locale_isutf8 (char *lspec) { return 1; } static int _disabled_locale_isutf8 (char *lspec)/g' locale.c
	sed -i "s/zmieni'c/zmienić/g" po/pl.po
	local _MAIN_VERSION="${TERMUX_PKG_VERSION%.*}" _PATCH_VERSION="${TERMUX_PKG_VERSION##*.}"
	(( _PATCH_VERSION == 0 )) && return
	local PATCH_NUM PATCHFILE
	local -A PATCH_CHECKSUMS=()

	PATCH_CHECKSUMS[001]=1f608434364af86b9b45c8b0ea3fb3b165fb830d27697e6cdfc7ac17dee3287f
	PATCH_CHECKSUMS[002]=e385548a00130765ec7938a56fbdca52447ab41fabc95a25f19ade527e282001
	PATCH_CHECKSUMS[003]=f245d9c7dc3f5a20d84b53d249334747940936f09dc97e1dcb89fc3ab37d60ed
	PATCH_CHECKSUMS[004]=9591d245045529f32f0812f94180b9d9ce9023f5a765c039b852e5dfc99747d0
	PATCH_CHECKSUMS[005]=cca1ef52dbbf433bc98e33269b64b2c814028efe2538be1e2c9a377da90bc99d
	PATCH_CHECKSUMS[006]=29119addefed8eff91ae37fd51822c31780ee30d4a28376e96002706c995ff10
	PATCH_CHECKSUMS[007]=c0976bbfffa1453c7cfdd62058f206a318568ff2d690f5d4fa048793fa3eb299
	PATCH_CHECKSUMS[008]=097cd723cbfb8907674ac32214063a3fd85282657ec5b4e544d2c0f719653fb4
	PATCH_CHECKSUMS[009]=eee30fe78a4b0cb2fe20e010e00308899cfc613e0774ebb3c8557a1552f24f8c
	PATCH_CHECKSUMS[010]=cf76f1cce2ea300c18bff9f002d21f280cc931acd17c28518110b93fe6e72569
	PATCH_CHECKSUMS[011]=0298df8f5ea2a31d3be43ed7d269c5b3c7c342dd5b570bea7f64d66dcbbe7531
	PATCH_CHECKSUMS[012]=d71379b39bebaedaf123414414e77fb458a0a43b9ad3116594c6df7ca6754573
	PATCH_CHECKSUMS[013]=042f9cda967e24bf4211944697441e93d06ff42b4b998629a98a1b249279f200
	PATCH_CHECKSUMS[014]=bd4360b401d38507e358783dcad8536a99c6789f0d3a5bd0cfb8c4a34144696c
	PATCH_CHECKSUMS[015]=55b79ceee2fc27f6767eed697e939a7eb2fe2a28c01556bd75f18d581014f46e

	for PATCH_NUM in $(seq -f '%03g' "${_PATCH_VERSION}"); do
		PATCHFILE=$TERMUX_PKG_CACHEDIR/bash_patch_${PATCH_NUM}.patch
		termux_download \
			"https://mirrors.kernel.org/gnu/bash/bash-${_MAIN_VERSION}-patches/bash${_MAIN_VERSION/./}-$PATCH_NUM" \
			"$PATCHFILE" \
			"${PATCH_CHECKSUMS[$PATCH_NUM]}"
		patch -p0 -i "$PATCHFILE"
	done
	# Bash tries to redefine bool keyword which breaks with GCC 15, so use Clang for
	# build (the binaries that are run on the builder)
	export CC_FOR_BUILD="clang-${TERMUX_HOST_LLVM_MAJOR_VERSION}"
}

termux_step_post_configure() {
	sed -i 's|lib/intl/libintl.a|-lintl|g' Makefile
	sed -i 's|INTL_LIB = .*|INTL_LIB = -lintl|g' Makefile
	sed -i 's|INTL_LIBRARY = .*|INTL_LIBRARY =|g' Makefile
	sed -i 's|INTL_DEP = .*|INTL_DEP =|g' Makefile
	sed -i 's|INTL_INC = .*|INTL_INC = -I'$TERMUX_PREFIX'/include|g' Makefile
	sed -i 's|LIBINTL_H = .*|LIBINTL_H = '$TERMUX_PREFIX'/include/libintl.h|g' Makefile

	cat << 'EOF' >> config.h
#ifdef __ANDROID__
#ifndef BASH_BIONIC_COMPAT_H
#define BASH_BIONIC_COMPAT_H
#include <wchar.h>
#include <stdlib.h>
#include <grp.h>
static inline void bash_bionic_setgrent(void) {}
static inline struct group *bash_bionic_getgrent(void) { return (struct group *)0; }
static inline void bash_bionic_endgrent(void) {}
#define setgrent bash_bionic_setgrent
#define getgrent bash_bionic_getgrent
#define endgrent bash_bionic_endgrent
static inline int bash_bionic_mblen(const char *s, size_t n) {
	return (int)mbrlen(s, n, NULL);
}
#define mblen bash_bionic_mblen
#endif
#endif
EOF
}

termux_step_post_make_install() {
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@TERMUX_HOME@|$TERMUX_ANDROID_HOME|g" \
		"$TERMUX_PKG_BUILDER_DIR/etc-profile" > "$TERMUX_PREFIX/etc/profile"

	# /etc/bash.bashrc - System-wide .bashrc file for interactive shells. (config-top.h in bash source, patched to enable):
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@TERMUX_HOME@|$TERMUX_ANDROID_HOME|g" \
		"$TERMUX_PKG_BUILDER_DIR/etc-bash.bashrc" > "$TERMUX_PREFIX/etc/bash.bashrc"
}
