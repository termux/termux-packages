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

# Setup configure args and run cmake. This function is called from termux_step_configure
source scripts/build/configure/termux_step_configure_cmake.sh

# Setup configure args and run meson. This function is called from termux_step_configure
source scripts/build/configure/termux_step_configure_meson.sh

# Configure the package
source scripts/build/configure/termux_step_configure.sh

termux_step_post_configure() {
	return
}

# Make package, either with ninja or make
source scripts/build/termux_step_make.sh

# Make install, either with ninja, make of cargo
source scripts/build/termux_step_make_install.sh

# Hook function for package scripts to override.
termux_step_post_make_install() {
	return
}

# Function to cp (through tar) installed files to massage dir
source scripts/build/termux_step_extract_into_massagedir.sh

# Function to run various cleanup/fixes
source scripts/build/termux_step_massage.sh

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
