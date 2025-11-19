TERMUX_PKG_HOMEPAGE=https://salsa.debian.org/debian/apt-show-versions
TERMUX_PKG_DESCRIPTION="Lists available package versions with distribution"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.22.16"
TERMUX_PKG_SRCURL="https://salsa.debian.org/debian/apt-show-versions/-/archive/$TERMUX_PKG_VERSION/apt-show-versions-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=15308503b113209a551e495f9ca8cf002acf8d3e4ce31df58e1fcc4fa7713310
TERMUX_PKG_DEPENDS="apt, libapt-pkg-perl, perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
PREFIX=$TERMUX_PREFIX
INSTALLSITEMAN1DIR=$TERMUX_PREFIX/share/man/man1
INSTALLSITEMAN3DIR=$TERMUX_PREFIX/share/man/man3
"

# for some reason, make install installs some weird files in lib,
# then before the package is finalized, the lib folder needs to be removed.
# this behavior and build process is identifiable as intended, since it is
# ported directly from the behavior of the Debian build script:
# https://salsa.debian.org/debian/apt-show-versions/-/blob/c500448e886a96f75770bbb59570e95c8e77802c/debian/rules#L61
TERMUX_PKG_RM_AFTER_INSTALL="lib"
# install step may pollute lib folder with weird perl files
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

# the original creator of perl.makemaker decided in 2003 that formal accomodation
# of distros like Termux that can be described as "distros with timestamp-based packaging systems"
# is undesirable because such a distro was either unheard of to them at the time, or
# they imagined the hypothetical possibility of the present or future existence of such a distro
# as an unsupportable edge case,
# so the Makefile that perl.makemaker generates will not reliably install everything
# unless all desired files are forcibly removed before make install is invoked
# https://www.nntp.perl.org/group/perl.makemaker/2003/04/msg1092.html

# files that should be in $TERMUX_PREFIX after make install
_MAKE_INSTALL_PROVIDED_FILES="
bin/apt-show-versions
share/man/man1/apt-show-versions.1p
"

termux_step_pre_configure() {
	pushd "$TERMUX_PREFIX"
	rm -f $_MAKE_INSTALL_PROVIDED_FILES
	popd
}

# termux_step_configure() for Makefile.PLs based on package perl-rename
termux_step_configure() {
	perl Makefile.PL $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_post_make_install() {
	install -D --mode=644 "$TERMUX_PKG_SRCDIR/debian/apt-show-versions.apt.conf" \
		"$TERMUX_PREFIX/etc/apt/apt.conf.d/20apt-show-versions"

	install -D --mode=644 "$TERMUX_PKG_SRCDIR/debian/apt-show-versions.bash-completion" \
		"$TERMUX_PREFIX/share/bash-completion/completions/apt-show-versions"
}

termux_step_create_debscripts() {
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "debian" ] && [ "\$1" != "configure" ]; then
		exit 0
	fi
	echo "** initializing cache. This may take a while **"
	apt-show-versions -i
	exit 0
	POSTINST_EOF

	cat <<- PRERM_EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "debian" ] && [ "\$1" != "remove" ]; then
		exit 0
	fi
	rm -rf $TERMUX_PREFIX/var/cache/apt-show-versions
	exit 0
	PRERM_EOF
}
