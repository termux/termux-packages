TERMUX_PKG_HOMEPAGE=https://pcre2project.github.io/pcre2/
TERMUX_PKG_DESCRIPTION="Perl 5 compatible regular expression library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="10.48"
TERMUX_PKG_SRCURL="https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${TERMUX_PKG_VERSION}/pcre2-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=b6c68fdf6f3ac31388b50aa89ff0fc49c00c987c16e7b5146491d12003f2c8ed
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+(?!-)"
TERMUX_PKG_BREAKS="pcre2-dev"
TERMUX_PKG_REPLACES="pcre2-dev"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/pcre2test
share/man/man1/pcre2test.1
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-jit
--enable-pcre2-16
--enable-pcre2-32
"
termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local -A _SOVER=(
		[libpcre2_8]=0
		[libpcre2_16]=0
		[libpcre2_32]=0
		[libpcre2_posix]=3
	)

	local soname expected
	for soname in libpcre2_{8,16,32,posix}; do
		expected="$(sed -En 's/^m4_define\('"${soname}"'_version,\s*\[([0-9]+):([0-9]+):([0-9]+)\].*/\1 - \3/p' configure.ac)"

		if [[ -n "$expected" ]]; then
			(( _SOVER[$soname] == expected )) && continue
		fi
		termux_error_exit <<- EOF
			SOVERSION guard check failed for ${soname/_/-}.so.
			Expected: $expected
			Got:      ${_SOVER[$soname]}
		EOF
	done
}

termux_step_post_make_install() {
	# provide convenience symlinks for the original PCRE's `pcregrep`
	ln -vsf -t "$TERMUX_PREFIX/bin" pcre2grep pcregrep
	ln -vsf -t "$TERMUX_PREFIX/share/man/man1" pcre2grep.1 pcregrep.1
}
