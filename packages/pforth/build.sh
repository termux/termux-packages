TERMUX_PKG_HOMEPAGE=http://www.softsynth.com/pforth/
TERMUX_PKG_DESCRIPTION="Portable Forth in C"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=1aa4eb4976630fdb6882bb3aacb97aa09f69571e
TERMUX_PKG_VERSION=20211129
TERMUX_PKG_SRCURL=https://github.com/philburk/pforth/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=f06e5142d37c203a706057b303db18494919069583414731e2578ac374c01f61
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_host_build() {
	termux_setup_cmake

	cp -a $TERMUX_PKG_SRCDIR/* .

	mkdir -p 32bit
	# Add -Wno-shift-count-overflow to ignore:
	# /home/builder/.termux-build/pforth/src/csrc/pf_save.c:223:34: error: right shift count >= width of type [-Werror=shift-count-overflow
	#   223 |         *addr++ = (uint8_t) (data>>56);
	#       |                                  ^~
	CC="gcc -m32" CFLAGS="-Wno-shift-count-overflow" cmake .
	make
	install -m700 fth/pforth 32bit/
	install -m600 csrc/pfdicdat.h 32bit/

	rm -rf CMakeCache.txt CMakeFiles

	mkdir -p 64bit
	cmake .
	make
	install -m700 fth/pforth 64bit/
	install -m600 csrc/pfdicdat.h 64bit/
}

termux_step_post_configure() {
	if [ $TERMUX_ARCH_BITS = "32" ]; then
		local folder=32bit
	else
		local folder=64bit
	fi
	cp $TERMUX_PKG_HOSTBUILD_DIR/$folder/pforth fth/
	cp $TERMUX_PKG_HOSTBUILD_DIR/$folder/pfdicdat.h csrc/
}

termux_step_make_install() {
	install -m700 fth/pforth_standalone $TERMUX_PREFIX/bin/pforth
}
