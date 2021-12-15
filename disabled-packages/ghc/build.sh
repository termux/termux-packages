# Build failure with recent NDK.

TERMUX_PKG_HOMEPAGE=https://www.haskell.org/ghc/
TERMUX_PKG_DESCRIPTION="The Glasgow Haskell Compilation system"
TERMUX_PKG_LICENSE="BSD 2-Clause, BSD 3-Clause, LGPL-2.1"
TERMUX_PKG_VERSION=8.10.1
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=http://downloads.haskell.org/~ghc/${TERMUX_PKG_VERSION}/ghc-${TERMUX_PKG_VERSION}-src.tar.xz
TERMUX_PKG_SHA256=4e3b07f83a266b3198310f19f71e371ebce97c769b14f0d688f4cbf2a2a1edf5
TERMUX_PKG_DEPENDS="binutils, clang, iconv, libffi, llvm, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --disable-ld-override --build=x86_64-unknown-linux --host=x86_64-unknown-linux"
TERMUX_PKG_BLACKLISTED_ARCHES="arm"

DYNAMIC_GHC_PROGRAMS=NO

termux_step_pre_configure() {
	termux_setup_ghc

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --target=${TERMUX_HOST_PLATFORM}"

	# After stage 0, cabal passes a host string to the libraries' configure scripts that isn't valid.
	# We set one ourselves anyway, so this simply isn't needed.
	sed -i 's/maybeHostFlag = i/maybeHostFlag = [] -- i/' libraries/Cabal/Cabal/Distribution/Simple.hs

	# Android will only run PIE executables, so --no-pie, like GHC suggests, is out. GHC relies on relocations.
	# Combine PIE and -Wl,-r together, and the linker will tell you those flags are mutually exclusive.
	# This poses a problem as we need both. If you let the compiler handle it, then apparently all's well.
	sed -i 's/"-Wl,-r"/"-r"/' compiler/main/DriverPipeline.hs

	cp mk/build.mk.sample mk/build.mk
	cat >> mk/build.mk <<-EOF
	SRC_HC_OPTS     += -optc-Wno-unused-label -optc-Wno-unused-but-set-variable
	SRC_HC_OPTS     += -optc-Wno-unused-variable -optc-Wno-unused-function
	SRC_HC_OPTS     += -optc-Wno-unused-command-line-argument -optc-Wno-unknown-warning-option
	GhcStage2HcOpts += -optl-Wl,--enable-new-dtags
	INTEGER_LIBRARY = integer-simple
	SplitSections   = YES
	BuildFlavour         = quick-cross
	HADDOCK_DOCS         = NO
	BUILD_SPHINX_HTML    = NO
	BUILD_SPHINX_PS      = NO
	BUILD_SPHINX_PDF     = NO
	DYNAMIC_GHC_PROGRAMS = $DYNAMIC_GHC_PROGRAMS
	GhcLibWays = v
	BUILD_MAN = NO
	#STRIP_CMD = $STRIP
	EOF
	# If choosing to build a GHC dynamically linked to its libs, then
	# $TERMUX_PREFIX/lib automatically gets added to the rpath that's generated
	if [ "$DYNAMIC_GHC_PROGRAMS" != "YES" ]; then
		echo "GhcStage2HcOpts += -optl-Wl,-rpath=$TERMUX_PREFIX/lib" >> mk/build.mk
	fi

# So... this is fun. If these options are initially passed to the configure script,
# then building stage 0 breaks, because it's meant to run on the host with the
# host's libs. But of course, we need to link to Termux's libffi etc. and use the
# cross-compiler when building something to run on Android in the later stages
patch -Np1 <<EOF
--- a/rules/build-package-data.mk.orig	2020-06-09 23:44:52.013029077 +0000
+++ b/rules/build-package-data.mk	2020-06-09 23:45:10.589149807 +0000
@@ -108,6 +108,15 @@
 \$1_\$2_CONFIGURE_OPTS += --configure-option=--host=\$(TargetPlatformFull)
 endif
 
+ifneq "\$3" "0"
+\$1_\$2_CONFIGURE_OPTS += --configure-option=--host=$TERMUX_HOST_PLATFORM --configure-option=CXX=$CXX --configure-option=LD=$LD --configure-option=AR=$AR
+\$1_\$2_CONFIGURE_OPTS += --configure-option=AS=$AS --configure-option=CC=$CC --configure-option=RANLIB=$RANLIB --configure-option=READELF=$READELF
+\$1_\$2_CONFIGURE_OPTS += --configure-option=OBJCOPY=$OBJCOPY --configure-option=OBJDUMP=$OBJDUMP --configure-option=--with-system-libffi
+\$1_\$2_CONFIGURE_OPTS += --configure-option=--with-ffi-includes=$TERMUX_PREFIX/include --configure-option=--with-ffi-libraries=$TERMUX_PREFIX/lib
+\$1_\$2_CONFIGURE_OPTS += --configure-option=--with-iconv-includes=$TERMUX_PREFIX/include --configure-option=--with-iconv-libraries=$TERMUX_PREFIX/lib
+\$1_\$2_CONFIGURE_OPTS += --configure-option=--with-curses-includes=$TERMUX_PREFIX/include/ncursesw --configure-option=--with-curses-libraries=$TERMUX_PREFIX/lib
+endif
+
 ifeq "\$3" "0"
 \$1_\$2_CONFIGURE_OPTS += \$\$(BOOT_PKG_CONSTRAINTS)
 endif
EOF

	unset AR
	unset AS
	unset CC
	export CFLAGS=""
	unset CPP
	export CPPFLAGS=""
	unset CXXFLAGS
	unset CXX
	export LDFLAGS=""
	unset LD
	unset PKG_CONFIG
	unset RANLIB
	unset READELF
	unset OBJCOPY
	unset OBJDUMP

	autoreconf
}

