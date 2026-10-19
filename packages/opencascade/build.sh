TERMUX_PKG_HOMEPAGE=https://dev.opencascade.org/
TERMUX_PKG_DESCRIPTION="Open CASCADE Technology (OCCT) 3D modeling and CAD development platform"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="LICENSE_LGPL_21.txt"
TERMUX_PKG_MAINTAINER="Daniel <danielpdiamon@gmail.com>"
TERMUX_PKG_VERSION="8.0.0.p1"
TERMUX_PKG_SRCURL="https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V${TERMUX_PKG_VERSION//./_}.tar.gz"
TERMUX_PKG_SHA256="ad794cba1f377274b40050b098c106e02409def7e23b0763fae4b0aea95ac3a7"
TERMUX_PKG_DEPENDS="draco, freeimage, freetype, rapidjson, tcl, tk"
TERMUX_PKG_BUILD_DEPENDS="fontconfig"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_LIBRARY_TYPE=Shared
-DBUILD_MODULE_Draw=ON
-DBUILD_MODULE_Visualization=ON
-DUSE_FREETYPE=ON
-DUSE_FREEIMAGE=ON
-DUSE_RAPIDJSON=ON
-DUSE_DRACO=ON
-DUSE_TBB=OFF
-DUSE_VTK=OFF
-DUSE_GLX=OFF
-DUSE_OPENGL=OFF
-DUSE_GLES2=ON
-DBUILD_DOC_Overview=OFF
-DBUILD_SAMPLES_QT=OFF
-DBUILD_SAMPLES_MFC=OFF
-D3RDPARTY_FREETYPE_DIR=$TERMUX_PREFIX
-D3RDPARTY_FREETYPE_INCLUDE_DIR=$TERMUX_PREFIX/include/freetype2
-D3RDPARTY_FREETYPE_LIBRARY_DIR=$TERMUX_PREFIX/lib
-D3RDPARTY_FREEIMAGE_DIR=$TERMUX_PREFIX
-D3RDPARTY_FREEIMAGE_INCLUDE_DIR=$TERMUX_PREFIX/include
-D3RDPARTY_FREEIMAGE_LIBRARY_DIR=$TERMUX_PREFIX/lib
-D3RDPARTY_RAPIDJSON_DIR=$TERMUX_PREFIX
-D3RDPARTY_RAPIDJSON_INCLUDE_DIR=$TERMUX_PREFIX/include
-D3RDPARTY_DRACO_DIR=$TERMUX_PREFIX
-D3RDPARTY_DRACO_INCLUDE_DIR=$TERMUX_PREFIX/include
-D3RDPARTY_DRACO_LIBRARY_DIR=$TERMUX_PREFIX/lib
-D3RDPARTY_TCL_DIR=$TERMUX_PREFIX
-D3RDPARTY_TCL_INCLUDE_DIR=$TERMUX_PREFIX/include
-D3RDPARTY_TCL_LIBRARY_DIR=$TERMUX_PREFIX/lib
-D3RDPARTY_TK_DIR=$TERMUX_PREFIX
-D3RDPARTY_TK_INCLUDE_DIR=$TERMUX_PREFIX/include
-D3RDPARTY_TK_LIBRARY_DIR=$TERMUX_PREFIX/lib
"

termux_step_post_get_source() {
	# 1. Allow Draw module to build on Android
	sed -i 's/set (BUILD_MODULE_Draw OFF CACHE BOOL "${BUILD_MODULE_Draw_DESCR}" FORCE)/# patched for Termux/g' CMakeLists.txt

	# 2. Android 11+ FDSAN bypass patch in Draw_Main to prevent SIGABRT 134 on fd close
	cat <<- 'EOF' > "$TERMUX_PKG_TMPDIR/fdsan_patch.inc"
	#if defined(__ANDROID__)
	#include <dlfcn.h>
	static void _disable_fdsan_android() {
		void *lib = dlopen("libc.so", RTLD_LAZY);
		if (lib) {
			typedef void (*set_level_fn)(int);
			set_level_fn fn = (set_level_fn)dlsym(lib, "android_fdsan_set_error_level");
			if (fn) fn(0);
			dlclose(lib);
		}
	}
	#endif
	EOF
	sed -i '1r '"$TERMUX_PKG_TMPDIR/fdsan_patch.inc" src/Draw/TKDraw/Draw/Draw_Main.cxx
	sed -i '/int Draw_Main/ {n; s/{/{\n#if defined(__ANDROID__)\n  _disable_fdsan_android();\n#endif/}' src/Draw/TKDraw/Draw/Draw_Main.cxx
}

termux_step_post_make_install() {
	cat <<- INS_EOF > "$TERMUX_PREFIX/bin/drawenv"
	#!$TERMUX_PREFIX/bin/sh
	export TCL_LIBRARY="$TERMUX_PREFIX/lib/tcl8.6"
	export TK_LIBRARY="$TERMUX_PREFIX/lib/tk8.6"
	export TCLLIBPATH="$TERMUX_PREFIX/lib $TERMUX_PREFIX/lib/tcl8.6 $TERMUX_PREFIX/lib/tk8.6"
	exec "$TERMUX_PREFIX/bin/DRAWEXE" "\$@"
	INS_EOF
	chmod 0755 "$TERMUX_PREFIX/bin/drawenv"
}
