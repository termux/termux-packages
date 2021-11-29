TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/bash/
TERMUX_PKG_DESCRIPTION="A sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAIN_VERSION=5.1
_PATCH_VERSION=12
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/bash/bash-${_MAIN_VERSION}.tar.gz
TERMUX_PKG_SHA256=cc012bc860406dcf42f64431bcd3d2fa7560c02915a601aba9cd597a39329baa
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, ncurses, readline (>= 8.0), termux-tools"
TERMUX_PKG_RECOMMENDS="command-not-found"
TERMUX_PKG_BREAKS="bash-dev"
TERMUX_PKG_REPLACES="bash-dev"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-multibyte --without-bash-malloc --with-installed-readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_job_control_missing=present"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_sys_siglist=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_func_sigsetjmp=present"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_unusable_rtsigs=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_mbsnrtowcs=no"
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
	declare -A PATCH_CHECKSUMS

	PATCH_CHECKSUMS[001]=ebb07b3dbadd98598f078125d0ae0d699295978a5cdaef6282fe19adef45b5fa
	PATCH_CHECKSUMS[002]=15ea6121a801e48e658ceee712ea9b88d4ded022046a6147550790caf04f5dbe
	PATCH_CHECKSUMS[003]=22f2cc262f056b22966281babf4b0a2f84cb7dd2223422e5dcd013c3dcbab6b1
	PATCH_CHECKSUMS[004]=9aaeb65664ef0d28c0067e47ba5652b518298b3b92d33327d84b98b28d873c86
	PATCH_CHECKSUMS[005]=cccbb5e9e6763915d232d29c713007a62b06e65126e3dd2d1128a0dc5ef46da5
	PATCH_CHECKSUMS[006]=75e17d937de862615c6375def40a7574462210dce88cf741f660e2cc29473d14
	PATCH_CHECKSUMS[007]=acfcb8c7e9f73457c0fb12324afb613785e0c9cef3315c9bbab4be702f40393a
	PATCH_CHECKSUMS[008]=f22cf3c51a28f084a25aef28950e8777489072628f972b12643b4534a17ed2d1
	PATCH_CHECKSUMS[009]=e45cda953ab4b4b4bde6dc34d0d8ca40d1cc502046eb28070c9ebcd47e33c3ee
	PATCH_CHECKSUMS[010]=a2c8d7b2704eeceff7b1503b7ad9500ea1cb6e9393faebdb3acd2afdd7aeae2a
	PATCH_CHECKSUMS[011]=58191f164934200746f48459a05bca34d1aec1180b08ca2deeee3bb29622027b
	PATCH_CHECKSUMS[012]=10f189c8367c4a15c7392e7bf70d0ff6953f78c9b312ed7622303a779273ab98

	for PATCH_NUM in $(seq -f '%03g' ${_PATCH_VERSION}); do
		PATCHFILE=$TERMUX_PKG_CACHEDIR/bash_patch_${PATCH_NUM}.patch
		termux_download \
			"https://mirrors.kernel.org/gnu/bash/bash-${_MAIN_VERSION}-patches/bash${_MAIN_VERSION/./}-$PATCH_NUM" \
			$PATCHFILE \
			${PATCH_CHECKSUMS[$PATCH_NUM]}
		patch -p0 -i $PATCHFILE
	done
	unset PATCH_CHECKSUMS PATCHFILE PATCH_NUM
}

termux_step_post_make_install() {
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		-e "s|@TERMUX_HOME@|$TERMUX_ANDROID_HOME|" \
		$TERMUX_PKG_BUILDER_DIR/etc-profile > $TERMUX_PREFIX/etc/profile

	# /etc/bash.bashrc - System-wide .bashrc file for interactive shells. (config-top.h in bash source, patched to enable):
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		-e "s|@TERMUX_HOME@|$TERMUX_ANDROID_HOME|" \
		$TERMUX_PKG_BUILDER_DIR/etc-bash.bashrc > $TERMUX_PREFIX/etc/bash.bashrc
}
