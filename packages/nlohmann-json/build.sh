TERMUX_PKG_HOMEPAGE=https://github.com/nlohmann/json
TERMUX_PKG_DESCRIPTION="JSON for Modern C++"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.10.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/nlohmann/json/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5daca6ca216495edf89d167f808d1d03c4a4d929cef7da5e10f135ae1540c7e4
TERMUX_PKG_AUTO_UPDATE=true
# Avoid tests, otherwise we run into the same/similar issue as in
# https://github.com/termux/termux-packages/issues/1149
# /home/builder/.termux-build/_cache/android-r23b-api-24-v6/bin/clang++ --target=aarch64-none-linux-android --gcc-toolchain=/home/builder/.termux-build/_cache/android-r23b-api-24-v6 --sysroot=/home/builder/.termux-build/_cache/android-r23b-api-24-v6/sysroot  -I/home/builder/.termux-build/nlohmann-json/src/test/thirdparty/doctest -fstack-protector-strong -Oz --target=aarch64-linux-android24  -I/data/data/com.termux/files/usr/include -O3 -DNDEBUG -fPIC -MD -MT test/CMakeFiles/doctest_main.dir/src/unit.cpp.o -MF test/CMakeFiles/doctest_main.dir/src/unit.cpp.o.d -o test/CMakeFiles/doctest_main.dir/src/unit.cpp.o -c /home/builder/.termux-build/nlohmann-json/src/test/src/unit.cpp
# In file included from /home/builder/.termux-build/nlohmann-json/src/test/src/unit.cpp:31:
# In file included from /home/builder/.termux-build/nlohmann-json/src/test/thirdparty/doctest/doctest_compatibility.h:6:
# In file included from /home/builder/.termux-build/nlohmann-json/src/test/thirdparty/doctest/doctest.h:2806:
# /home/builder/.termux-build/_cache/android-r23b-api-24-v6/sysroot/usr/include/c++/v1/cmath:317:9: error: no member named 'signbit' in the global namespace; did you mean 'sigwait'?
# using ::signbit;
#       ~~^
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DJSON_BuildTests=off"
