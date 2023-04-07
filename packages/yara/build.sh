TERMUX_PKG_HOMEPAGE=https://github.com/VirusTotal/yara
TERMUX_PKG_DESCRIPTION="Tool aimed at helping malware researchers to identify and classify malware samples"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.3.0
TERMUX_PKG_SRCURL=https://github.com/VirusTotal/yara/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=67bc0a5d58d9080a0981da116d65817d27b87dad7e402c7ece25372b38401e12
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="file, openssl, libandroid-posix-semaphore"
TERMUX_PKG_BREAKS="yara-dev"
TERMUX_PKG_REPLACES="yara-dev"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-posix-semaphore"
	./bootstrap.sh
}
