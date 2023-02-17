termux_create_pacman_subpackages() {
	# Sub packages:
	if [ "$TERMUX_PKG_NO_STATICSPLIT" = "false" ] && [[ -n $(shopt -s globstar; shopt -s nullglob; echo lib/**/*.a) ]]; then
		# Add virtual -static sub package if there are include files:
		local _STATIC_SUBPACKAGE_FILE=$TERMUX_PKG_TMPDIR/${TERMUX_PKG_NAME}-static.subpackage.sh
		echo TERMUX_SUBPKG_INCLUDE=\"$(find lib -name '*.a' -o -name '*.la') $TERMUX_PKG_STATICSPLIT_EXTRA_PATTERNS\" > "$_STATIC_SUBPACKAGE_FILE"
		echo "TERMUX_SUBPKG_DESCRIPTION=\"Static libraries for ${TERMUX_PKG_NAME}\"" >> "$_STATIC_SUBPACKAGE_FILE"
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
		local TERMUX_SUBPKG_GROUPS=""
		local SUB_PKG_MASSAGE_DIR=$SUB_PKG_DIR/massage/$TERMUX_PREFIX
		local SUB_PKG_PACKAGE_DIR=$SUB_PKG_DIR/package
		mkdir -p "$SUB_PKG_MASSAGE_DIR" "$SUB_PKG_PACKAGE_DIR"

		# Override termux_step_create_subpkg_debscripts
		# shellcheck source=/dev/null
		source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_create_subpkg_debscripts.sh"

		# shellcheck source=/dev/null
		source "$subpackage"

		# Allow globstar (i.e. './**/') patterns.
		shopt -s globstar
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
		shopt -u globstar

		local SUB_PKG_ARCH=$TERMUX_ARCH
		[ "$TERMUX_SUBPKG_PLATFORM_INDEPENDENT" = "true" ] && SUB_PKG_ARCH=any

		cd "$SUB_PKG_DIR/massage"
		local SUB_PKG_INSTALLSIZE
		SUB_PKG_INSTALLSIZE=$(du -bs . | cut -f 1)

		local BUILD_DATE
		BUILD_DATE=$(date +%s)

		local PKG_DEPS_SPC=" ${TERMUX_PKG_DEPENDS//,/} "
		if [ -z "$TERMUX_SUBPKG_DEPEND_ON_PARENT" ] && [ "${PKG_DEPS_SPC/ $SUB_PKG_NAME /}" = "$PKG_DEPS_SPC" ]; then
			# Does pacman supports versioned dependencies?
			#TERMUX_SUBPKG_DEPENDS+=", $TERMUX_PKG_NAME (= $TERMUX_PKG_FULLVERSION)"
			TERMUX_SUBPKG_DEPENDS+=", $TERMUX_PKG_NAME"
		elif [ "$TERMUX_SUBPKG_DEPEND_ON_PARENT" = unversioned ]; then
			TERMUX_SUBPKG_DEPENDS+=", $TERMUX_PKG_NAME"
		elif [ "$TERMUX_SUBPKG_DEPEND_ON_PARENT" = deps ]; then
			TERMUX_SUBPKG_DEPENDS+=", $TERMUX_PKG_DEPENDS"
		fi

		# Package metadata.
		{
			echo "pkgname = $SUB_PKG_NAME"
			echo "pkgbase = $TERMUX_PKG_NAME"
			echo "pkgver = $TERMUX_PKG_FULLVERSION_FOR_PACMAN"
			echo "pkgdesc = $(echo "$TERMUX_SUBPKG_DESCRIPTION" | tr '\n' ' ')"
			echo "url = $TERMUX_PKG_HOMEPAGE"
			echo "builddate = $BUILD_DATE"
			echo "packager = $TERMUX_PKG_MAINTAINER"
			echo "size = $SUB_PKG_INSTALLSIZE"
			echo "arch = $SUB_PKG_ARCH"

			if [ -n "$TERMUX_SUBPKG_REPLACES" ]; then
				tr ',' '\n' <<< "$TERMUX_SUBPKG_REPLACES" | sed 's|(||g; s|)||g; s| ||g; s|>>|>|g; s|<<|<|g' | awk '{ printf "replaces = " $1; if ( ($1 ~ /</ || $1 ~ />/ || $1 ~ /=/) && $1 !~ /-/ ) printf "-0"; printf "\n" }'
			fi

			if [ -n "$TERMUX_SUBPKG_CONFLICTS" ]; then
				tr ',' '\n' <<< "$TERMUX_SUBPKG_CONFLICTS" | sed 's|(||g; s|)||g; s| ||g; s|>>|>|g; s|<<|<|g' | awk '{ printf "conflict = " $1; if ( ($1 ~ /</ || $1 ~ />/ || $1 ~ /=/) && $1 !~ /-/ ) printf "-0"; printf "\n" }'
			fi

			if [ -n "$TERMUX_SUBPKG_BREAKS" ]; then
				tr ',' '\n' <<< "$TERMUX_SUBPKG_BREAKS" | sed 's|(||g; s|)||g; s| ||g; s|>>|>|g; s|<<|<|g' | awk '{ printf "conflict = " $1; if ( ($1 ~ /</ || $1 ~ />/ || $1 ~ /=/) && $1 !~ /-/ ) printf "-0"; printf "\n" }'
			fi

			if [ -n "$TERMUX_SUBPKG_PROVIDES" ]; then
				tr ',' '\n' <<< "$TERMUX_SUBPKG_REPLACES" | sed 's|(||g; s|)||g; s| ||g; s|>>|>|g; s|<<|<|g' | awk '{ printf "provides = " $1; if ( ($1 ~ /</ || $1 ~ />/ || $1 ~ /=/) && $1 !~ /-/ ) printf "-0"; printf "\n" }'
			fi

			if [ -n "$TERMUX_SUBPKG_DEPENDS" ]; then
				tr ',' '\n' <<< "${TERMUX_SUBPKG_DEPENDS/#, /}" | sed 's|(||g; s|)||g; s| ||g; s|>>|>|g; s|<<|<|g' | awk '{ printf "depend = " $1; if ( ($1 ~ /</ || $1 ~ />/ || $1 ~ /=/) && $1 !~ /-/ ) printf "-0"; printf "\n" }' | sed 's/|.*//'
			fi

			if [ -n "$TERMUX_SUBPKG_RECOMMENDS" ]; then
				tr ',' '\n' <<< "$TERMUX_SUBPKG_RECOMMENDS" | awk '{ printf "optdepend = %s\n", $1 }'
			fi

			if [ -n "$TERMUX_SUBPKG_SUGGESTS" ]; then
				tr ',' '\n' <<< "$TERMUX_SUBPKG_SUGGESTS" | awk '{ printf "optdepend = %s\n", $1 }'
			fi

			if [ -n "$TERMUX_SUBPKG_CONFFILES" ]; then
				tr ',' '\n' <<< "$TERMUX_SUBPKG_CONFFILES" | awk '{ printf "backup = '"${TERMUX_PREFIX:1}"'/%s\n", $1 }'
			fi

			if [ -n "$TERMUX_SUBPKG_GROUPS" ]; then
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
			echo "builddate = $BUILD_DATE"
		} > .BUILDINFO

		# Write package installation hooks.
		termux_step_create_subpkg_debscripts
		termux_step_create_pacman_install_hook

		# Configuring the selection of a copress for a batch.
		local COMPRESS
		local PKG_FORMAT
		case $TERMUX_PACMAN_PACKAGE_COMPRESSION in
			"gzip")
				COMPRESS=(gzip -c -f -n)
				PKG_FORMAT="gz";;
			"bzip2")
				COMPRESS=(bzip2 -c -f)
				PKG_FORMAT="bz2";;
			"zstd")
				COMPRESS=(zstd -c -z -q -)
				PKG_FORMAT="zst";;
			"lrzip")
				COMPRESS=(lrzip -q)
				PKG_FORMAT="lrz";;
			"lzop")
				COMPRESS=(lzop -q)
				PKG_FORMAT="lzop";;
			"lz4")
				COMPRESS=(lz4 -q)
				PKG_FORMAT="lz4";;
			"lzip")
				COMPRESS=(lzip -c -f)
				PKG_FORMAT="lz";;
			"xz" | *)
				COMPRESS=(xz -c -z -)
				PKG_FORMAT="xz";;
		esac

		# Create the actual .pkg file:
		local TERMUX_SUBPKG_PACMAN_FILE=$TERMUX_OUTPUT_DIR/${SUB_PKG_NAME}${DEBUG}-${TERMUX_PKG_FULLVERSION_FOR_PACMAN}-${SUB_PKG_ARCH}.pkg.tar.${PKG_FORMAT}
		shopt -s dotglob globstar
		printf '%s\0' **/* | bsdtar -cnf - --format=mtree \
			--options='!all,use-set,type,uid,gid,mode,time,size,md5,sha256,link' \
			--null --files-from - --exclude .MTREE | \
			gzip -c -f -n > .MTREE
		printf '%s\0' **/* | bsdtar --no-fflags -cnf - --null --files-from - | \
			$COMPRESS > "$TERMUX_SUBPKG_PACMAN_FILE"
		shopt -u dotglob globstar

		# Go back to main package:
		cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"
	done
}
