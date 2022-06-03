TERMUX_PKG_HOMEPAGE=https://github.com/tdlib/telegram-bot-api
TERMUX_PKG_DESCRIPTION="Telegram Bot API server "
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.5.5
TERMUX_PKG_SRCURL=https://github.com/tdlib/telegram-bot-api.git
TERMUX_PKG_SHA256=SKIP_CHECKSUM
_COMMIT=8a0f1dd730aa41ab7b792b9ff03d92b1c5022c9f
TERMUX_PKG_GIT_BRANCH="master"
# TERMUX_PKG_SHA256=24ba2c8beae889e6002ea7ced0e29851dee57c27fde8480fb9c64d5eb8765313
# TERMUX_PKG_AUTO_UPDATE=true
# TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
# TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="readline, openssl (>= 1.1.1), zlib"
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
# -DCMAKE_BUILD_TYPE=Release
# -DCMAKE_INSTALL_PREFIX:PATH=$TERMUX_PREFIX
# -DGPERF_PRG=$TERMUX_PKG_HOSTBUILD_DIR/deps/usr/bin/gperf
# -DCMAKE_CROSSCOMPILING=True
# "


termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

}

termux_step_host_build() {
        termux_setup_cmake
        cmake "-DCMAKE_BUILD_TYPE=Release" "$TERMUX_PKG_SRCDIR"
        cmake --build . --target prepare_cross_compiling
}

termux_step_post_make_install() {
	# Fix rebuilds without ./clean.sh.
	rm -rf $TERMUX_PKG_HOSTBUILD_DIR
} 




# termux_step_host_build() {
# 	termux_setup_cmake 
# cd $TERMUX_PKG_SRCDIR 
# #mkdir build_native
# #cd build_native
# mkdir build
# cd build
# cmake ..
# cmake --build . --target prepare_cross_compiling

# }

# termux_step_pre_configure() {
# 	# uftrace uses custom configure script implementation, so we need to provide some flags
# 	# export OPENSSL_INCLUDE_DIR=$TERMUX_PREFIX/include/openssl-1.1
# 	# export OPENSSL_LIB_DIR=$TERMUX_PREFIX/lib/openssl-1.1
# 	CXXFLAGS="-stdlib=libc++ $CXXFLAGS"
	
#      # rm -rf build/
# }

# termux_step_configure () {

# 	termux_setup_cmake
# 	cd $TERMUX_PKG_SRCDIR 
# 	# rm -rf build
# 	# mkdir build
# 	cd build
# 	cmake -DCMAKE_CROSSCOMPILING=True  -DCMAKE_BUILD_TYPE=Release -DZLIB_LIBRARY=$TERMUX_PREFIX/lib/libz.so ..
	
# }


# termux_step_make() {
# 	cd $TERMUX_PKG_SRCDIR 
# 	cd build
#     cmake --build . --target install

# }