termux_step_post_make_install() {
	# We may build GHC with `llc-9` etc., but only `llc` is present in Termux
	sed -i 's/"LLVM llc command", "llc.*"/"LLVM llc command", "llc"/' "$TERMUX_PREFIX/lib/ghc-$TERMUX_PKG_VERSION/settings"
	sed -i 's/"LLVM opt command", "opt.*"/"LLVM opt command", "opt"/' "$TERMUX_PREFIX/lib/ghc-$TERMUX_PKG_VERSION/settings"

	if [ "$DYNAMIC_GHC_PROGRAMS" = "YES" ]; then
		# Hack to turn the binaries' rpath from something relative to the build environment
		# into something that matches Termux's FHS. patchelf needs to be installed on the host.
		while IFS= read -r -d '' bin; do
			local curr_rpath="$(patchelf --print-rpath "$bin" 2>/dev/null)"
			if [ -n "$curr_rpath" ]; then
				local paths_to_prepend=()
				local new_rpath=()

				IFS=':' read -ra paths <<< "$curr_rpath"
				for i in "${!paths[@]}"; do
					# Prioritise non-Haskell library paths
					if [[ ${paths[$i]} != *ghc-$TERMUX_PKG_VERSION* ]]; then
						paths_to_prepend+=("${paths[$i]}")
						continue
					fi
					local fixed_path="${paths[$i]/\/dist-install\/build}"
					if [ "$fixed_path" != "${paths[$i]}" ]; then
						# Naïvely correct the path to a Haskell library
						fixed_path="${fixed_path##*/}"
						fixed_path=$(echo "$TERMUX_PREFIX/lib/ghc-$TERMUX_PKG_VERSION/$fixed_path-"[[:digit:]]*)
						new_rpath+=("$fixed_path")
					else
						# This may be the path to RTS, which does not have a version number in the folder name
						# and nor is it apparently expected to be found in dist-install
						fixed_path="${paths[$i]/\/dist\/build}"
						if [ "$fixed_path" != "${paths[$i]}" ]; then
							new_rpath+=("$TERMUX_PREFIX/lib/ghc-$TERMUX_PKG_VERSION/${fixed_path##*/}")
						else
							new_rpath+=("$fixed_path")
						fi
					fi
				done
				# Make sure the standard Termux library path is the first entry
				[[ ! " ${paths_to_prepend[@]} " =~ " $TERMUX_PREFIX/lib " ]] && paths_to_prepend=("$TERMUX_PREFIX/lib" "${paths_to_prepend[@]}")
				# This isn't in the original rpath at all, but is needed
				paths_to_prepend+=("$TERMUX_PREFIX/lib/ghc-$TERMUX_PKG_VERSION/ghc-$TERMUX_PKG_VERSION")
				local OIFS="$IFS"
				local IFS=':'
				printf -v new_rpath "%s:%s" "${paths_to_prepend[*]}" "${new_rpath[*]}"
				IFS="$OIFS"
				patchelf --set-rpath "$new_rpath" "$bin"
			fi
		done < <(find "$TERMUX_PREFIX/lib/ghc-$TERMUX_PKG_VERSION/bin/" -type f -print0)
	fi
}

termux_step_install_license() {
	install -Dm600 -t "$TERMUX_PREFIX/share/doc/ghc" "$TERMUX_PKG_SRCDIR/LICENSE"
}
