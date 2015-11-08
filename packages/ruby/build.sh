TERMUX_PKG_HOMEPAGE=https://www.ruby-lang.org/
TERMUX_PKG_DESCRIPTION="Dynamic programming language with a focus on simplicity and productivity"
_MAJOR_VERSION=2.2
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://cache.ruby-lang.org/pub/ruby/${_MAJOR_VERSION}/ruby-${TERMUX_PKG_VERSION}.tar.xz
# libbffi is used by the fiddle extension module:
TERMUX_PKG_DEPENDS="libffi, libgmp, readline, openssl"
TERMUX_PKG_KEEP_HEADER_FILES="true"
# Needed to fix compilation on android:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_setgroups=no ac_cv_func_setresuid=no ac_cv_func_setreuid=no --enable-rubygems"

# Ruby does not use this directly, but specify for gem building C++-using extensions:
CXXFLAGS+=" -frtti -fexceptions" # -lgnustl_shared"

termux_step_pre_configure () {
	export GEM_HOME=$TERMUX_PREFIX/var/lib/gems
	mkdir -p $GEM_HOME
}

termux_step_make_install () {
	make install
	make uninstall # remove possible remains to get fresh timestamps
	make install

        # rbconfig.rb, used to build native gems, thinks that ${TERMUX_HOST_PLATFORM}-gcc should
        # be used, but we want normal gcc
        local RBCONFIG=$TERMUX_PREFIX/lib/ruby/${_MAJOR_VERSION}.0/arm-linux-androideabi/rbconfig.rb
        for tool in gcc "g\+\+" strip nm objdump ar ranlib ld cpp; do
          perl -p -i -e "s/${TERMUX_HOST_PLATFORM}-$tool/$tool/g" $RBCONFIG
        done
        perl -p -i -e 's@"/bin/mkdir@"/system/bin/mkdir@' $RBCONFIG
        perl -p -i -e "s@/usr/bin/install@$TERMUX_PREFIX/bin/applets/install@" $RBCONFIG
        # Make C++-using gems link against libgnustl_shared instead of the limited system libstdc++:
        perl -p -i -e 's/\(CXX\) -shared/\(CXX\) -shared -lgnustl_shared/' $RBCONFIG
}


# FIXME: 
#       ruby -e 'p Encoding::default_external'
# prints US-ASCII
