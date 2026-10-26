TERMUX_PKG_HOMEPAGE=https://www.lwjgl.org/
TERMUX_PKG_DESCRIPTION="Lightweight Java Game Library 3 (LWJGL 3), all versions required by launchers"
TERMUX_PKG_LICENSE="BSD 3-Clause, ISC"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="3.4.3"
TERMUX_PKG_SRCURL="https://github.com/LWJGL/lwjgl3/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=039b5c4b9ef1927d56f6e63909ef3cbfba130d9f0294af37440d831048d2e724
TERMUX_PKG_AUTO_UPDATE=false
# Every version is a subpackage (see the lwjgl3-*.subpackage.sh files),
# this package only pulls them all in.
TERMUX_PKG_DEPENDS="lwjgl3-3.2.1, lwjgl3-3.2.2, lwjgl3-3.3.1, lwjgl3-3.3.2, lwjgl3-3.3.3, lwjgl3-3.3.6, lwjgl3-3.4.1, lwjgl3-3.4.2, lwjgl3-3.4.3"
TERMUX_PKG_BUILD_DEPENDS="libffi"
TERMUX_PKG_RECOMMENDS="openal-soft"
TERMUX_PKG_BUILD_IN_SRC=true

# To add a new LWJGL 3 version:
#   1. add it to _LWJGL3_VERSIONS and to the checksum table in termux_step_post_get_source,
#   2. add its patches (if any) to patches/<version>/,
#   3. add it to TERMUX_PKG_DEPENDS and add a lwjgl3-<version>.subpackage.sh.
# The version in TERMUX_PKG_VERSION is the newest one and is the main source.
_LWJGL3_VERSIONS=(3.2.1 3.2.2 3.3.1 3.3.2 3.3.3 3.3.6 3.4.1 3.4.2 3.4.3)
_LWJGL_DYNCALL_COMMIT=3bcebd526fe16f0aa520e32597ff3dbfbf30b1e4
_LWJGL_DYNCALL_SHA256=5ac91f490383557c9809da978ca2909754271ab03a977b2acad353c07063952a

