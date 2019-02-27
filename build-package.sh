#!/bin/bash
# shellcheck disable=SC1117

set -e -o pipefail -u

# Utility function to log an error message and exit with an error code.
source scripts/build/termux_error_exit.sh

# Utility function to download a resource with an expected checksum.
source scripts/build/termux_download.sh

# Utility function for golang-using packages to setup a go toolchain.
source scripts/build/setup/termux_setup_golang.sh

# Utility function for rust-using packages to setup a rust toolchain.
source scripts/build/setup/termux_setup_rust.sh

# Utility function to setup a current ninja build system.
source scripts/build/setup/termux_setup_ninja.sh

# Utility function to setup a current meson build system.
source scripts/build/setup/termux_setup_meson.sh

# Utility function to setup a current cmake build system
source scripts/build/setup/termux_setup_cmake.sh

# First step is to handle command-line arguments. Not to be overridden by packages.
source scripts/build/termux_step_handle_arguments.sh

# Setup variables used by the build. Not to be overridden by packages.
source scripts/build/termux_step_setup_variables.sh

# Save away and restore build setups which may change between builds.
source scripts/build/termux_step_handle_buildarch.sh

# Function to get TERMUX_PKG_VERSION from build.sh
source scripts/build/termux_extract_dep_info.sh

# Function that downloads a .deb (using the termux_download function)
source scripts/build/termux_download_deb.sh

# Script to download InRelease, verify it's signature and then download Packages.xz by hash
source scripts/build/termux_step_get_repo_files.sh

# Source the package build script and start building. No to be overridden by packages.
source scripts/build/termux_step_start_build.sh

# Run just after sourcing $TERMUX_PKG_BUILDER_SCRIPT. May be overridden by packages.
source scripts/build/termux_step_extract_package.sh

# Hook for packages to act just after the package has been extracted.
# Invoked in $TERMUX_PKG_SRCDIR.
termux_step_post_extract_package() {
	return
}

# Optional host build. Not to be overridden by packages.
source scripts/build/termux_step_handle_hostbuild.sh

# Perform a host build. Will be called in $TERMUX_PKG_HOSTBUILD_DIR.
# After termux_step_post_extract_package() and before termux_step_patch_package()
source scripts/build/termux_step_host_build.sh

# Setup a standalone Android NDK toolchain. Not to be overridden by packages.
source scripts/build/termux_step_setup_toolchain.sh

# Apply all *.patch files for the package. Not to be overridden by packages.
source scripts/build/termux_step_patch_package.sh

# Replace autotools build-aux/config.{sub,guess} with ours to add android targets.
source scripts/build/termux_step_replace_guess_scripts.sh

# For package scripts to override. Called in $TERMUX_PKG_BUILDDIR.
termux_step_pre_configure() {
	return
}

# Setup configure args and run $TERMUX_PKG_SRCDIR/configure. This function is called from termux_step_configure
source scripts/build/configure/termux_step_configure_autotools.sh

