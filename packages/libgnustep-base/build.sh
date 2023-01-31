TERMUX_PKG_HOMEPAGE=http://www.gnustep.org
TERMUX_PKG_DESCRIPTION="A library of general-purpose, non-graphical Objective C objects"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.29.0
TERMUX_PKG_SRCURL=https://github.com/gnustep/libs-base/releases/download/base-${TERMUX_PKG_VERSION//./_}/gnustep-base-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fa58eda665c3e0b9c420dc32bb3d51247a407c944d82e5eed1afe8a2b943ef37
TERMUX_PKG_DEPENDS="gnustep-make, libc++, libffi, libgmp, libgnutls, libiconv, libicu, libxml2, libxslt, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-default-config=$TERMUX_PREFIX/etc/GNUstep/GNUstep.conf
--enable-procfs
--disable-procfs-psinfo
iswindows=no
cross_reuseaddr_ok=1
cross_gs_cv_objc_works=yes
cross_gs_cv_objc_compiler_supports_constant_string_class=yes
cross_gs_cv_objc_load_method_worked=yes
cross_have_poll=yes
cross_VSPRINTF_RETURNS_LENGTH=1
cross_VASPRINTF_RETURNS_LENGTH=1
cross_NEED_WORD_ALIGNMENT=1
cross_working_register_printf=0
cross_wide_register_printf=0
cross_gs_cv_program_invocation_name_worked=no
cross_CMDLINE_TERMINATED=1
cross_have_kvm_env=0
cross_ffi_ok=yes
cross_non_fragile=yes
cross_have_unexpected=yes
cross_safe_initialize=yes
cross_found_iconv_libc=no
cross_found_iconv_liconv=yes
cross_found_iconv_lgiconv=no
cross_objc2_runtime=1
ac_cv_func_setpgrp_void=yes
"

termux_step_pre_configure() {
	local bin="$TERMUX_PKG_BUILDDIR/bin"
	mkdir -p "$bin"
	local sh="$(command -v sh)"
	for cmd in CC CPP CXX; do
		local wrapper="$bin/$(basename $(eval echo \${$cmd}))"
		cat > "$wrapper" <<-EOF
			#!${sh}
			unset LD_PRELOAD
			unset LD_LIBRARY_PATH
			exec $(command -v $(eval echo \${$cmd})) "\$@"
		EOF
		chmod 0700 "$wrapper"
	done
	export PATH="$bin":$PATH

	rm -f cross.config
	touch cross.config
}
