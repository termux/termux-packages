termux_step_create_debian_package() {
	if [ "$TERMUX_PKG_METAPACKAGE" = "true" ]; then
		# Metapackage doesn't have data inside.
		rm -rf data
	fi
	tar --sort=name \
		--mtime="@${SOURCE_DATE_EPOCH}" \
		--owner=0 --group=0 --numeric-owner \
		-cJf "$TERMUX_PKG_PACKAGEDIR/data.tar.xz" -H gnu .

	# Get install size. This will be written as the "Installed-Size" deb field so is measured in 1024-byte blocks:
	local TERMUX_PKG_INSTALLSIZE
	TERMUX_PKG_INSTALLSIZE=$(du -sk . | cut -f 1)

	# From here on TERMUX_ARCH is set to "all" if TERMUX_PKG_PLATFORM_INDEPENDENT is set by the package
	[ "$TERMUX_PKG_PLATFORM_INDEPENDENT" = "true" ] && TERMUX_ARCH=all

	mkdir -p DEBIAN
	cat > DEBIAN/control <<-HERE
		Package: $TERMUX_PKG_NAME
		Architecture: ${TERMUX_ARCH}
		Installed-Size: ${TERMUX_PKG_INSTALLSIZE}
		Maintainer: $TERMUX_PKG_MAINTAINER
		Version: $TERMUX_PKG_FULLVERSION
		Homepage: $TERMUX_PKG_HOMEPAGE
	HERE
	if [ "$TERMUX_GLOBAL_LIBRARY" = "true" ] && [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		test ! -z "$TERMUX_PKG_DEPENDS" && TERMUX_PKG_DEPENDS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_PKG_DEPENDS")
		test ! -z "$TERMUX_PKG_BREAKS" && TERMUX_PKG_BREAKS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_PKG_BREAKS")
		test ! -z "$TERMUX_PKG_CONFLICTS" && TERMUX_PKG_CONFLICTS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_PKG_CONFLICTS")
		test ! -z "$TERMUX_PKG_RECOMMENDS" && TERMUX_PKG_RECOMMENDS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_PKG_RECOMMENDS")
		test ! -z "$TERMUX_PKG_REPLACES" && TERMUX_PKG_REPLACES=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_PKG_REPLACES")
		test ! -z "$TERMUX_PKG_PROVIDES" && TERMUX_PKG_PROVIDES=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_PKG_PROVIDES")
		test ! -z "$TERMUX_PKG_SUGGESTS" && TERMUX_PKG_SUGGESTS=$(termux_package__add_prefix_glibc_to_package_list "$TERMUX_PKG_SUGGESTS")
	fi
	test ! -z "$TERMUX_PKG_BREAKS" && echo "Breaks: $TERMUX_PKG_BREAKS" >> DEBIAN/control
	test ! -z "$TERMUX_PKG_PRE_DEPENDS" && echo "Pre-Depends: $TERMUX_PKG_PRE_DEPENDS" >> DEBIAN/control
	test ! -z "$TERMUX_PKG_DEPENDS" && echo "Depends: $TERMUX_PKG_DEPENDS" >> DEBIAN/control
	[ "$TERMUX_PKG_ESSENTIAL" = "true" ] && echo "Essential: yes" >> DEBIAN/control
	test ! -z "$TERMUX_PKG_CONFLICTS" && echo "Conflicts: $TERMUX_PKG_CONFLICTS" >> DEBIAN/control
	test ! -z "$TERMUX_PKG_RECOMMENDS" && echo "Recommends: $TERMUX_PKG_RECOMMENDS" >> DEBIAN/control
	test ! -z "$TERMUX_PKG_REPLACES" && echo "Replaces: $TERMUX_PKG_REPLACES" >> DEBIAN/control
	test ! -z "$TERMUX_PKG_PROVIDES" && echo "Provides: $TERMUX_PKG_PROVIDES" >> DEBIAN/control
	test ! -z "$TERMUX_PKG_SUGGESTS" && echo "Suggests: $TERMUX_PKG_SUGGESTS" >> DEBIAN/control
	echo "Description: $TERMUX_PKG_DESCRIPTION" >> DEBIAN/control

	# Create DEBIAN/conffiles (see https://www.debian.org/doc/debian-policy/ap-pkg-conffiles.html):
	for f in $TERMUX_PKG_CONFFILES; do echo "$TERMUX_PREFIX_CLASSICAL/$f" >> DEBIAN/conffiles; done

	# Allow packages to create arbitrary control files.
	# XXX: Should be done in a better way without a function?
	cd DEBIAN
	termux_step_create_debscripts

	# Create control.tar.xz
	tar --sort=name \
		--mtime="@${SOURCE_DATE_EPOCH}" \
		--owner=0 --group=0 --numeric-owner \
		-cJf "$TERMUX_PKG_PACKAGEDIR/control.tar.xz" -H gnu .

	test ! -f "$TERMUX_COMMON_CACHEDIR/debian-binary" && echo "2.0" > "$TERMUX_COMMON_CACHEDIR/debian-binary"
	TERMUX_PKG_DEBFILE=$TERMUX_OUTPUT_DIR/${TERMUX_PKG_NAME}${DEBUG}_${TERMUX_PKG_FULLVERSION}_${TERMUX_ARCH}.deb
	# Create the actual .deb file:
	${AR-ar} cr "$TERMUX_PKG_DEBFILE" \
	       "$TERMUX_COMMON_CACHEDIR/debian-binary" \
	       "$TERMUX_PKG_PACKAGEDIR/control.tar.xz" \
	       "$TERMUX_PKG_PACKAGEDIR/data.tar.xz"
}
