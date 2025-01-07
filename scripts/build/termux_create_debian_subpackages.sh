termux_create_debian_subpackages() {
	# Sub packages:
	local _ADD_PREFIX=""
	if [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		_ADD_PREFIX="glibc/"
	fi
	if [ "$TERMUX_PKG_NO_STATICSPLIT" = "false" ] && [[ -n $(shopt -s globstar; shopt -s nullglob; echo ${_ADD_PREFIX}lib/**/*.a) ]]; then
		# Add virtual -static sub package if there are include files:
		local _STATIC_SUBPACKAGE_FILE=$TERMUX_PKG_TMPDIR/${TERMUX_PKG_NAME}-static.subpackage.sh
		echo TERMUX_SUBPKG_INCLUDE=\"$(find ${_ADD_PREFIX}lib -name '*.a' -o -name '*.la') $TERMUX_PKG_STATICSPLIT_EXTRA_PATTERNS\" > "$_STATIC_SUBPACKAGE_FILE"
		echo "TERMUX_SUBPKG_DESCRIPTION=\"Static libraries for ${TERMUX_PKG_NAME}\"" >> "$_STATIC_SUBPACKAGE_FILE"
	fi

	# Now build all sub packages
	rm -Rf "$TERMUX_TOPDIR/$TERMUX_PKG_NAME/subpackages"
	for subpackage in $TERMUX_PKG_BUILDER_DIR/*.subpackage.sh $TERMUX_PKG_TMPDIR/*subpackage.sh; do
		test ! -f "$subpackage" && continue
		local SUB_PKG_NAME
		SUB_PKG_NAME=$(basename "$subpackage" .subpackage.sh)
		if [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ] && ! termux_package__is_package_name_have_glibc_prefix "$SUB_PKG_NAME"; then
			SUB_PKG_NAME="$(termux_package__add_prefix_glibc_to_package_name ${SUB_PKG_NAME})"
		fi
		# Default value is same as main package, but sub package may override:
		local TERMUX_SUBPKG_PLATFORM_INDEPENDENT=$TERMUX_PKG_PLATFORM_INDEPENDENT
		local SUB_PKG_DIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/subpackages/$SUB_PKG_NAME
		local TERMUX_SUBPKG_ESSENTIAL=false
		local TERMUX_SUBPKG_BREAKS=""
		local TERMUX_SUBPKG_DEPENDS=""
		local TERMUX_SUBPKG_RECOMMENDS=""
		local TERMUX_SUBPKG_SUGGESTS=""
		local TERMUX_SUBPKG_CONFLICTS=""
		local TERMUX_SUBPKG_REPLACES=""
		local TERMUX_SUBPKG_PROVIDES=""
		local TERMUX_SUBPKG_CONFFILES=""
		local TERMUX_SUBPKG_DEPEND_ON_PARENT=""
		local TERMUX_SUBPKG_EXCLUDED_ARCHES=""
		local SUB_PKG_MASSAGE_DIR=$SUB_PKG_DIR/massage/$TERMUX_PREFIX_CLASSICAL
		local SUB_PKG_PACKAGE_DIR=$SUB_PKG_DIR/package
		mkdir -p "$SUB_PKG_MASSAGE_DIR" "$SUB_PKG_PACKAGE_DIR"

		# Override termux_step_create_subpkg_debscripts
		# shellcheck source=/dev/null
		source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_create_subpkg_debscripts.sh"

		# shellcheck source=/dev/null
		source "$subpackage"

		# Allow globstar (i.e. './**/') patterns.
		shopt -s globstar
		# Allow negation patterns.
		shopt -s extglob
		for includeset in $TERMUX_SUBPKG_INCLUDE; do
			local _INCLUDE_DIRSET
			_INCLUDE_DIRSET=$(dirname "$includeset")
			test "$_INCLUDE_DIRSET" = "." && _INCLUDE_DIRSET=""

			if [ -e "$includeset" ] || [ -L "$includeset" ]; then
				# Add the -L clause to handle relative symbolic links:
				mkdir -p "$SUB_PKG_MASSAGE_DIR/$_INCLUDE_DIRSET"
				mv "$includeset" "$SUB_PKG_MASSAGE_DIR/$_INCLUDE_DIRSET"
			else
				echo "WARNING: tried to add $includeset to subpackage '$SUB_PKG_NAME', but could not find it"
			fi
		done
		shopt -u globstar extglob

		# Do not create subpackage for specific arches.
		# Using TERMUX_ARCH instead of SUB_PKG_ARCH (defined below) is intentional.
		if [ "$TERMUX_SUBPKG_EXCLUDED_ARCHES" != "${TERMUX_SUBPKG_EXCLUDED_ARCHES/$TERMUX_ARCH}" ]; then
			echo "Skipping creating subpackage '$SUB_PKG_NAME' for arch $TERMUX_ARCH"
			continue
		fi

		local SUB_PKG_ARCH=$TERMUX_ARCH
		[ "$TERMUX_SUBPKG_PLATFORM_INDEPENDENT" = "true" ] && SUB_PKG_ARCH=all

		cd "$SUB_PKG_DIR/massage"
		# Check that files were actually installed, else don't subpackage.
		if [ "$SUB_PKG_ARCH" = "all" ] && [ "$(find . -type f -print | head -n1)" = "" ]; then
			echo "No files in subpackage '$SUB_PKG_NAME' when built for $SUB_PKG_ARCH with package '$TERMUX_PKG_NAME', so"
			echo "the subpackage was not created. If unexpected, check to make sure the files are where you expect."
			cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL"
			continue
		fi
		local SUB_PKG_INSTALLSIZE
		SUB_PKG_INSTALLSIZE=$(du -sk . | cut -f 1)
		tar --sort=name \
			--mtime="@${SOURCE_DATE_EPOCH}" \
			--owner=0 --group=0 --numeric-owner \
			-cJf "$SUB_PKG_PACKAGE_DIR/data.tar.xz" .

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

		local PKG_DEPS_SPC=" ${TERMUX_PKG_DEPENDS//,/} "

		if [ -z "$TERMUX_SUBPKG_DEPEND_ON_PARENT" ] && [ "${PKG_DEPS_SPC/ $SUB_PKG_NAME /}" = "$PKG_DEPS_SPC" ] || [ "$TERMUX_SUBPKG_DEPEND_ON_PARENT" = "true" ]; then
			TERMUX_SUBPKG_DEPENDS+=", $TERMUX_PKG_NAME (= $TERMUX_PKG_FULLVERSION)"
		elif [ "$TERMUX_SUBPKG_DEPEND_ON_PARENT" = unversioned ]; then
			TERMUX_SUBPKG_DEPENDS+=", $TERMUX_PKG_NAME"
		elif [ "$TERMUX_SUBPKG_DEPEND_ON_PARENT" = deps ]; then
			TERMUX_SUBPKG_DEPENDS+=", $TERMUX_PKG_DEPENDS"
		fi

		if [ "$TERMUX_GLOBAL_LIBRARY" = "true" ] && [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
			test ! -z "$TERMUX_SUBPKG_DEPENDS" && TERMUX_SUBPKG_DEPENDS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_SUBPKG_DEPENDS")
			test ! -z "$TERMUX_SUBPKG_BREAKS" && TERMUX_SUBPKG_BREAKS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_SUBPKG_BREAKS")
			test ! -z "$TERMUX_SUBPKG_CONFLICTS" && TERMUX_SUBPKG_CONFLICTS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_SUBPKG_CONFLICTS")
			test ! -z "$TERMUX_SUBPKG_RECOMMENDS" && TERMUX_SUBPKG_RECOMMENDS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_SUBPKG_RECOMMENDS")
			test ! -z "$TERMUX_SUBPKG_REPLACES" && TERMUX_SUBPKG_REPLACES=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_SUBPKG_REPLACES")
			test ! -z "$TERMUX_SUBPKG_PROVIDES" && TERMUX_SUBPKG_PROVIDES=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_SUBPKG_PROVIDES")
			test ! -z "$TERMUX_SUBPKG_SUGGESTS" && TERMUX_SUBPKG_SUGGESTS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_SUBPKG_SUGGESTS")
		fi

		[ "$TERMUX_SUBPKG_ESSENTIAL" = "true" ] && echo "Essential: yes" >> control
		test ! -z "$TERMUX_SUBPKG_DEPENDS" && echo "Depends: ${TERMUX_SUBPKG_DEPENDS/#, /}" >> control
		test ! -z "$TERMUX_SUBPKG_BREAKS" && echo "Breaks: $TERMUX_SUBPKG_BREAKS" >> control
		test ! -z "$TERMUX_SUBPKG_CONFLICTS" && echo "Conflicts: $TERMUX_SUBPKG_CONFLICTS" >> control
		test ! -z "$TERMUX_SUBPKG_RECOMMENDS" && echo "Recommends: $TERMUX_SUBPKG_RECOMMENDS" >> control
		test ! -z "$TERMUX_SUBPKG_REPLACES" && echo "Replaces: $TERMUX_SUBPKG_REPLACES" >> control
		test ! -z "$TERMUX_SUBPKG_PROVIDES" && echo "Provides: $TERMUX_SUBPKG_PROVIDES" >> control
		test ! -z "$TERMUX_SUBPKG_SUGGESTS" && echo "Suggests: $TERMUX_SUBPKG_SUGGESTS" >> control
		echo "Description: $TERMUX_SUBPKG_DESCRIPTION" >> control

		for f in $TERMUX_SUBPKG_CONFFILES; do echo "$TERMUX_PREFIX_CLASSICAL/$f" >> conffiles; done

		# Allow packages to create arbitrary control files.
		termux_step_create_subpkg_debscripts

		# Create control.tar.xz
		tar --sort=name \
			--mtime="@${SOURCE_DATE_EPOCH}" \
			--owner=0 --group=0 --numeric-owner \
			-cJf "$SUB_PKG_PACKAGE_DIR/control.tar.xz" -H gnu .

		# Create the actual .deb file:
		TERMUX_SUBPKG_DEBFILE=$TERMUX_OUTPUT_DIR/${SUB_PKG_NAME}${DEBUG}_${TERMUX_PKG_FULLVERSION}_${SUB_PKG_ARCH}.deb
		test ! -f "$TERMUX_COMMON_CACHEDIR/debian-binary" && echo "2.0" > "$TERMUX_COMMON_CACHEDIR/debian-binary"
		${AR-ar} cr "$TERMUX_SUBPKG_DEBFILE" \
				   "$TERMUX_COMMON_CACHEDIR/debian-binary" \
				   "$SUB_PKG_PACKAGE_DIR/control.tar.xz" \
				   "$SUB_PKG_PACKAGE_DIR/data.tar.xz"

		# Go back to main package:
		cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL"
	done
}
