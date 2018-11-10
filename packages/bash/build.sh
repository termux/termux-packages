TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/bash/
TERMUX_PKG_DESCRIPTION="A sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh)"
TERMUX_PKG_DEPENDS="ncurses, readline, libandroid-support, termux-tools, command-not-found"
_MAIN_VERSION=4.4
_PATCH_VERSION=23
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=d86b3392c1202e8ff5a423b302e6284db7f8f435ea9f39b5b1b20fd3ac36dfcb
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/bash/bash-${_MAIN_VERSION}.tar.gz
TERMUX_PKG_ESSENTIAL=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-multibyte --without-bash-malloc --with-installed-readline ac_cv_header_grp_h=no ac_cv_rl_version=7.0"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_job_control_missing=present"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_sys_siglist=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_func_sigsetjmp=present"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_unusable_rtsigs=no"
# Use bash_cv_dev_fd=whacky to use /proc/self/fd instead of /dev/fd.
# After making this change process substitution such as in 'cat <(ls)' works.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_dev_fd=whacky"
# Bash assumes that getcwd is broken and provides a wrapper which
# does not work when not all parent directories up to root are
# accessible, which they are not under Android (/data). See
# - http://permalink.gmane.org/gmane.linux.embedded.yocto.general/25204
# - https://github.com/termux/termux-app/issues/200
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_getcwd_malloc=yes"

TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1/bashbug.1 bin/bashbug"

termux_step_pre_configure () {
	declare -A PATCH_CHECKSUMS
	PATCH_CHECKSUMS[001]=3e28d91531752df9a8cb167ad07cc542abaf944de9353fe8c6a535c9f1f17f0f
	PATCH_CHECKSUMS[002]=7020a0183e17a7233e665b979c78c184ea369cfaf3e8b4b11f5547ecb7c13c53
	PATCH_CHECKSUMS[003]=51df5a9192fdefe0ddca4bdf290932f74be03ffd0503a3d112e4199905e718b2
	PATCH_CHECKSUMS[004]=ad080a30a4ac6c1273373617f29628cc320a35c8cd06913894794293dc52c8b3
	PATCH_CHECKSUMS[005]=221e4b725b770ad0bb6924df3f8d04f89eeca4558f6e4c777dfa93e967090529
	PATCH_CHECKSUMS[006]=6a8e2e2a6180d0f1ce39dcd651622fb6d2fd05db7c459f64ae42d667f1e344b8
	PATCH_CHECKSUMS[007]=de1ccc07b7bfc9e25243ad854f3bbb5d3ebf9155b0477df16aaf00a7b0d5edaf
	PATCH_CHECKSUMS[008]=86144700465933636d7b945e89b77df95d3620034725be161ca0ca5a42e239ba
	PATCH_CHECKSUMS[009]=0b6bdd1a18a0d20e330cc3bc71e048864e4a13652e29dc0ebf3918bea729343c
	PATCH_CHECKSUMS[010]=8465c6f2c56afe559402265b39d9e94368954930f9aa7f3dfa6d36dd66868e06
	PATCH_CHECKSUMS[011]=dd56426ef7d7295e1107c0b3d06c192eb9298f4023c202ca2ba6266c613d170d
	PATCH_CHECKSUMS[012]=fac271d2bf6372c9903e3b353cb9eda044d7fe36b5aab52f21f3f21cd6a2063e
	PATCH_CHECKSUMS[013]=1b25efacbc1c4683b886d065b7a089a3601964555bcbf11f3a58989d38e853b6
	PATCH_CHECKSUMS[014]=a7f75cedb43c5845ab1c60afade22dcb5e5dc12dd98c0f5a3abcfb9f309bb17c
	PATCH_CHECKSUMS[015]=d37602ecbeb62d5a22c8167ea1e621fcdbaaa79925890a973a45c810dd01c326
	PATCH_CHECKSUMS[016]=501f91cc89fadced16c73aa8858796651473602c722bb29f86a8ba588d0ff1b1
	PATCH_CHECKSUMS[017]=773f90b98768d4662a22470ea8eec5fdd8e3439f370f94638872aaf884bcd270
	PATCH_CHECKSUMS[018]=5bc494b42f719a8b0d844b7bd9ad50ebaae560e97f67c833c9e7e9d53981a8cc
	PATCH_CHECKSUMS[019]=27170d6edfe8819835407fdc08b401d2e161b1400fe9d0c5317a51104c89c11e
	PATCH_CHECKSUMS[020]=1840e2cbf26ba822913662f74037594ed562361485390c52813b38156c99522c
	PATCH_CHECKSUMS[021]=bd8f59054a763ec1c64179ad5cb607f558708a317c2bdb22b814e3da456374c1
	PATCH_CHECKSUMS[022]=45331f0936e36ab91bfe44b936e33ed8a1b1848fa896e8a1d0f2ef74f297cb79
	PATCH_CHECKSUMS[023]=4fec236f3fbd3d0c47b893fdfa9122142a474f6ef66c20ffb6c0f4864dd591b6

	for patch_number in `seq -f '%03g' ${_PATCH_VERSION}`; do
		PATCHFILE=$TERMUX_PKG_CACHEDIR/bash_patch_${patch_number}.patch
		termux_download \
			"https://mirrors.kernel.org/gnu/bash/bash-4.4-patches/bash44-$patch_number" \
			$PATCHFILE \
			${PATCH_CHECKSUMS[$patch_number]}
		patch -p0 -i $PATCHFILE
	done
}

termux_step_post_make_install () {
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" $TERMUX_PKG_BUILDER_DIR/etc-profile > $TERMUX_PREFIX/etc/profile
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		$TERMUX_PKG_BUILDER_DIR/etc-profile | \
		sed "s|@TERMUX_HOME@|$TERMUX_ANDROID_HOME|" > \
		$TERMUX_PREFIX/etc/profile
	# /etc/bash.bashrc - System-wide .bashrc file for interactive shells. (config-top.h in bash source, patched to enable):
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		$TERMUX_PKG_BUILDER_DIR/etc-bash.bashrc > \
		$TERMUX_PREFIX/etc/bash.bashrc
}
