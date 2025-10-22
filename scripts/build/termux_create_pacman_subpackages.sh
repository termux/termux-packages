termux_create_pacman_subpackages() {
	local TERMUX_PKG_FILE TERMUX_PKG_ARCH TERMUX_PACMAN_PACKAGE_COMPRESS_CMD TERMUX_PARENT_DEPEND_ON_SUBPKG

	# Now build all sub packages
	rm -Rf "$TERMUX_TOPDIR/$TERMUX_PKG_NAME/subpackages"
	for subpackage in "${TERMUX_PKG_SUBPACKAGES_LIST[@]}"; do
		if [ ! -f "$subpackage" ]; then
			termux_error_exit "Failed to find subpackage build file \"$subpackage\" of package \"$TERMUX_PKG_NAME\""
		fi

		local SUB_PKG_NAME
		SUB_PKG_NAME=$(basename "$subpackage" .subpackage.sh)
		if [[ "$TERMUX_PACKAGE_LIBRARY" == 'glibc' ]] && ! termux_package__is_package_name_have_glibc_prefix "$SUB_PKG_NAME"; then
			SUB_PKG_NAME="$(termux_package__add_prefix_glibc_to_package_name ${SUB_PKG_NAME})"
		fi

		# Default value is same as main package, but sub package may override:
		local TERMUX_SUBPKG_PLATFORM_INDEPENDENT="$TERMUX_PKG_PLATFORM_INDEPENDENT"
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
		local TERMUX_SUBPKG_GROUPS=""
		local SUB_PKG_MASSAGE_DIR=$SUB_PKG_DIR/massage/$TERMUX_PREFIX_CLASSICAL
		local SUB_PKG_PACKAGE_DIR=$SUB_PKG_DIR/package
		mkdir -p "$SUB_PKG_MASSAGE_DIR" "$SUB_PKG_PACKAGE_DIR"

		# Override termux_step_create_subpkg_debscripts
		# shellcheck source=/dev/null
		source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_create_subpkg_debscripts.sh"

		# shellcheck source=/dev/null
		source "$subpackage"

		# Do not create subpackage for specific arches.
		# Using TERMUX_ARCH instead of SUB_PKG_ARCH (defined below) is intentional.
		if [[ " ${TERMUX_SUBPKG_EXCLUDED_ARCHES//,/ } " == *" ${TERMUX_ARCH} "* ]]; then
			echo "Skipping creating subpackage '$SUB_PKG_NAME' for arch $TERMUX_ARCH"
			continue
		fi

		# Allow globstar (i.e. './**/') patterns.
		shopt -s globstar
		for includeset in $TERMUX_SUBPKG_INCLUDE; do
			local _INCLUDE_DIRSET
			_INCLUDE_DIRSET=$(dirname "$includeset")
			[[ "$_INCLUDE_DIRSET" == "." ]] && _INCLUDE_DIRSET=""

			if [[ -e "$includeset" || -L "$includeset" ]]; then
				# Add the -L clause to handle relative symbolic links:
				mkdir -p "$SUB_PKG_MASSAGE_DIR/$_INCLUDE_DIRSET"
				mv "$includeset" "$SUB_PKG_MASSAGE_DIR/$_INCLUDE_DIRSET"
			fi
		done
		shopt -u globstar

		# Do not create subpackage for specific arches.
		# Using TERMUX_ARCH instead of SUB_PKG_ARCH (defined below) is intentional.
		if [[ " ${TERMUX_SUBPKG_EXCLUDED_ARCHES//,/ } " == *" ${TERMUX_ARCH} "* ]]; then
			echo "Skipping creating subpackage '$SUB_PKG_NAME' for arch $TERMUX_ARCH"
			continue
		fi

		termux_package__does_dependency_exists_in_dependencies_list TERMUX_PARENT_DEPEND_ON_SUBPKG "$SUB_PKG_NAME" "$TERMUX_PKG_DEPENDS"
		termux_package__does_dependency_exists_in_dependencies_list TERMUX_PARENT_BUILD_DEPEND_ON_SUBPKG "$SUB_PKG_NAME" "$TERMUX_PKG_BUILD_DEPENDS"

		if [ "$SUB_PKG_NAME" != "$TERMUX_ORIG_PKG_NAME" ] &&
			[ "$TERMUX_PKGS__BUILD__NO_BUILD_UNNEEDED_SUBPACKAGES" = "true" ] &&
			[ "$TERMUX_PARENT_DEPEND_ON_SUBPKG" = "false" ] && [ "$TERMUX_PARENT_BUILD_DEPEND_ON_SUBPKG" = "false" ]; then
			echo "Not building subpackage \"$SUB_PKG_NAME\" of package \"$TERMUX_PKG_NAME\" since its not a dependency of parent package and TERMUX_PKGS__BUILD__NO_BUILD_UNNEEDED_SUBPACKAGES is enabled"
			continue
		fi

		# Set `TERMUX_PKG_FILE`, `TERMUX_PKG_ARCH` and `TERMUX_PACMAN_PACKAGE_COMPRESS_CMD`.
		termux_set_package_file_variables "$SUB_PKG_NAME" "true"
		shell__validate_variable_set TERMUX_PKG_FILE termux_create_pacman_subpackages " for subpackage \"$SUB_PKG_NAME\" of package \"$TERMUX_PKG_NAME\"" || exit $?
		shell__validate_variable_set TERMUX_PKG_ARCH termux_create_pacman_subpackages " for subpackage \"$SUB_PKG_NAME\" of package \"$TERMUX_PKG_NAME\"" || exit $?
		shell__validate_variable_set TERMUX_PACMAN_PACKAGE_COMPRESS_CMD termux_create_pacman_subpackages " for subpackage \"$SUB_PKG_NAME\" of package \"$TERMUX_PKG_NAME\"" || exit $?

		# From here on `SUB_PKG_ARCH` is set to `all` if `TERMUX_SUBPKG_PLATFORM_INDEPENDENT` is set by the subpackage.
		local SUB_PKG_ARCH="$TERMUX_PKG_ARCH"

		cd "$SUB_PKG_DIR/massage"
		# Check that files were actually installed, else don't subpackage.
		if [[ "$SUB_PKG_ARCH" == "any" && "$(find . -type f -print | head -n1)" == "" ]]; then
			echo "No files in subpackage '$SUB_PKG_NAME' when built for $SUB_PKG_ARCH with package '$TERMUX_PKG_NAME', so"
			echo "the subpackage was not created. If unexpected, check to make sure the files are where you expect."
			cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL"
			continue
		fi
		local SUB_PKG_INSTALLSIZE
		SUB_PKG_INSTALLSIZE=$(du -bs . | cut -f 1)

		# If the subpackage is not in the $TERMUX_PKG_DEPENDS for the parent package,
		# and TERMUX_SUBPKG_DEPEND_ON_PARENT doesn't have a value, the subpackage should depend on its parent
		[ "$TERMUX_PARENT_DEPEND_ON_SUBPKG" = "false" ] && : "${TERMUX_SUBPKG_DEPEND_ON_PARENT:=true}"

		case "$TERMUX_SUBPKG_DEPEND_ON_PARENT" in
			'unversioned') TERMUX_SUBPKG_DEPENDS+=", $TERMUX_PKG_NAME";;
			'deps')        TERMUX_SUBPKG_DEPENDS+=", $TERMUX_PKG_DEPENDS";;
			# TODO: pacman does support versioned dependencies
			# but we are not currently translating the .DEB notation to pacman's
			'true')        TERMUX_SUBPKG_DEPENDS+=", $TERMUX_PKG_NAME";;
			*) ;;
		esac

		[[ "$TERMUX_GLOBAL_LIBRARY" == 'true' && "$TERMUX_PACKAGE_LIBRARY" == 'glibc' ]] && {
			[[ -n "$TERMUX_SUBPKG_DEPENDS"    ]] && TERMUX_SUBPKG_DEPENDS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_SUBPKG_DEPENDS")
			[[ -n "$TERMUX_SUBPKG_BREAKS"     ]] && TERMUX_SUBPKG_BREAKS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_SUBPKG_BREAKS")
			[[ -n "$TERMUX_SUBPKG_CONFLICTS"  ]] && TERMUX_SUBPKG_CONFLICTS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_SUBPKG_CONFLICTS")
			[[ -n "$TERMUX_SUBPKG_RECOMMENDS" ]] && TERMUX_SUBPKG_RECOMMENDS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_SUBPKG_RECOMMENDS")
			[[ -n "$TERMUX_SUBPKG_REPLACES"   ]] && TERMUX_SUBPKG_REPLACES=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_SUBPKG_REPLACES")
			[[ -n "$TERMUX_SUBPKG_PROVIDES"   ]] && TERMUX_SUBPKG_PROVIDES=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_SUBPKG_PROVIDES")
			[[ -n "$TERMUX_SUBPKG_SUGGESTS"   ]] && TERMUX_SUBPKG_SUGGESTS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_SUBPKG_SUGGESTS")
		}

		# Package metadata.
		{
			echo "pkgname = $SUB_PKG_NAME"
			echo "pkgbase = $TERMUX_PKG_NAME"
			echo "pkgver = $TERMUX_PKG_FULLVERSION_FOR_PACMAN"
			echo "pkgdesc = $(echo "$TERMUX_SUBPKG_DESCRIPTION" | tr '\n' ' ')"
			echo "url = $TERMUX_PKG_HOMEPAGE"
			echo "builddate = $SOURCE_DATE_EPOCH"
			echo "packager = $TERMUX_PKG_MAINTAINER"
			echo "size = $SUB_PKG_INSTALLSIZE"
			echo "arch = $SUB_PKG_ARCH"

			if [[ -n "$TERMUX_SUBPKG_REPLACES" ]]; then
				tr ',' '\n' <<< "$TERMUX_SUBPKG_REPLACES" | sed 's|(||g; s|)||g; s| ||g; s|>>|>|g; s|<<|<|g' | awk '{ printf "replaces = " $1; if ( ($1 ~ /</ || $1 ~ />/ || $1 ~ /=/) && $1 !~ /-/ ) printf "-0"; printf "\n" }'
			fi

			if [[ -n "$TERMUX_SUBPKG_CONFLICTS" ]]; then
				tr ',' '\n' <<< "$TERMUX_SUBPKG_CONFLICTS" | sed 's|(||g; s|)||g; s| ||g; s|>>|>|g; s|<<|<|g' | awk '{ printf "conflict = " $1; if ( ($1 ~ /</ || $1 ~ />/ || $1 ~ /=/) && $1 !~ /-/ ) printf "-0"; printf "\n" }'
			fi

			if [[ -n "$TERMUX_SUBPKG_BREAKS" ]]; then
				tr ',' '\n' <<< "$TERMUX_SUBPKG_BREAKS" | sed 's|(||g; s|)||g; s| ||g; s|>>|>|g; s|<<|<|g' | awk '{ printf "conflict = " $1; if ( ($1 ~ /</ || $1 ~ />/ || $1 ~ /=/) && $1 !~ /-/ ) printf "-0"; printf "\n" }'
			fi

			if [[ -n "$TERMUX_SUBPKG_PROVIDES" ]]; then
				tr ',' '\n' <<< "$TERMUX_SUBPKG_PROVIDES" | sed 's|(||g; s|)||g; s| ||g; s|>>|>|g; s|<<|<|g' | awk '{ printf "provides = " $1; if ( ($1 ~ /</ || $1 ~ />/ || $1 ~ /=/) && $1 !~ /-/ ) printf "-0"; printf "\n" }'
			fi

			if [[ -n "$TERMUX_SUBPKG_DEPENDS" ]]; then
				tr ',' '\n' <<< "${TERMUX_SUBPKG_DEPENDS/#, /}" | sed 's|(||g; s|)||g; s| ||g; s|>>|>|g; s|<<|<|g' | awk '{ printf "depend = " $1; if ( ($1 ~ /</ || $1 ~ />/ || $1 ~ /=/) && $1 !~ /-/ ) printf "-0"; printf "\n" }' | sed 's/|.*//'
			fi

			if [[ -n "$TERMUX_SUBPKG_RECOMMENDS" ]]; then
				tr ',' '\n' <<< "$TERMUX_SUBPKG_RECOMMENDS" | awk '{ printf "optdepend = %s\n", $1 }'
			fi

			if [[ -n "$TERMUX_SUBPKG_SUGGESTS" ]]; then
				tr ',' '\n' <<< "$TERMUX_SUBPKG_SUGGESTS" | awk '{ printf "optdepend = %s\n", $1 }'
			fi

			if [[ -n "$TERMUX_SUBPKG_CONFFILES" ]]; then
				tr ',' '\n' <<< "$TERMUX_SUBPKG_CONFFILES" | awk '{ printf "backup = '"${TERMUX_PREFIX_CLASSICAL:1}"'/%s\n", $1 }'
			fi

			if [[ -n "$TERMUX_SUBPKG_GROUPS" ]]; then
				tr ',' '\n' <<< "${TERMUX_SUBPKG_GROUPS/#, /}" | awk '{ printf "group = %s\n", $1 }'
			fi
		} > .PKGINFO

		# Build metadata.
		{
			echo "format = 2"
			echo "pkgname = $SUB_PKG_NAME"
			echo "pkgbase = $TERMUX_PKG_NAME"
			echo "pkgver = $TERMUX_PKG_FULLVERSION_FOR_PACMAN"
			echo "pkgarch = $SUB_PKG_ARCH"
			echo "packager = $TERMUX_PKG_MAINTAINER"
			echo "builddate = $SOURCE_DATE_EPOCH"
		} > .BUILDINFO

		# Write package installation hooks.
		termux_step_create_subpkg_debscripts
		termux_step_create_pacman_install_hook

		# ensure all elements of the package have the same mtime
		find . -exec touch -h -d @$SOURCE_DATE_EPOCH {} +

		# Create the actual .pkg file:
		shopt -s dotglob globstar
		printf '%s\0' **/* | bsdtar -cnf - --format=mtree \
			--options='!all,use-set,type,uid,gid,mode,time,size,md5,sha256,link' \
			--null --files-from - --exclude .MTREE | \
			gzip -c -f -n > .MTREE
		touch -d @$SOURCE_DATE_EPOCH .MTREE
		printf '%s\0' **/* | bsdtar --no-fflags -cnf - --null --files-from - | \
			"${TERMUX_PACMAN_PACKAGE_COMPRESS_CMD[@]}" > "$TERMUX_PKG_FILE"
		shopt -u dotglob globstar

		# Go back to main package:
		cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL"
	done
}
