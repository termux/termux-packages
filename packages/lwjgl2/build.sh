TERMUX_PKG_HOMEPAGE=https://legacy.lwjgl.org/
TERMUX_PKG_DESCRIPTION="Lightweight Java Game Library 2 (LWJGL 2)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="doc/LICENSE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.9.3"
TERMUX_PKG_SRCURL="https://github.com/LWJGL/lwjgl/archive/refs/tags/lwjgl${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=9a4ffd8aed04209cb7ee0450902fbd177106128d2d5e3ab65632942df9dacc17
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libx11, libxcursor, libxext, libxrandr, libxxf86vm"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_RECOMMENDS="openal-soft"
TERMUX_PKG_BUILD_IN_SRC=true

# The annotation processors run on the host JDK; javac -h stands in for javah.
_lwjgl2_generate() {
	local templates=src/templates/org/lwjgl
	local gen=org.lwjgl.util.generator
	local cp="src/java:src/templates:$_LWJGL_OUT/bin"
	local gl="GL*.java,ARB*.java,EXT*.java,KHR*.java,AMD*.java,APPLE*.java,ATI*.java,NV*.java,NVX*.java,HP*.java,IBM*.java,SUN*.java,SGIS*.java,GREMEDY*.java,INTEL*.java"
	local gles="GLES*.java,ARB*.java,EXT*.java,KHR*.java,AMD*.java,ANGLE*.java,APPLE*.java,ARM*.java,DMP*.java,IMG*.java,NV*.java,OES*.java,QCOM*.java,VIV*.java"
	local cl="CL*.java,KHR*.java,EXT*.java,APPLE*.java,AMD*.java,INTEL*.java,NV*.java"
	local helpers="org/lwjgl/PointerWrapper.java org/lwjgl/PointerBuffer.java org/lwjgl/opengl/GLSync.java
		org/lwjgl/opengl/AMDDebugOutputCallback.java org/lwjgl/opengl/ARBDebugOutputCallback.java org/lwjgl/opengl/KHRDebugCallback.java
		org/lwjgl/opengles/EGLImageOES.java org/lwjgl/opengles/KHRDebugCallback.java
		org/lwjgl/opencl/CLPlatform.java org/lwjgl/opencl/CLDevice.java org/lwjgl/opencl/CLContext.java
		org/lwjgl/opencl/CLCommandQueue.java org/lwjgl/opencl/CLMem.java org/lwjgl/opencl/CLNativeKernel.java
		org/lwjgl/opencl/CLFunctionAddress.java"

	mkdir -p "$_LWJGL_OUT/bin" src/generated src/native/generated/{openal,opengl,opengles,opencl}
	(cd src/java && javac -nowarn -source 8 -target 8 -d "$_LWJGL_OUT/bin" -sourcepath . \
		$(find org/lwjgl/util/generator -name '*.java') $helpers org/lwjgl/opencl/CL*Callback.java)

	_lwjgl2_proc() {
		local processor="$1" dir="$2" patterns="$3" p files=()
		shift 3
		for p in ${patterns//,/ }; do
			files+=($(find "$templates/$dir" -maxdepth 1 -name "$p"))
		done
		javac -nowarn -source 8 -target 8 -proc:only -processor "$processor" -cp "$cp" \
			-s src/generated -Abinpath="$_LWJGL_OUT/bin" "$@" $(printf '%s\n' "${files[@]}" | sort -u)
	}

	_lwjgl2_proc $gen.GeneratorProcessor openal "AL*.java,EFX*.java" -d src/native/generated/openal -Atypemap=$gen.openal.ALTypeMap
	_lwjgl2_proc $gen.GeneratorProcessor opengl "$gl" -d src/native/generated/opengl -Atypemap=$gen.opengl.GLTypeMap -Acontextspecific
	_lwjgl2_proc $gen.opengl.GLGeneratorProcessor opengl "$gl" -d "$_LWJGL_OUT/bin" -Acontextspecific
	_lwjgl2_proc $gen.opengl.GLReferencesGeneratorProcessor opengl "$gl" -d "$_LWJGL_OUT/bin"
	_lwjgl2_proc $gen.GeneratorProcessor opengles "$gles" -d src/native/generated/opengles -Atypemap=$gen.opengl.GLESTypeMap
	_lwjgl2_proc $gen.opengl.GLESGeneratorProcessor opengles "$gles" -d "$_LWJGL_OUT/bin"
	_lwjgl2_proc $gen.GeneratorProcessor opencl "$cl" -d src/native/generated/opencl -Acontextspecific -Atypemap=$gen.opencl.CLTypeMap
	_lwjgl2_proc $gen.opencl.CLGeneratorProcessor opencl "$cl" -d "$_LWJGL_OUT/bin" -Acontextspecific
}

_lwjgl2_build_java() {
	local classes="$_LWJGL_OUT/classes" stage
	mkdir -p "$classes" "$_LWJGL_OUT/headers" "$_LWJGL_OUT/jars"
	find src/java src/generated -name '*.java' \
		\( -path '*/org/lwjgl/*.java' -o -path '*/org/lwjgl/input/*' -o -path '*/org/lwjgl/opengl/*' \
		-o -path '*/org/lwjgl/opengles/*' -o -path '*/org/lwjgl/openal/*' -o -path '*/org/lwjgl/opencl/*' \
		-o -path '*/org/lwjgl/util/*' \) \
		! -path '*/org/lwjgl/util/generator/*' ! -path '*/org/lwjgl/util/applet/*' \
		! -path '*/org/lwjgl/test/*' ! -path '*/org/lwjgl/examples/*' > "$_LWJGL_OUT/java.list"
	javac -nowarn -source 8 -target 8 -encoding UTF-8 -XDignore.symbol.file -proc:none \
		-cp libs/jinput.jar:libs/AppleJavaExtensions.jar:libs/asm-debug-all.jar \
		-h "$_LWJGL_OUT/headers" -d "$classes" @"$_LWJGL_OUT/java.list"

	printf '%s\n' "Specification-Title: LWJGL" "Specification-Version: $TERMUX_PKG_VERSION" \
		"Implementation-Title: LWJGL" "Implementation-Version: $TERMUX_PKG_VERSION" \
		"Implementation-Vendor: lwjgl.org" > "$_LWJGL_OUT/MANIFEST.MF"

	stage="$_LWJGL_OUT/stage-lwjgl"
	mkdir -p "$stage"
	(cd "$classes" && find org -type f ! -path 'org/lwjgl/util/*' ! -path 'org/lwjgl/test/*' ! -path 'org/lwjgl/examples/*' \
		\( ! -path 'org/lwjgl/opengles/*' -o -name 'ContextAttribs*' \) | tar -cf - -T -) | tar -xf - -C "$stage"
	jar --create --file "$_LWJGL_OUT/jars/lwjgl.jar" --manifest "$_LWJGL_OUT/MANIFEST.MF" -C "$stage" .

	stage="$_LWJGL_OUT/stage-util"
	mkdir -p "$stage"
	(cd "$classes" && find org/lwjgl/util -type f | tar -cf - -T -) | tar -xf - -C "$stage"
	jar --create --file "$_LWJGL_OUT/jars/lwjgl_util.jar" --manifest "$_LWJGL_OUT/MANIFEST.MF" -C "$stage" .
}

_lwjgl2_build_native() {
	local jdk_home="${JAVA_HOME:-$(dirname "$(dirname "$(readlink -f "$(command -v javac)")")")}"
	local native=src/native libname=liblwjgl.so
	case "$TERMUX_ARCH" in
		aarch64 | x86_64) libname=liblwjgl64.so ;;
	esac
	# javac -h skips classes without native methods, so rebuild their constant headers.
	local header class
	for header in $(grep -rhoE '#include +"org_lwjgl_[A-Za-z0-9_]+\.h"' $native/common $native/linux | sed -E 's/.*"(.*)"/\1/' | sort -u); do
		[ -e "$_LWJGL_OUT/headers/$header" ] && continue
		class="${header%.h}"
		javap -constants -p -cp "$_LWJGL_OUT/classes" "${class//_/.}" 2> /dev/null |
			sed -nE "s/^[[:space:]]*(public |protected |private )?static final (int|long|short|byte) ([A-Za-z0-9_]+) = (.+);\$/#define ${class}_\3 \4/p" \
			> "$_LWJGL_OUT/headers/$header" || : > "$_LWJGL_OUT/headers/$header"
	done
	local flags="-O2 -fPIC -std=c99 -Wunused -pthread -I$jdk_home/include -I$jdk_home/include/linux -I$_LWJGL_OUT/headers"
	flags+=" -I$native/common -I$native/common/opengl -I$native/linux -I$native/linux/opengl"

	# AWT canvas support is left out to avoid linking libjawt.
	local f files=()
	for f in $native/common/*.c $native/common/opengl/*.c $native/generated/openal/*.c \
		$native/generated/opencl/*.c $native/generated/opengl/*.c $native/linux/*.c $native/linux/opengl/*.c; do
		case "$f" in
			*AWTSurfaceLock* | *LinuxAWTGLCanvasPeerInfo*) ;;
			*) files+=("$f") ;;
		esac
	done

	local objdir="$_LWJGL_OUT/obj" jobs pids=()
	jobs="$TERMUX_PKG_MAKE_PROCESSES"
	mkdir -p "$objdir" "$_LWJGL_OUT/lib"
	for f in "${files[@]}"; do
		$CC $flags $CPPFLAGS $CFLAGS -c "$f" -o "$objdir/$(echo "$f" | cksum | cut -d' ' -f1)_$(basename "$f").o" &
		pids+=($!)
		if (( ${#pids[@]} >= jobs )); then
			wait "${pids[0]}"
			pids=("${pids[@]:1}")
		fi
	done
	for f in "${pids[@]}"; do
		wait "$f"
	done

	$CC -shared $CFLAGS $LDFLAGS -o "$_LWJGL_OUT/lib/$libname" "$objdir"/*.o \
		-Wl,--no-undefined -Wl,--version-script,"$native/linux/lwjgl.map" \
		-lm -lX11 -lXext -lXcursor -lXrandr -lXxf86vm -ldl
}

termux_step_make() {
	_LWJGL_OUT="$TERMUX_PKG_BUILDDIR/_out"
	rm -rf "$_LWJGL_OUT"
	mkdir -p "$_LWJGL_OUT"
	_lwjgl2_generate
	_lwjgl2_build_java
	_lwjgl2_build_native
}

termux_step_make_install() {
	install -Dm644 -t "$TERMUX_PREFIX/share/java/lwjgl/$TERMUX_PKG_VERSION" "$_LWJGL_OUT"/jars/*.jar
	install -Dm755 -t "$TERMUX_PREFIX/lib/lwjgl/$TERMUX_PKG_VERSION" "$_LWJGL_OUT"/lib/*.so
}