termux_step_post_get_source() {
	declare -A sha256=(
		[3.2.1]=d0019f5fd1ee00fd68b8ba32fd42a616f99c73f7bdcf93edd4ce3ec0c6b1758f
		[3.2.2]=e98805dbcab98f09df27848a229d7cb80687d9ce986b43d1f20b0712e1215f6e
		[3.3.1]=bcb4da2014cee86b3cb24fde3fcf3fcc600957bac62ed0d12ba997050e0e34b9
		[3.3.2]=771d2991d32a07449cc25130989974f9891615af91b509d7a572bce66a32b8cc
		[3.3.3]=381a386688a5f5109a0edf2395adfee3cc62031929bf0ddbbd39fd356f647447
		[3.3.6]=be7e38712236908aa7ff0bf84af034c241a0624a7387414c7ed3aa742a5a44b3
		[3.4.1]=86f22fa70bdb8dbf9ea205daa0e9d88dd80fa7cecbd60025f687b7400edb11fd
		[3.4.2]=4badae311ddee9fd4b318ebc59fc61c990ffaf8d2b5bb2cc4077c0beec36f715
		[3.4.3]=039b5c4b9ef1927d56f6e63909ef3cbfba130d9f0294af37440d831048d2e724
	)

	local v dir file p
	for v in "${_LWJGL3_VERSIONS[@]}"; do
		# The newest version is the main source, the others are unpacked next to it.
		dir="$TERMUX_PKG_SRCDIR/_src/$v"
		if [[ "$v" == "$TERMUX_PKG_VERSION" ]]; then
			dir="$TERMUX_PKG_SRCDIR"
		fi

		if [[ "$v" != "$TERMUX_PKG_VERSION" ]]; then
			file="$TERMUX_PKG_CACHEDIR/lwjgl3-$v.tar.gz"
			termux_download "https://github.com/LWJGL/lwjgl3/archive/refs/tags/$v.tar.gz" "$file" "${sha256[$v]}"
			mkdir -p "$dir"
			tar -xf "$file" -C "$dir" --strip-components=1
		fi

		if [[ "$v" == 3.2.* ]]; then
			# 3.2.x links prebuilt dyncall archives upstream, so build them from the pinned source.
			file="$TERMUX_PKG_CACHEDIR/dyncall-$_LWJGL_DYNCALL_COMMIT.tar.gz"
			termux_download "https://github.com/LWJGL-CI/dyncall/archive/$_LWJGL_DYNCALL_COMMIT.tar.gz" "$file" "$_LWJGL_DYNCALL_SHA256"
			mkdir -p "$dir/_dyncall"
			tar -xf "$file" -C "$dir/_dyncall" --strip-components=1
		fi

		# Patches are kept per version, so the generic patch step does not pick them up.
		for p in "$TERMUX_PKG_BUILDER_DIR/patches/$v"/*.patch; do
			[[ -f "$p" ]] || continue
			echo "Applying patch: $v/$(basename "$p")"
			patch --silent -p1 -d "$dir" < "$p"
		done
	done
}

_lwjgl_compile() {
	local objdir="$1" flags="$2"
	shift 2
	local jobs pids=() f
	jobs="$TERMUX_PKG_MAKE_PROCESSES"
	mkdir -p "$objdir"
	for f in "$@"; do
		$CC $flags $CPPFLAGS $CFLAGS ${_LWJGL_LATE_CFLAGS:-} -c "$f" -o "$objdir/$(echo "$f" | cksum | cut -d' ' -f1)_$(basename "$f").o" &
		pids+=($!)
		if (( ${#pids[@]} >= jobs )); then
			wait "${pids[0]}"
			pids=("${pids[@]:1}")
		fi
	done
	for f in "${pids[@]}"; do
		wait "$f"
	done
}

_lwjgl_link() {
	local name="$1"
	shift
	$CC -shared $CFLAGS $LDFLAGS -o "$_LWJGL_OUT/lib/lib$name.so" "$_LWJGL_OUT/obj/$name"/*.o \
		-Wl,--no-undefined -Wl,--version-script,"$_LWJGL_SRC/config/linux/version.script" \
		-Wl,-z,noexecstack "$@"
}

_lwjgl_jar() {
	local name="$1" module="$2" title="$3"
	{
		echo "Specification-Title: Lightweight Java Game Library - $title"
		echo "Specification-Version: $_LWJGL_VERSION"
		echo "Specification-Vendor: lwjgl.org"
		echo "Implementation-Title: $name"
		echo "Implementation-Version: build 1"
		echo "Implementation-Vendor: lwjgl.org"
	} > "$_LWJGL_OUT/MANIFEST.MF"
	jar --create --file "$_LWJGL_OUT/jars/$name.jar" --manifest "$_LWJGL_OUT/MANIFEST.MF" -C "$_LWJGL_OUT/classes/$module" .
}

# Build-time stand-ins for the annotation jars that upstream fetches from Maven.
# Shared by all versions (javax.annotation for <= 3.3.x, org.jspecify for 3.4.x).
_lwjgl_build_stubs() {
	mkdir -p "$_LWJGL_ROOT/stub"
	javac -nowarn -d "$_LWJGL_ROOT/stub" $(find "$TERMUX_PKG_BUILDER_DIR/stubs" -name '*.java')
}

# Generated sources are tracked upstream, so the Ant and Kotlin steps are skipped.
_lwjgl_build_java() {
	local modules_dir="$_LWJGL_SRC/modules/lwjgl"
	local cp="$_LWJGL_ROOT/stub" m
	for m in core egl opengl opengles vulkan glfw jemalloc openal stb tinyfd; do
		mkdir -p "$_LWJGL_OUT/classes/$m"
		find "$modules_dir/$m/src/main/java" "$modules_dir/$m/src/generated/java" -name '*.java' 2> /dev/null > "$_LWJGL_OUT/$m.list" || true
		javac -nowarn -source 8 -target 8 -encoding UTF-8 -XDignore.symbol.file -proc:none \
			-cp "$cp" -d "$_LWJGL_OUT/classes/$m" @"$_LWJGL_OUT/$m.list"
		cp="$cp:$_LWJGL_OUT/classes/$m"
		if [[ "$m" == "core" ]]; then
			_lwjgl_jar lwjgl core core
		else
			_lwjgl_jar "lwjgl-$m" "$m" "$m"
		fi
	done
}

_lwjgl_build_dyncall() {
	local d="$_LWJGL_SRC/_dyncall"
	# Termux defaults arm to Thumb, whose dyncall assembly clang cannot assemble.
	local _LWJGL_LATE_CFLAGS=""
	if [ "$TERMUX_ARCH" = arm ]; then
		_LWJGL_LATE_CFLAGS="-marm"
	fi
	local flags="-O2 -fPIC -DNDEBUG -I$d/dyncall -I$d/dyncallback -I$d/dynload -I$d"
	local lib f files
	mkdir -p "$_LWJGL_OUT/dyncall"
	for lib in dyncall dyncallback dynload; do
		case "$lib" in
			dyncall) files=(dyncall_call.S dyncall_vector.c dyncall_struct.c dyncall_api.c dyncall_callvm.c dyncall_callvm_base.c dyncall_callf.c) ;;
			dyncallback) files=(dyncall_callback_arch.S dyncall_thunk.c dyncall_alloc_wx.c dyncall_args.c dyncall_callback.c) ;;
			dynload) files=(dynload.c dynload_syms.c) ;;
		esac
		local paths=()
		for f in "${files[@]}"; do
			paths+=("$d/$lib/$f")
		done
		_lwjgl_compile "$_LWJGL_OUT/dyncall/$lib" "$flags" "${paths[@]}"
		rm -f "$_LWJGL_OUT/dyncall/lib${lib}_s.a"
		$AR rcs "$_LWJGL_OUT/dyncall/lib${lib}_s.a" "$_LWJGL_OUT/dyncall/$lib"/*.o
	done
}

_lwjgl_build_native() {
	local modules_dir="$_LWJGL_SRC/modules/lwjgl"
	local jdk_home="${JAVA_HOME:-$(dirname "$(dirname "$(readlink -f "$(command -v javac)")")")}"
	local core_c="$modules_dir/core/src/main/c"
	local arch ffi_dir ffi_define=""
	case "$TERMUX_ARCH" in
		aarch64) arch=arm64; ffi_dir=aarch64 ;;
		arm) arch=arm32; ffi_dir=arm ;;
		x86_64) arch=x64; ffi_dir=x86; ffi_define="-DX86_64" ;;
		i686) arch=x86; ffi_dir=x86 ;;
	esac
	local base="-std=gnu11 -O2 -fPIC -DNDEBUG -DLWJGL_LINUX -DLWJGL_$arch -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64"
	base+=" -I$jdk_home/include -I$jdk_home/include/linux -I$core_c -I$core_c/linux"
	mkdir -p "$_LWJGL_OUT/lib" "$_LWJGL_OUT/obj"

	local f files=("$modules_dir"/core/src/main/c/*.c "$modules_dir"/core/src/generated/c/*.c)
	if [[ "$_LWJGL_VERSION" == 3.2.* ]]; then
		_lwjgl_build_dyncall
		files+=("$modules_dir"/core/src/generated/c/linux/*.c)
		_lwjgl_compile "$_LWJGL_OUT/obj/lwjgl" "-I$core_c/dyncall $base" "${files[@]}"
		_lwjgl_link lwjgl "$_LWJGL_OUT/dyncall/libdyncallback_s.a" "$_LWJGL_OUT/dyncall/libdyncall_s.a" "$_LWJGL_OUT/dyncall/libdynload_s.a" -ldl
	else
		# liburing is skipped: Android blocks io_uring and it needs libc symbols above API 24.
		for f in "$modules_dir"/core/src/generated/c/linux/*.c; do
			case "$f" in *liburing*) ;; *) files+=("$f") ;; esac
		done
		# Bundled headers are used because the generated bindings reference every libffi ABI.
		_lwjgl_compile "$_LWJGL_OUT/obj/lwjgl" "-I$core_c/libffi -I$core_c/libffi/$ffi_dir $ffi_define $base" "${files[@]}"
		_lwjgl_link lwjgl -lffi -ldl
	fi

	local opengl_files=()
	for f in "$modules_dir"/opengl/src/generated/c/*.c; do
		case "$f" in *_WGL.c) ;; *) opengl_files+=("$f") ;; esac
	done
	_lwjgl_compile "$_LWJGL_OUT/obj/lwjgl_opengl" "-I$modules_dir/opengl/src/main/c $base" "${opengl_files[@]}"
	_lwjgl_link lwjgl_opengl

	_lwjgl_compile "$_LWJGL_OUT/obj/lwjgl_stb" "-isystem $modules_dir/stb/src/main/c $base" "$modules_dir"/stb/src/generated/c/*.c
	_lwjgl_link lwjgl_stb -lm

	_lwjgl_compile "$_LWJGL_OUT/obj/lwjgl_tinyfd" "-I$modules_dir/tinyfd/src/main/c $base" \
		"$modules_dir/tinyfd/src/main/c/tinyfiledialogs.c" "$modules_dir"/tinyfd/src/generated/c/*.c
	_lwjgl_link lwjgl_tinyfd
}

termux_step_make() {
	_LWJGL_ROOT="$TERMUX_PKG_BUILDDIR/_out"
	rm -rf "$_LWJGL_ROOT"
	_lwjgl_build_stubs

	local v
	for v in "${_LWJGL3_VERSIONS[@]}"; do
		echo "Building LWJGL $v"
		_LWJGL_VERSION="$v"
		# The newest version is the main source, the others are unpacked next to it.
		_LWJGL_SRC="$TERMUX_PKG_SRCDIR/_src/$v"
		if [[ "$v" == "$TERMUX_PKG_VERSION" ]]; then
			_LWJGL_SRC="$TERMUX_PKG_SRCDIR"
		fi
		_LWJGL_OUT="$_LWJGL_ROOT/$v"
		mkdir -p "$_LWJGL_OUT/jars"
		_lwjgl_build_java
		_lwjgl_build_native
	done
}

termux_step_make_install() {
	local v
	for v in "${_LWJGL3_VERSIONS[@]}"; do
		install -Dm644 -t "$TERMUX_PREFIX/share/java/lwjgl3/$v" "$_LWJGL_ROOT/$v"/jars/*.jar
		install -Dm755 -t "$TERMUX_PREFIX/lib/lwjgl3/$v" "$_LWJGL_ROOT/$v"/lib/*.so
	done
}
