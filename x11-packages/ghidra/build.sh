TERMUX_PKG_HOMEPAGE=https://ghidra-sre.org
TERMUX_PKG_DESCRIPTION="Software reverse engineering framework"
TERMUX_PKG_LICENSE="Apache-2.0, GPL-3.0, LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="LICENSE, GPL/licenses/GPL_3.html, GPL/licenses/LGPL_2.1.txt"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="12.1.4"
TERMUX_PKG_SRCURL=https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_${TERMUX_PKG_VERSION}_build.tar.gz
TERMUX_PKG_SHA256=2a858300c350f05ae2e729dff86b4f584d0b9a6b398879c55025574e67696cec
TERMUX_PKG_DEPENDS="openjdk-25-x, python"
TERMUX_PKG_BUILD_DEPENDS="python"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_step_host_build() {
	# Prebuilt GNU/Linux JDK to run Gradle with, same archive as openjdk-25.
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		local archive="$TERMUX_PKG_CACHEDIR/openjdk-25_linux-x64_bin.tar.gz"
		termux_download "https://download.java.net/java/GA/jdk25/bd75d5f9689641da8e1daabeccb5528b/36/GPL/openjdk-25_linux-x64_bin.tar.gz" \
			"$archive" \
			59cdcaf255add4721de38eb411d4ecfe779356b61fb671aee63c7dec78054c2b
		rm -rf "$TERMUX_PKG_HOSTBUILD_DIR"
		mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR"
		tar -xf "$archive" --strip-components=1 -C "$TERMUX_PKG_HOSTBUILD_DIR"
	fi
}

termux_step_make() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export JAVA_HOME="$TERMUX_PKG_HOSTBUILD_DIR"
	else
		export JAVA_HOME="$TERMUX_PREFIX/lib/jvm/java-25-openjdk"
	fi
	# Natives target Android, not the build machine: shadow host compilers.
	local shimdir="$TERMUX_PKG_TMPDIR/ghidra-toolchain"
	mkdir -p "$shimdir"
	local pair name target
	for pair in "gcc $CC" "g++ $CXX" "clang $CC" "clang++ $CXX"; do
		name="${pair%% *}"
		target="${pair#* }"
		printf '#!/bin/sh\nexec "%s" "$@"\n' "$target" > "$shimdir/$name"
		chmod +x "$shimdir/$name"
	done
	export PATH="$shimdir:$JAVA_HOME/bin:$PATH"

	local platform
	case "$TERMUX_ARCH" in
		aarch64) platform="linux_arm_64" ;;
		x86_64) platform="linux_x86_64" ;;
	esac
	./gradlew -I gradle/support/fetchDependencies.gradle help \
		--no-daemon --console=plain
	# No Z3 binary loads on bionic: ship the extension without natives.
	local z3os="dependencies/SymbolicSummaryZ3/os"
	mkdir -p "$z3os"
	find "$z3os" -mindepth 1 -delete
	./gradlew -I gradle/support/fetchDependencies.gradle buildGhidra \
		-PcurrentPlatformName="$platform" \
		--no-daemon --console=plain
}

termux_step_make_install() {
	local distdir="$TERMUX_PKG_TMPDIR/ghidra-dist"
	rm -rf "$distdir"
	mkdir -p "$distdir"
	unzip -q build/dist/ghidra_*.zip -d "$distdir"
	mkdir -p "$TERMUX_PREFIX/share/ghidra" "$TERMUX_PREFIX/bin"
	cp -r "$distdir"/ghidra_*/. "$TERMUX_PREFIX/share/ghidra/"
	ln -sf ../share/ghidra/ghidraRun "$TERMUX_PREFIX/bin/ghidraRun"
	ln -sf ../share/ghidra/support/analyzeHeadless "$TERMUX_PREFIX/bin/analyzeHeadless"
	ln -sf ../share/ghidra/support/pyghidraRun "$TERMUX_PREFIX/bin/pyghidraRun"

	install -Dm644 "$TERMUX_PKG_SRCDIR/GhidraDocs/GhidraClass/Beginner/Images/GhidraLogo64.png" \
		"$TERMUX_PREFIX/share/icons/hicolor/64x64/apps/ghidra.png"

	install -Dm644 /dev/stdin "$TERMUX_PREFIX/share/applications/ghidra.desktop" <<-DESKTOP
	[Desktop Entry]
	Name=Ghidra
	Comment=Software reverse engineering framework
	Exec=ghidraRun
	Icon=ghidra
	Terminal=false
	Type=Application
	Categories=Development;
	DESKTOP
}
