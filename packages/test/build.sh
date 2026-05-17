TERMUX_PKG_DESCRIPTION="empty test packet for build system "
TERMUX_PKG_VERSION=0
TERMUX_PKG_LICENSE="WTFPL"
TERMUX_PKG_NO_ELF_CLEANER=true

# test_system=auto
# test_system=meson
test_system=rust

termux_step_post_get_source() {
	case $test_system in
		auto)
			cp  $TERMUX_PKG_BUILDER_DIR/{configure.ac,Makefile.am,test.c} $TERMUX_PKG_SRCDIR/
			;;
		meson)
			cp  $TERMUX_PKG_BUILDER_DIR/test.c $TERMUX_PKG_SRCDIR/
			cp  $TERMUX_PKG_BUILDER_DIR/meson.build $TERMUX_PKG_SRCDIR/
			;;
		rust)
			cp  $TERMUX_PKG_BUILDER_DIR/Cargo.toml $TERMUX_PKG_BUILDDIR/
			cp  $TERMUX_PKG_BUILDER_DIR/test.rs $TERMUX_PKG_SRCDIR/
			;;
	esac
}

termux_step_pre_configure() {
	:
	set +e
	pwd
	# exit
	# tree
	(echo CC=$CC)
	(echo CXXFLAGS=$CXXFLAGS)
	# CC=gcc
	# exit

# tree $TERMUX_PKG_MASSAGEDIR
# exit

# echo $TERMUX_PREFIX
# echo $TERMUX_PREFIX_CLASSICAL
# echo $TERMUX_TOPDIR
# exit
$TERMUX_FAST_BUILD && echo fast build detected
# $TERMUX_PKG_PROOT && echo proot build detected
$TERMUX_SAFE_BUILD && echo safe build detected
# exit
# $TERMUX_ON_DEVICE_BUILD && test TERMUX_PREFIX = TERMUX_PREFIX_CLASSICAL && echo unsafe prefix detected && exit
# pwd
# touch a
# touch configure.in
# exit
set -e

case $test_system in
	auto)
		autoreconf -fi
		;;
esac

# ack CXXFLAGS
}

termux_step_post_configure() {
	pwd
	# mkdir bin etc -vp
	# echo prefix=$TERMUX_PREFIX_INSTALL | tee etc/a
	# touch bin/b

# mkdir man
# touch man/c

tree $TERMUX_PKG_MASSAGEDIR
}

termux_step_post_make_install() {
	pwd

tree $TERMUX_PKG_MASSAGEDIR
# exit

	# echo base=$TERMUX_PKG_MASSAGEDIR_BASE
	# exit
	# mkdir -p $TERMUX_PREFIX_INSTALL
	# mkdir -p $TERMUX_PKG_MASSAGEDIR_PAK

	# install results
	# mkdir -p $TERMUX_PKG_MASSAGEDIR_BASE
	# cp $TERMUX_PKG_BUILDDIR/{bin,etc} $TERMUX_PKG_MASSAGEDIR_BASE/ -r
	# cp $TERMUX_PKG_BUILDDIR/* $TERMUX_PREFIX_INSTALL/ -rv
# install -Dm700 -t $TERMUX_PREFIX/ $TERMUX_PKG_SRCDIR/a
	# cp $TERMUX_PKG_BUILDDIR/*android/release/test $TERMUX_PKG_MASSAGEDIR_BASE/bin/
echo install done
echo

# cat $TERMUX_PKG_SRCDIR/configure.in
}

termux_step_post_massage() {
	set +e
	pwd
	echo massage folder tree:
	tree
	# tree $TERMUX_PKG_MASSAGEDIR
	cat etc/a
	# env | sort | ack ANDROID
	# env | sort | ack CFLAG
	(echo CC=$CC)
	echo ==:==:==:==
	bin/test*
	echo ==*==*==*==
	echo build done
	set -e
}
