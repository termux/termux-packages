TERMUX_PKG_HOMEPAGE=http://www.gnustep.org
TERMUX_PKG_DESCRIPTION="A library of general-purpose, non-graphical Objective C objects"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.28.0
TERMUX_PKG_SRCURL=http://ftp.gnustep.org/pub/gnustep/core/gnustep-base-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c7d7c6e64ac5f5d0a4d5c4369170fc24ed503209e91935eb0e2979d1601039ed
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
	for cmd in CPP CC CXX; do
		local wrapper="$bin/$(basename $(eval echo \${$cmd}))"
		cat > "$wrapper" <<-EOF
			#!${sh}
			unset LD_PRELOAD
			unset LD_LIBRARY_PATH
			exec $(command -v $(eval echo \${$cmd})) "\$@"
		EOF
		chmod 0700 "$wrapper"
	done
	for p in gnustep; do
		local conf="$bin/${p}-config"
		cat > "$conf" <<-EOF
			#!${sh}
			exec sh "$TERMUX_PREFIX/bin/${p}-config" "\$@"
		EOF
		chmod 0700 "$conf"
	done
	export PATH="$bin":$PATH

	rm -f cross.config
	touch cross.config
}
