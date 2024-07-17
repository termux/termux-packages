TERMUX_PKG_HOMEPAGE=https://github.com/OpenAtomFoundation/pika
TERMUX_PKG_DESCRIPTION="A persistent huge storage service, compatible with the vast majority of Redis interfaces"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5.3
TERMUX_PKG_SRCURL=https://github.com/OpenAtomFoundation/pika/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=80dd6b3d5ace5e123051904f299597b6736b17a1ab4d66168518a36dc7f94edd
TERMUX_PKG_DEPENDS="abseil-cpp, google-glog, libc++, libprotobuf, librocksdb"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_CMAKE_BUILD="Unix Makefiles"

# ```
# [...]/src/pika_set.cc:107:58: error: cannot initialize a parameter of type
# 'long *' with an rvalue of type 'int64_t *' (aka 'long long *')
#   if (!slash::string2l(argv_[2].data(), argv_[2].size(), &cursor_)) {
#                                                          ^~~~~~~~
# ```
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_pre_configure() {
	termux_setup_protobuf

	CPPFLAGS+=" -D_LIBCPP_ENABLE_CXX17_REMOVED_FEATURES"
	CPPFLAGS+=" -DPROTOBUF_USE_DLLS"
	# from PREFIX/lib/cmake/glog/glog-targets.cmake
	CPPFLAGS+=" -DGLOG_USE_GLOG_EXPORT -DGLOG_USE_GFLAGS"

	LDFLAGS+=" $($TERMUX_SCRIPTDIR/packages/libprotobuf/interface_link_libraries.sh)"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dprotobuf_PROTOC_EXE=$(command -v protoc)"
	sed -i 's/COMMAND\sprotobuf::protoc/COMMAND ${protobuf_PROTOC_EXE}/g' $TERMUX_PREFIX/lib/cmake/protobuf/protobuf-generate.cmake

	# Fix linker script error for zlib
	LDFLAGS+=" -Wl,--undefined-version"
	export DISABLE_UPDATE_SB=1
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin output/bin/pika
	install -Dm600 -t $TERMUX_PREFIX/share/pika conf/pika.conf
}
