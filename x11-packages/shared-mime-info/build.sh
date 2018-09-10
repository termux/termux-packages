TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://freedesktop.org/Software/shared-mime-info
TERMUX_PKG_DESCRIPTION="Freedesktop.org Shared MIME Info"
TERMUX_PKG_VERSION=1.9
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://freedesktop.org/~hadess/shared-mime-info-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5c0133ec4e228e41bdf52f726d271a2d821499c2ab97afd3aa3d6cf43efcdc83
TERMUX_PKG_DEPENDS="coreutils, glib, libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-update-mimedb ac_cv_func_fdatasync=no"

termux_step_post_make_install() {
    # fix location of shared-mime-info.pc
    if [ -f "${TERMUX_PREFIX}/share/pkgconfig/shared-mime-info.pc" ]; then
        mkdir -p "${TERMUX_PREFIX}/lib/pkgconfig" || exit 1
        mv -f "${TERMUX_PREFIX}/share/pkgconfig/shared-mime-info.pc" "${TERMUX_PREFIX}/lib/pkgconfig/shared-mime-info.pc" || exit 1
    fi
}

termux_step_create_debscripts()
{
    cp "${TERMUX_PKG_BUILDER_DIR}/postinst" ./postinst
    cp "${TERMUX_PKG_BUILDER_DIR}/postrm"   ./postrm
    cp "${TERMUX_PKG_BUILDER_DIR}/triggers" ./triggers
}
