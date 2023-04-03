TERMUX_PKG_HOMEPAGE=https://www.pcre.org
TERMUX_PKG_DESCRIPTION="Perl 5 compatible regular expression library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="10.42"
TERMUX_PKG_SRCURL=https://github.com/PhilipHazel/pcre2/releases/download/pcre2-${TERMUX_PKG_VERSION}/pcre2-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8d36cd8cb6ea2a4c2bb358ff6411b0c788633a2a45dabbf1aeb4b701d1b5e840
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+"
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
	local _SOVER_libpcre2_8=0
	local _SOVER_libpcre2_16=0
	local _SOVER_libpcre2_32=0
	local _SOVER_libpcre2_posix=3

	local a
	for a in libpcre2_{8,16,32,posix}; do
		local e=$(sed -En 's/^m4_define\('"${a}"'_version,\s*\[([0-9]+):([0-9]+):([0-9]+)\].*/\1-\3/p' \
				configure.ac)
		if [ ! "${e}" ] || [ "$(eval echo \$_SOVER_${a})" != "$(( "${e}" ))" ]; then
			termux_error_exit "SOVERSION guard check failed for ${a/_/-}.so."
		fi
	done
}
