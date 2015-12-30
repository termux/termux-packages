TERMUX_PKG_HOMEPAGE="http://www.zsh.org/"
TERMUX_PKG_DESCRIPTION="Shell designed for interactive use, although it is also a powerful scripting language"
_FOLDERVERSION=5.2
TERMUX_PKG_VERSION=${_FOLDERVERSION}.0
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/zsh/zsh/$_FOLDERVERSION/zsh-${_FOLDERVERSION}.tar.xz
TERMUX_PKG_RM_AFTER_INSTALL="bin/zsh-${_FOLDERVERSION}"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, termux-tools, command-not-found"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-etcdir=$TERMUX_PREFIX/etc --disable-gdbm --disable-pcre ac_cv_header_utmp_h=no"

# Below needed to force dynamically loaded binary modules, but does not currently work:
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" zsh_cv_shared_environ=yes"

termux_step_post_configure () {
	# INSTALL file: "For a non-dynamic zsh, the default is to compile the complete, compctl, zle,
	# computil, complist, sched, # parameter, zleparameter and rlimits modules into the shell,
	# and you will need to edit config.modules to make any other modules available."
	# Since we build zsh non-dynamically (since dynamic loading doesn't work on Android when enabled),
	# we need to explicitly enable the additional modules we want.
	# - The files module is needed by `compinstall`, see https://github.com/termux/termux-packages/issues/61:
	perl -p -i -e "s|files.mdd link=no|files.mdd link=static|" $TERMUX_PKG_BUILDDIR/config.modules
}

termux_step_post_make_install () {
	# /etc/zshrc - Run for interactive shells (http://zsh.sourceforge.net/Guide/zshguide02.html):
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" $TERMUX_PKG_BUILDER_DIR/etc-zshrc > $TERMUX_PREFIX/etc/zshrc

	# Remove zsh.new/zsh.old/zsh-$version if any exists:
	rm -f $TERMUX_PREFIX/{zsh-*,zsh.*}

	# This should perhaps be done in a more general way? Doing it here
	# to silence "compaudit" warnings:
	chmod 700 $TERMUX_PREFIX/share/{zsh,zsh/$_FOLDERVERSION}
}

termux_step_create_debscripts () {
	# For already installed packages:
	echo "chmod 700 $TERMUX_PREFIX/share/zsh" > postinst
        echo "exit 0" >> postinst
        chmod 0755 postinst
}
