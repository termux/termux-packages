TERMUX_PKG_HOMEPAGE=http://www.gnustep.org
TERMUX_PKG_DESCRIPTION="A library of general-purpose, non-graphical Objective C objects"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.30.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/gnustep/libs-base/releases/download/base-${TERMUX_PKG_VERSION//./_}/gnustep-base-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=00b5bc4179045b581f9f9dc3751b800c07a5d204682e3e0eddd8b5e5dee51faa
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='(?<=-).+'
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

	# In configure step, $TERMUX_PREFIX will be appended to PATH, and
	# it will break the build process. Rename these tools and recover
	# later if not on device.
	# See https://github.com/gnustep/libs-base/blob/5ea68724ff6b49d935101246de38ffd955d57f50/configure.ac#L1016
	if [ "$TERMUX_ON_DEVICE_BUILD" = false ]; then
		local _tool
		for _tool in awk bash cat chmod dirname expr grep mkdir mv rm sed sort tr; do
			if [ -e $TERMUX_PREFIX/bin/$_tool ]; then
				mv $TERMUX_PREFIX/bin/{$_tool,$_tool.gnustepbase}
			fi
		done
	fi
}

termux_step_post_make_install() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = false ]; then
		local _tool
		for _tool in awk bash cat chmod dirname expr grep mkdir mv rm sed sort tr; do
			if [ -e $TERMUX_PREFIX/bin/"$_tool.gnustepbase" ]; then
				mv $TERMUX_PREFIX/bin/{$_tool.gnustepbase,$_tool}
			fi
		done
	fi
}

termux_step_post_massage() {
	if [ "$TERMUX_ON_DEVICE_BUILD" == true ]; then
		return
	fi

	cd "$TERMUX_PKG_MASSAGEDIR"/$TERMUX_PREFIX/bin || exit 1
	local _tool
	for _tool in awk bash cat chmod dirname expr grep mkdir mv rm sed sort tr; do
		rm -f $_tool
	done
}
