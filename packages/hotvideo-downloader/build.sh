TERMUX_PKG_NAME=hotvideo-downloader
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SHA256=488c17caeaa9f962e23a1949974b97b039b73fb7933ab9fcc8ed91ab629ef138
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=https://github.com/iksan757/pkg-hotvideo-downloader/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="bash yt-dlp aria2 python ffmpeg"
TERMUX_PKG_HOMEPAGE=https://github.com/iksan757/pkg-hotvideo-downloader
TERMUX_PKG_DESCRIPTION="Fast video downloader that extracts direct stream links with custom quality and high-speed DNS"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    # Memasang skrip utama
    install -Dm755 hotvideo "${TERMUX_PREFIX}/bin/hotvideo"

    # Memasang berkas bantuan
    install -Dm644 help.txt "${TERMUX_PREFIX}/share/hotvideo/help.txt"

    # Memasang lisensi
    install -Dm644 LICENSE "${TERMUX_PREFIX}/share/doc/hotvideo-downloader/LICENSE"
}

