TERMUX_PKG_HOMEPAGE=https://termux.dev
TERMUX_PKG_DESCRIPTION="OpenCL driver from system vendor"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_RECOMMENDS="binutils | binutils-is-llvm, ocl-icd, patchelf"
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_make_install() {
	echo "${TERMUX_PREFIX}/opt/vendor/lib/libOpenCL.so" > vendor.icd
	install -Dm644 vendor.icd "${TERMUX_PREFIX}/etc/OpenCL/vendors/vendor.icd"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/opt/vendor/lib/libOpenCL.so"
}

termux_step_create_debscripts() {
	cp -f "${TERMUX_PKG_BUILDER_DIR}/postinst.sh" postinst
	sed -i postinst -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g"

	cat <<- EOF > prerm
	#!${TERMUX_PREFIX}/bin/sh
	case "\$1" in
	purge|remove)
	rm -fr "${TERMUX_PREFIX}/opt/vendor/lib"
	esac
	EOF
}

# Goal:
# To allow Termux to use on-device OpenCL drivers without export
# LD_LIBRARY_PATH=/vendor/lib64 or other trickery

# What it does:
# Copies libOpenCL.so from /vendor or /system
# Find extra deps for libOpenCL.so
# Patchelf libOpenCL.so and deps

# List of libOpenCL.so drivers from different vendors:
# GPU                    SONAME             cl_khr_icd    Supported
# Arm Mali               libGLES_mali.so    y             y
# Qualcomm Adreno        libOpenCL.so       n             n
# Imagination PowerVR    libPVROCL.so       y             y