termux_step_configure_cmake() {
	termux_setup_cmake

	local TOOLCHAIN_ARGS="-DCMAKE_ANDROID_STANDALONE_TOOLCHAIN=$TERMUX_STANDALONE_TOOLCHAIN"
	local BUILD_TYPE=MinSizeRel
	test -n "$TERMUX_DEBUG" && BUILD_TYPE=Debug

	local CMAKE_PROC=$TERMUX_ARCH
	test $CMAKE_PROC == "arm" && CMAKE_PROC='armv7-a'
	local MAKE_PROGRAM_PATH
	if [ $TERMUX_CMAKE_BUILD = Ninja ]; then
		termux_setup_ninja
		MAKE_PROGRAM_PATH=$(which ninja)
	else
		MAKE_PROGRAM_PATH=$(which make)
	fi
	CFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM -fno-addrsig"
	CXXFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM -fno-addrsig"
	LDFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"

	# XXX: CMAKE_{AR,RANLIB} needed for at least jsoncpp build to not
	# pick up cross compiled binutils tool in $PREFIX/bin:
	cmake -G "$TERMUX_CMAKE_BUILD" "$TERMUX_PKG_SRCDIR" \
		-DCMAKE_AR="$(which $AR)" \
		-DCMAKE_UNAME="$(which uname)" \
		-DCMAKE_RANLIB="$(which $RANLIB)" \
		-DCMAKE_BUILD_TYPE=$BUILD_TYPE \
		-DCMAKE_CROSSCOMPILING=True \
		-DCMAKE_C_FLAGS="$CFLAGS $CPPFLAGS" \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS $CPPFLAGS" \
		-DCMAKE_LINKER="$TERMUX_STANDALONE_TOOLCHAIN/bin/$LD $LDFLAGS" \
		-DCMAKE_FIND_ROOT_PATH=$TERMUX_PREFIX \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX \
		-DCMAKE_MAKE_PROGRAM=$MAKE_PROGRAM_PATH \
		-DCMAKE_SYSTEM_PROCESSOR=$CMAKE_PROC \
		-DCMAKE_SYSTEM_NAME=Android \
		-DCMAKE_SYSTEM_VERSION=$TERMUX_PKG_API_LEVEL \
		-DCMAKE_SKIP_INSTALL_RPATH=ON \
		-DCMAKE_USE_SYSTEM_LIBRARIES=True \
		-DDOXYGEN_EXECUTABLE= \
		-DBUILD_TESTING=OFF \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS $TOOLCHAIN_ARGS
}

