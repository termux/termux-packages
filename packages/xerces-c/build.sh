TERMUX_PKG_HOMEPAGE=https://xerces.apache.org/
TERMUX_PKG_DESCRIPTION="Validating XML parser library for C++."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@3ls-it"
TERMUX_PKG_VERSION="3.3.0"
TERMUX_PKG_SRCURL="https://downloads.apache.org/xerces/c/3/sources/xerces-c-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=9555f1d06f82987fbb4658862705515740414fd34b4db6ad2ed76a2dc08d3bde
TERMUX_PKG_DEPENDS="libc++, libcurl, libicu"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-netaccessor-curl
--enable-transcoder-icu
--enable-msgloader-inmemory
--with-curl=$TERMUX_PREFIX
--with-icu=$TERMUX_PREFIX
"

# arm32 build fails due to undefined `__aeabi_*div*` symbols:
# ERROR: ./lib/libxerces-c-3.3.so contains undefined symbols:
#     4: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_uidiv
#    18: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_uidivmod
#    32: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_idiv
#    50: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_idivmod
termux_step_pre_configure() {
	if [[ "$TERMUX_ARCH" == "arm" ]]; then
		LDFLAGS+=" $($CC -print-libgcc-file-name)"
	fi
}


# Make necessary symlink libxerces-c.so -> libxerces-c-3.3.so
termux_step_post_make_install() {
	local libdir="$TERMUX_PREFIX/lib"
	# Get just <major>.<minor>
	local sover="${TERMUX_PKG_VERSION%.*}"
	local soname="libxerces-c-${sover}.so"
	# Build full path filename
	local sofile="$libdir/$soname"

	if [[ ! -e "$sofile" ]]; then
		termux_error_exit "Expected shared library not found: $sofile"
	fi

	local got
	got="$(readelf -d "$sofile" | sed -n 's/.*Library soname: \[\(.*\)\].*/\1/p')"
	if [[ "$got" != "$soname" ]]; then
		termux_error_exit "SOVERSION guard check failed: expected SONAME=$soname, got SONAME=$got"
	fi

	# Now it's safe to link
	ln -sf "$soname" "$libdir/libxerces-c.so"
}
