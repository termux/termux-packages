#!/usr/bin/env bash
set -e -u -o pipefail

if [ -e "/usr/src/Libraries/td" ]; then
    exit 0
fi

mkdir -p /usr/src/Libraries/td-tmp
cp -Rf /usr/src/tdesktop/libtd/* /usr/src/Libraries/td-tmp/
cd /usr/src/Libraries/td-tmp/
env -u CFLAGS -u CXXFLAGS cmake -B out/Release . \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_FLAGS_RELEASE="$CFLAGS" \
	-DCMAKE_C_FLAGS_DEBUG="$CFLAGS -O0 -fno-lto -U_FORTIFY_SOURCE" \
	-DCMAKE_CXX_FLAGS_RELEASE="$CXXFLAGS" \
	-DCMAKE_CXX_FLAGS_DEBUG="$CXXFLAGS -O0 -fno-lto -U_FORTIFY_SOURCE"
cmake --build out/Release --config Release --target tdutils -j$(nproc)
cmake --build out/Release --config Release --target tde2e -j$(nproc)
env -u CFLAGS -u CXXFLAGS cmake -B out/Debug . \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_FLAGS_RELEASE="$CFLAGS" \
	-DCMAKE_C_FLAGS_DEBUG="$CFLAGS -O0 -fno-lto -U_FORTIFY_SOURCE" \
	-DCMAKE_CXX_FLAGS_RELEASE="$CXXFLAGS" \
	-DCMAKE_CXX_FLAGS_DEBUG="$CXXFLAGS -O0 -fno-lto -U_FORTIFY_SOURCE"
cmake --build out/Debug --config Debug --target tdutils -j$(nproc)
cmake --build out/Debug --config Debug --target tde2e -j$(nproc)
mv /usr/src/Libraries/td-tmp /usr/src/Libraries/td