termux_step_configure_meson() {
	termux_setup_meson
	CC=gcc CXX=g++ $TERMUX_MESON \
		$TERMUX_PKG_SRCDIR \
		$TERMUX_PKG_BUILDDIR \
		--cross-file $TERMUX_MESON_CROSSFILE \
		--prefix $TERMUX_PREFIX \
		--libdir lib \
		--buildtype minsize \
		--strip \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_configure() {
	if [ "$TERMUX_PKG_FORCE_CMAKE" == 'no' ] && [ -f "$TERMUX_PKG_SRCDIR/configure" ]; then
		termux_step_configure_autotools
	elif [ -f "$TERMUX_PKG_SRCDIR/CMakeLists.txt" ]; then
		termux_step_configure_cmake
	elif [ -f "$TERMUX_PKG_SRCDIR/meson.build" ]; then
		termux_step_configure_meson
	fi
}

termux_step_post_configure() {
	return
}

termux_step_make() {
	local QUIET_BUILD=
	if [ $TERMUX_QUIET_BUILD = true ]; then
		QUIET_BUILD="-s"
	fi

	if test -f build.ninja; then
		ninja -w dupbuild=warn -j $TERMUX_MAKE_PROCESSES
	elif ls ./*akefile &> /dev/null || [ ! -z "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
		if [ -z "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
			make -j $TERMUX_MAKE_PROCESSES $QUIET_BUILD
		else
			make -j $TERMUX_MAKE_PROCESSES $QUIET_BUILD ${TERMUX_PKG_EXTRA_MAKE_ARGS}
		fi
	fi
}

termux_step_make_install() {
	if test -f build.ninja; then
		ninja -w dupbuild=warn -j $TERMUX_MAKE_PROCESSES install
	elif ls ./*akefile &> /dev/null || [ ! -z "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
		: "${TERMUX_PKG_MAKE_INSTALL_TARGET:="install"}"
		# Some packages have problem with parallell install, and it does not buy much, so use -j 1.
		if [ -z "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
			make -j 1 ${TERMUX_PKG_MAKE_INSTALL_TARGET}
		else
			make -j 1 ${TERMUX_PKG_EXTRA_MAKE_ARGS} ${TERMUX_PKG_MAKE_INSTALL_TARGET}
		fi
	elif test -f Cargo.toml; then
		termux_setup_rust
		cargo install \
			--path . \
			--force \
			--target $CARGO_TARGET_NAME \
			--root $TERMUX_PREFIX \
			$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
		# https://github.com/rust-lang/cargo/issues/3316:
		rm $TERMUX_PREFIX/.crates.toml
	fi
}

# Hook function for package scripts to override.
termux_step_post_make_install() {
	return
}

termux_step_extract_into_massagedir() {
	local TARBALL_ORIG=$TERMUX_PKG_PACKAGEDIR/${TERMUX_PKG_NAME}_orig.tar.gz

	# Build diff tar with what has changed during the build:
	cd $TERMUX_PREFIX
	tar -N "$TERMUX_BUILD_TS_FILE" \
		--exclude='lib/libc++_shared.so' --exclude='lib/libstdc++.so' \
		-czf "$TARBALL_ORIG" .

	# Extract tar in order to massage it
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"
	cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"
	tar xf "$TARBALL_ORIG"
	rm "$TARBALL_ORIG"
}

termux_step_massage() {
	cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"

	# Remove lib/charset.alias which is installed by gettext-using packages:
	rm -f lib/charset.alias

	# Remove non-english man pages:
	test -d share/man && (cd share/man; for f in $(ls | grep -v man); do rm -Rf $f; done )

	if [ -z "${TERMUX_PKG_KEEP_INFOPAGES+x}" ]; then
		# Remove info pages:
		rm -Rf share/info
	fi

	# Remove locale files we're not interested in::
	rm -Rf share/locale
	if [ -z "${TERMUX_PKG_KEEP_SHARE_DOC+x}" ]; then
		# Remove info pages:
		rm -Rf share/doc
	fi

	# Remove old kept libraries (readline):
	find . -name '*.old' -delete

	# Remove static libraries:
	if [ $TERMUX_PKG_KEEP_STATIC_LIBRARIES = "false" ]; then
		find . -name '*.a' -delete
		find . -name '*.la' -delete
	fi

	# Move over sbin to bin:
	for file in sbin/*; do if test -f "$file"; then mv "$file" bin/; fi; done

	# Remove world permissions and add write permissions.
	# The -f flag is used to suppress warnings about dangling symlinks (such
	# as ones to /system/... which may not exist on the build machine):
	find . -exec chmod -f u+w,g-rwx,o-rwx \{\} \;

	if [ "$TERMUX_DEBUG" = "" ]; then
		# Strip binaries. file(1) may fail for certain unusual files, so disable pipefail.
		set +e +o pipefail
		find . -type f | xargs -r file | grep -E "(executable|shared object)" | grep ELF | cut -f 1 -d : | \
			xargs -r "$STRIP" --strip-unneeded --preserve-dates
		set -e -o pipefail
	fi
	# Remove DT_ entries which the android 5.1 linker warns about:
	find . -type f -print0 | xargs -r -0 "$TERMUX_ELF_CLEANER"

	# Fix shebang paths:
	while IFS= read -r -d '' file
	do
		head -c 100 "$file" | grep -E "^#\!.*\\/bin\\/.*" | grep -q -E -v "^#\! ?\\/system" && sed --follow-symlinks -i -E "1 s@^#\!(.*)/bin/(.*)@#\!$TERMUX_PREFIX/bin/\2@" "$file"
	done < <(find -L . -type f -print0)

	test ! -z "$TERMUX_PKG_RM_AFTER_INSTALL" && rm -Rf $TERMUX_PKG_RM_AFTER_INSTALL

	find . -type d -empty -delete # Remove empty directories

	if [ -d share/man ]; then
		# Compress man pages with gzip:
		find share/man -type f -print0 | xargs -r -0 gzip
		# Update man page symlinks, e.g. unzstd.1 -> zstd.1:
		while IFS= read -r -d '' file
		do
			local _link_value
			_link_value=$(readlink $file)
			rm $file
			ln -s $_link_value.gz $file.gz
		done < <(find share/man -type l -print0)
	fi

	# Sub packages:
	if [ -d include ] && [ -z "${TERMUX_PKG_NO_DEVELSPLIT}" ]; then
		# Add virtual -dev sub package if there are include files:
		local _DEVEL_SUBPACKAGE_FILE=$TERMUX_PKG_TMPDIR/${TERMUX_PKG_NAME}-dev.subpackage.sh
		echo TERMUX_SUBPKG_INCLUDE=\"include share/vala share/man/man3 lib/pkgconfig share/aclocal lib/cmake $TERMUX_PKG_INCLUDE_IN_DEVPACKAGE\" > "$_DEVEL_SUBPACKAGE_FILE"
		echo "TERMUX_SUBPKG_DESCRIPTION=\"Development files for ${TERMUX_PKG_NAME}\"" >> "$_DEVEL_SUBPACKAGE_FILE"
		if [ -n "$TERMUX_PKG_DEVPACKAGE_DEPENDS" ]; then
			echo "TERMUX_SUBPKG_DEPENDS=\"$TERMUX_PKG_NAME,$TERMUX_PKG_DEVPACKAGE_DEPENDS\"" >> "$_DEVEL_SUBPACKAGE_FILE"
		else
			echo "TERMUX_SUBPKG_DEPENDS=\"$TERMUX_PKG_NAME\"" >> "$_DEVEL_SUBPACKAGE_FILE"
		fi
	fi
	# Now build all sub packages
	rm -Rf "$TERMUX_TOPDIR/$TERMUX_PKG_NAME/subpackages"
	for subpackage in $TERMUX_PKG_BUILDER_DIR/*.subpackage.sh $TERMUX_PKG_TMPDIR/*subpackage.sh; do
		test ! -f "$subpackage" && continue
		local SUB_PKG_NAME
		SUB_PKG_NAME=$(basename "$subpackage" .subpackage.sh)
		# Default value is same as main package, but sub package may override:
		local TERMUX_SUBPKG_PLATFORM_INDEPENDENT=$TERMUX_PKG_PLATFORM_INDEPENDENT
		local SUB_PKG_DIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/subpackages/$SUB_PKG_NAME
		local TERMUX_SUBPKG_DEPENDS=""
		local TERMUX_SUBPKG_CONFLICTS=""
		local TERMUX_SUBPKG_REPLACES=""
		local TERMUX_SUBPKG_CONFFILES=""
		local SUB_PKG_MASSAGE_DIR=$SUB_PKG_DIR/massage/$TERMUX_PREFIX
		local SUB_PKG_PACKAGE_DIR=$SUB_PKG_DIR/package
		mkdir -p "$SUB_PKG_MASSAGE_DIR" "$SUB_PKG_PACKAGE_DIR"

		# shellcheck source=/dev/null
		source "$subpackage"

		for includeset in $TERMUX_SUBPKG_INCLUDE; do
			local _INCLUDE_DIRSET
			_INCLUDE_DIRSET=$(dirname "$includeset")
			test "$_INCLUDE_DIRSET" = "." && _INCLUDE_DIRSET=""
			if [ -e "$includeset" ] || [ -L "$includeset" ]; then
				# Add the -L clause to handle relative symbolic links:
				mkdir -p "$SUB_PKG_MASSAGE_DIR/$_INCLUDE_DIRSET"
				mv "$includeset" "$SUB_PKG_MASSAGE_DIR/$_INCLUDE_DIRSET"
			fi
		done

		local SUB_PKG_ARCH=$TERMUX_ARCH
		test -n "$TERMUX_SUBPKG_PLATFORM_INDEPENDENT" && SUB_PKG_ARCH=all

		cd "$SUB_PKG_DIR/massage"
		local SUB_PKG_INSTALLSIZE
		SUB_PKG_INSTALLSIZE=$(du -sk . | cut -f 1)
		tar -cJf "$SUB_PKG_PACKAGE_DIR/data.tar.xz" .

		mkdir -p DEBIAN
		cd DEBIAN
		cat > control <<-HERE
			Package: $SUB_PKG_NAME
			Architecture: ${SUB_PKG_ARCH}
			Installed-Size: ${SUB_PKG_INSTALLSIZE}
			Maintainer: $TERMUX_PKG_MAINTAINER
			Version: $TERMUX_PKG_FULLVERSION
			Homepage: $TERMUX_PKG_HOMEPAGE
		HERE
		test ! -z "$TERMUX_SUBPKG_DEPENDS" && echo "Depends: $TERMUX_SUBPKG_DEPENDS" >> control
		test ! -z "$TERMUX_SUBPKG_CONFLICTS" && echo "Conflicts: $TERMUX_SUBPKG_CONFLICTS" >> control
		test ! -z "$TERMUX_SUBPKG_REPLACES" && echo "Replaces: $TERMUX_SUBPKG_REPLACES" >> control
		echo "Description: $TERMUX_SUBPKG_DESCRIPTION" >> control
		tar -czf "$SUB_PKG_PACKAGE_DIR/control.tar.gz" .

		for f in $TERMUX_SUBPKG_CONFFILES; do echo "$TERMUX_PREFIX/$f" >> conffiles; done

		# Create the actual .deb file:
		TERMUX_SUBPKG_DEBFILE=$TERMUX_DEBDIR/${SUB_PKG_NAME}${DEBUG}_${TERMUX_PKG_FULLVERSION}_${SUB_PKG_ARCH}.deb
		test ! -f "$TERMUX_COMMON_CACHEDIR/debian-binary" && echo "2.0" > "$TERMUX_COMMON_CACHEDIR/debian-binary"
		ar cr "$TERMUX_SUBPKG_DEBFILE" \
				   "$TERMUX_COMMON_CACHEDIR/debian-binary" \
				   "$SUB_PKG_PACKAGE_DIR/control.tar.gz" \
				   "$SUB_PKG_PACKAGE_DIR/data.tar.xz"

		# Go back to main package:
		cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"
	done

	# .. remove empty directories (NOTE: keep this last):
	find . -type d -empty -delete
	# Make sure user can read and write all files (problem with dpkg otherwise):
	chmod -R u+rw .
}

termux_step_post_massage() {
	return
}

# Create data.tar.gz with files to package. Not to be overridden by package scripts.
termux_step_create_datatar() {
	# Create data tarball containing files to package:
	cd "$TERMUX_PKG_MASSAGEDIR"

	local HARDLINKS
	HARDLINKS="$(find . -type f -links +1)"
	if [ -n "$HARDLINKS" ]; then
		termux_error_exit "Package contains hard links: $HARDLINKS"
	fi

	if [ -z "${TERMUX_PKG_METAPACKAGE+x}" ] && [ "$(find . -type f)" = "" ]; then
		termux_error_exit "No files in package"
	fi
	tar -cJf "$TERMUX_PKG_PACKAGEDIR/data.tar.xz" .
}

termux_step_create_debscripts() {
	return
}

# Create the build deb file. Not to be overridden by package scripts.
termux_step_create_debfile() {
	# Get install size. This will be written as the "Installed-Size" deb field so is measured in 1024-byte blocks:
	local TERMUX_PKG_INSTALLSIZE
	TERMUX_PKG_INSTALLSIZE=$(du -sk . | cut -f 1)

	# From here on TERMUX_ARCH is set to "all" if TERMUX_PKG_PLATFORM_INDEPENDENT is set by the package
	test -n "$TERMUX_PKG_PLATFORM_INDEPENDENT" && TERMUX_ARCH=all

	mkdir -p DEBIAN
	cat > DEBIAN/control <<-HERE
		Package: $TERMUX_PKG_NAME
		Architecture: ${TERMUX_ARCH}
		Installed-Size: ${TERMUX_PKG_INSTALLSIZE}
		Maintainer: $TERMUX_PKG_MAINTAINER
		Version: $TERMUX_PKG_FULLVERSION
		Homepage: $TERMUX_PKG_HOMEPAGE
	HERE
	test ! -z "$TERMUX_PKG_BREAKS" && echo "Breaks: $TERMUX_PKG_BREAKS" >> DEBIAN/control
	test ! -z "$TERMUX_PKG_DEPENDS" && echo "Depends: $TERMUX_PKG_DEPENDS" >> DEBIAN/control
	test ! -z "$TERMUX_PKG_ESSENTIAL" && echo "Essential: yes" >> DEBIAN/control
	test ! -z "$TERMUX_PKG_CONFLICTS" && echo "Conflicts: $TERMUX_PKG_CONFLICTS" >> DEBIAN/control
	test ! -z "$TERMUX_PKG_RECOMMENDS" && echo "Recommends: $TERMUX_PKG_RECOMMENDS" >> DEBIAN/control
	test ! -z "$TERMUX_PKG_REPLACES" && echo "Replaces: $TERMUX_PKG_REPLACES" >> DEBIAN/control
	test ! -z "$TERMUX_PKG_PROVIDES" && echo "Provides: $TERMUX_PKG_PROVIDES" >> DEBIAN/control
	test ! -z "$TERMUX_PKG_SUGGESTS" && echo "Suggests: $TERMUX_PKG_SUGGESTS" >> DEBIAN/control
	echo "Description: $TERMUX_PKG_DESCRIPTION" >> DEBIAN/control

	# Create DEBIAN/conffiles (see https://www.debian.org/doc/debian-policy/ap-pkg-conffiles.html):
	for f in $TERMUX_PKG_CONFFILES; do echo "$TERMUX_PREFIX/$f" >> DEBIAN/conffiles; done

	# Allow packages to create arbitrary control files.
	# XXX: Should be done in a better way without a function?
	cd DEBIAN
	termux_step_create_debscripts

	# Create control.tar.gz
	tar -czf "$TERMUX_PKG_PACKAGEDIR/control.tar.gz" .

	test ! -f "$TERMUX_COMMON_CACHEDIR/debian-binary" && echo "2.0" > "$TERMUX_COMMON_CACHEDIR/debian-binary"
	TERMUX_PKG_DEBFILE=$TERMUX_DEBDIR/${TERMUX_PKG_NAME}${DEBUG}_${TERMUX_PKG_FULLVERSION}_${TERMUX_ARCH}.deb
	# Create the actual .deb file:
	ar cr "$TERMUX_PKG_DEBFILE" \
	       "$TERMUX_COMMON_CACHEDIR/debian-binary" \
	       "$TERMUX_PKG_PACKAGEDIR/control.tar.gz" \
	       "$TERMUX_PKG_PACKAGEDIR/data.tar.xz"
}

termux_step_compare_debs() {
	if [ "${TERMUX_INSTALL_DEPS}" = true ]; then
		cd ${TERMUX_SCRIPTDIR}

		for DEB in $TERMUX_PKG_NAME $(basename $TERMUX_PKG_BUILDER_DIR/*.subpackage.sh | sed 's%\.subpackage\.sh%%g') $(basename $TERMUX_PKG_TMPDIR/*.subpackage.sh | sed 's%\.subpackage\.sh%%g'); do
			read DEB_ARCH DEB_VERSION <<< $(termux_extract_dep_info "$DEB")
			termux_download_deb $DEB $DEB_ARCH $DEB_VERSION \
			    &&	(
				DEB_FILE=${DEB}_${DEB_VERSION}_${DEB_ARCH}.deb

				# `|| true` to prevent debdiff's exit code from stopping build
				debdiff $TERMUX_DEBDIR/$DEB_FILE $TERMUX_COMMON_CACHEDIR-$TERMUX_ARCH/$DEB_FILE || true
				) || echo "Download of ${DEB}@${DEB_VERSION} failed, not comparing debs"
			echo ""
		done
	fi
}

# Finish the build. Not to be overridden by package scripts.
termux_step_finish_build() {
	echo "termux - build of '$TERMUX_PKG_NAME' done"
	test -t 1 && printf "\033]0;%s - DONE\007" "$TERMUX_PKG_NAME"
	mkdir -p /data/data/.built-packages
	echo "$TERMUX_PKG_FULLVERSION" > "/data/data/.built-packages/$TERMUX_PKG_NAME"
	exit 0
}

termux_step_handle_arguments "$@"
termux_step_setup_variables
termux_step_handle_buildarch
termux_step_get_repo_files
termux_step_start_build
termux_step_extract_package
cd "$TERMUX_PKG_SRCDIR"
termux_step_post_extract_package
termux_step_handle_hostbuild
termux_step_setup_toolchain
termux_step_patch_package
termux_step_replace_guess_scripts
cd "$TERMUX_PKG_SRCDIR"
termux_step_pre_configure
cd "$TERMUX_PKG_BUILDDIR"
termux_step_configure
cd "$TERMUX_PKG_BUILDDIR"
termux_step_post_configure
cd "$TERMUX_PKG_BUILDDIR"
termux_step_make
cd "$TERMUX_PKG_BUILDDIR"
termux_step_make_install
cd "$TERMUX_PKG_BUILDDIR"
termux_step_post_make_install
cd "$TERMUX_PKG_MASSAGEDIR"
termux_step_extract_into_massagedir
cd "$TERMUX_PKG_MASSAGEDIR"
termux_step_massage
cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"
termux_step_post_massage
termux_step_create_datatar
termux_step_create_debfile
termux_step_compare_debs
termux_step_finish_build
