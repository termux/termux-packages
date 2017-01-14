TERMUX_PKG_HOMEPAGE=https://www.ruby-lang.org/
TERMUX_PKG_DESCRIPTION="Dynamic programming language with a focus on simplicity and productivity"
_MAJOR_VERSION=2.4
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://cache.ruby-lang.org/pub/ruby/${_MAJOR_VERSION}/ruby-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3a87fef45cba48b9322236be60c455c13fd4220184ce7287600361319bb63690
# libbffi is used by the fiddle extension module:
TERMUX_PKG_DEPENDS="libandroid-support, libffi, libgmp, readline, openssl, libutil"
# Needed to fix compilation on android:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_setgroups=no ac_cv_func_setresuid=no ac_cv_func_setreuid=no --enable-rubygems"
# The gdbm module seems to be very little used:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --without-gdbm"
# Do not link in libcrypt.so if available (now in disabled-packages):
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_lib_crypt_crypt=no"
# Fix DEPRECATED_TYPE macro clang compatibility:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" rb_cv_type_deprecated=x"
# getresuid(2) does not work on ChromeOS - https://github.com/termux/termux-app/issues/147:
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_getresuid=no"

termux_step_pre_configure() {
	export GEM_HOME=$TERMUX_PREFIX/var/lib/gems
	mkdir -p $GEM_HOME
}

termux_step_make_install () {
	make install
	make uninstall # remove possible remains to get fresh timestamps
	make install

	local RBCONFIG=$TERMUX_PREFIX/lib/ruby/${_MAJOR_VERSION}.0/${TERMUX_HOST_PLATFORM}/rbconfig.rb

	# Fix absolute paths to executables:
	perl -p -i -e 's/^.*CONFIG\["INSTALL"\].*$/  CONFIG["INSTALL"] = "install -c"/' $RBCONFIG
	perl -p -i -e 's/^.*CONFIG\["PKG_CONFIG"\].*$/  CONFIG["PKG_CONFIG"] = "pkg-config"/' $RBCONFIG
	perl -p -i -e 's/^.*CONFIG\["MAKEDIRS"\].*$/  CONFIG["MAKEDIRS"] = "mkdir -p"/' $RBCONFIG
	perl -p -i -e 's/^.*CONFIG\["MKDIR_P"\].*$/  CONFIG["MKDIR_P"] = "mkdir -p"/' $RBCONFIG
	perl -p -i -e 's/^.*CONFIG\["EGREP"\].*$/  CONFIG["EGREP"] = "grep -E"/' $RBCONFIG
	perl -p -i -e 's/^.*CONFIG\["GREP"\].*$/  CONFIG["GREP"] = "grep"/' $RBCONFIG

	# Fix mention of $_SPECSFLAG in rbconfig:
	perl -p -i -e "s|${_SPECSFLAG}||g" $RBCONFIG
}

termux_step_post_massage () {
	if [ ! -f $TERMUX_PREFIX/lib/ruby/${_MAJOR_VERSION}.0/${TERMUX_HOST_PLATFORM}/readline.so ]; then
		echo "Error: The readline extension was not built"
	fi
}
