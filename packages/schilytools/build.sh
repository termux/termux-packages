TERMUX_PKG_HOMEPAGE=https://codeberg.org/schilytools/schilytools
TERMUX_PKG_DESCRIPTION="A collection of tools written or formerly managed by Jörg Schilling"
TERMUX_PKG_LICENSE="BSD, BSD 2-Clause, BSD 3-Clause, CDDL-1.0, GPL-2.0-or-later, LGPL-2.1-or-later, MIT"
TERMUX_PKG_LICENSE_FILE="
patch/LICENSE
libfile/LEGAL.NOTICE
CDDL.Schily.txt
GPL-2.0.txt
LGPL-2.1.txt
"
TERMUX_PKG_MAINTAINER="@termux-user-repository"
TERMUX_PKG_VERSION="2024-03-21"
# upstream requests in release notes to use this mirror to obtain release tarball
TERMUX_PKG_SRCURL="https://schilytools.pkgsrc.pub/pub/schilytools/schily-$TERMUX_PKG_VERSION.tar.bz2"
TERMUX_PKG_SHA256=76db022e450c1791a00e69780b55d18a2e3fc39b5ff870996433f87312032024
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		termux_error_exit "This package is extremely hard to cross-compile. If you know how, please help!"
	fi

	mv rmt/{,s}rmt.dfl
	mv rmt/default-{,s}rmt.sample

	# make sure most of the programs go to $TERMUX_PREFIX/bin
	sed -i "s|/opt/schily|$TERMUX_PREFIX|g" DEFAULTS/Defaults.linux
	sed -i 's|INSDIR=\s*sbin|INSDIR=bin|' rscsi/Makefile

	find "$TERMUX_PKG_SRCDIR" -type f | xargs -n 1 sed -i \
		-e "s|/etc|$TERMUX_PREFIX/etc|g" \
		-e "s|/tmp|$TERMUX_PREFIX/tmp|g"

	LDFLAGS+=" -landroid-shmem"
}

termux_step_configure() {
	if [[ "$TERMUX_PKG_API_LEVEL" -lt 26 ]]; then
		export ac_cv_func_sigset=no
		export ac_cv_func_getdomainname=no
	else
		export ac_cv_func_sigset=yes
		export ac_cv_func_getdomainname=yes
	fi

	# normal Android 7 does not have getgrent,
	# but it is implemented as a stub in Termux
	# in ndk-patches/28c/grp.h.patch
	export ac_cv_func_getgrent=yes
	export ac_cv_func_setgrent=yes
	export ac_cv_func_endgrent=yes

	# polyfilled using android-no-getloadavg.patch
	export ac_cv_func_getloadavg=yes

	# All android have valloc implemented in libc.so,
	# but it is disabled in headers for Android 5 and newer
	export ac_cv_func_valloc=no

	# Fix 'Bad system call'
	export ac_cv_func_setreuid=no
	export ac_cv_func_setresuid=no
	export ac_cv_func_seteuid=no
	export ac_cv_func_setuid=no
	export ac_cv_func_setregid=no
	export ac_cv_func_setresgid=no
	export ac_cv_func_setegid=no
	export ac_cv_func_setgid=no
	export ac_cv_func_setpgid=no
}

termux_step_make() {
	make \
		INS_BASE="$TERMUX_PREFIX" \
		INS_RBASE="$TERMUX_PREFIX" \
		VERSION_OS="_Termux" \
		CCOM=clang \
		CC="$CC" \
		CCC="$CXX" \
		COPTX="$CFLAGS" \
		C++OPTX="$CXXFLAGS" \
		LDOPTX="$LDFLAGS"
}

termux_step_make_install() {
	make \
		INS_BASE="$TERMUX_PREFIX" \
		INS_RBASE="$TERMUX_PREFIX" \
		install
}

termux_step_post_make_install() {
	# move some stuff out of direct subfolders of $TERMUX_PREFIX
	rm -rf "$TERMUX_PREFIX/opt/schily"
	mkdir -p "$TERMUX_PREFIX/opt/schily"
	mv "$TERMUX_PREFIX/ccs" "$TERMUX_PREFIX/opt/schily/"
	mv "$TERMUX_PREFIX/xpg4" "$TERMUX_PREFIX/opt/schily/"
	ln -sf "$TERMUX_PREFIX/opt/schily/ccs/bin/sccs" "$TERMUX_PREFIX/bin/sccs"
	ln -sf rmchg "$TERMUX_PREFIX/opt/schily/ccs/bin/cdc"
	ln -sf rmchg "$TERMUX_PREFIX/opt/schily/ccs/bin/rmdel"
	ln -sf unget "$TERMUX_PREFIX/opt/schily/ccs/bin/sact"
	ln -sf "$TERMUX_PREFIX/bin/spatch" "$TERMUX_PREFIX/opt/schily/ccs/bin/sccspatch"

	# Create symlinks for cdrkit compatibility
	ln -sf cdrecord "$TERMUX_PREFIX/bin/wodim"
	ln -sf readcd "$TERMUX_PREFIX/bin/readom"
	ln -sf mkisofs "$TERMUX_PREFIX/bin/genisoimage"
	ln -sf cdda2wav "$TERMUX_PREFIX/bin/icedax"
}
