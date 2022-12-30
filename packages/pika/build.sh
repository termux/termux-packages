TERMUX_PKG_HOMEPAGE=https://github.com/OpenAtomFoundation/pika
TERMUX_PKG_DESCRIPTION="A persistent huge storage service, compatible with the vast majority of Redis interfaces"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4.1
TERMUX_PKG_SRCURL=git+https://github.com/OpenAtomFoundation/pika
TERMUX_PKG_DEPENDS="google-glog, libc++, libprotobuf, librocksdb"
TERMUX_PKG_BUILD_IN_SRC=true

# ```
# [...]/src/pika_set.cc:107:58: error: cannot initialize a parameter of type
# 'long *' with an rvalue of type 'int64_t *' (aka 'long long *')
#   if (!slash::string2l(argv_[2].data(), argv_[2].size(), &cursor_)) {
#                                                          ^~~~~~~~
# ```
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_post_get_source() {
	rm -fr third/rocksdb
	rm -fr third/blackwidow/deps/rocksdb
}

termux_step_pre_configure() {
	termux_setup_protobuf

	CPPFLAGS+=" -D_LIBCPP_ENABLE_CXX17_REMOVED_FEATURES"
	export DISABLE_UPDATE_SB=1
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin output/bin/pika
	install -Dm600 -t $TERMUX_PREFIX/share/pika conf/pika.conf
}
