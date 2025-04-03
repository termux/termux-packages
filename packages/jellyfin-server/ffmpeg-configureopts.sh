#!/bin/sh
cd -- "$(dirname -- "$0")" 
_FFMPEG_VERSION="$(awk -F'=' '$0 ~ /^_FFMPEG_VERSION=/ {print gensub(/"/,"","g",$2)}' ./build.sh)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"; trap '' EXIT; exit' INT EXIT TERM
cd "$tmp"

git -c advice.detachedHead=false clone --quiet --depth 1 https://github.com/jellyfin/jellyfin-ffmpeg -b v${_FFMPEG_VERSION}
cd jellyfin-ffmpeg/builder
<build.sh awk '{print} $0 ~ /^FF_LIBS/ {exit}' > configure.sh
sed -i 's/set -xe/set -e/' configure.sh
sed -i 's/docker/:/' configure.sh

cat <<'EOF' >>configure.sh
printf '%s\n' "./configure --prefix='\${_FFMPEG_PREFIX}'
--arch='\${_ARCH}'
--as='\$AS'
--cc='\$CC'
--cxx='\$CXX'
--nm='\$NM'
--ar='\$AR'
--ranlib=llvm-ranlib
--pkg-config='\$PKG_CONFIG'
--strip='\$STRIP'
--enable-cross-compile
--extra-version='Jellyfin'
--extra-cflags='$FF_CFLAGS'
--extra-cxxflags='$FF_CXXFLAGS'
--extra-ldflags='$FF_LDFLAGS'
--extra-ldexeflags='$FF_LDEXEFLAGS'
--extra-libs='$FF_LIBS -landroid-glob'
--target-os=android
--disable-static
--enable-shared
$FF_CONFIGURE
\${_EXTRA_CONFIGURE_FLAGS}
--disable-vulkan" | sed "s/'/\"/g;$ ! s/$/ \\\\/"
EOF
# disable unused and unneeded options
rm -rf scripts.d/*{rkrga,vulkan,rkmpp,fdk-aac,zvbi,amf,vaapi,ffnvcodec,libvpl,shaderc}*
# acceptable inputs:
# ./ffmpeg-configureopts.sh linux64 gpl
# ./ffmpeg-configureopts.sh linuxarm64 gpl
[ -z "$1" ] && set -- linuxarm64 gpl
bash ./configure.sh "$@"
