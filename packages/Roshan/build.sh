TERMUX_PKG_NAME="Roshan"
TERMUX_PKG_VERSION="1.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_DESCRIPTION="A professional CLI tool to generate custom animated text banners"
TERMUX_PKG_HOMEPAGE="https://github.com/Roshan-Editor/Roshan-Editor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Roshan-Editor"
TERMUX_PKG_SRCURL="https://github.com/Roshan-Editor/Roshan-Editor/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
# अगर आप सोर्स आर्काइव यूज़ कर रहे हैं तो SHA256 हैश यहाँ डाल सकते हैं:
# TERMUX_PKG_SHA256=""

# पैकेज की ज़रूरी डिपेंडेंसी (ताकि इंस्टॉल/बिल्ड एरर न आए)
TERMUX_PKG_DEPENDS="bash, figlet, ncurses-utils"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_ESSENTIAL=false

termux_step_pre_configure() {
    # बिल्ड से पहले डायरेक्टरी चेक और एरर हैंडलिंग
    echo "[*] Preparing build environment for ${TERMUX_PKG_NAME}..."
    
    if [ ! -f "banner.sh" ] && [ ! -f "roshan.sh" ]; then
        echo "[!] ERROR: Main script file not found in source directory!"
        return 1
    fi
}

termux_step_make_install() {
    # 1. /bin डायरेक्टरी में एग्जीक्यूटेबल की इंस्टॉलेशन
    mkdir -p "${TERMUX_PKG_PREFIX}/bin"
    
    # अगर फ़ाइल नाम banner.sh है तो उसे roshan नाम से इंस्टॉल करें
    if [ -f "banner.sh" ]; then
        install -Dm755 banner.sh "${TERMUX_PKG_PREFIX}/bin/roshan"
    elif [ -f "roshan.sh" ]; then
        install -Dm755 roshan.sh "${TERMUX_PKG_PREFIX}/bin/roshan"
    else
        install -Dm755 * "${TERMUX_PKG_PREFIX}/bin/roshan"
    fi

    # 2. परमिशन सेट करें
    chmod +x "${TERMUX_PKG_PREFIX}/bin/roshan"

    # 3. एक्स्ट्रा कन्फ़िगरेशन या डेटा फ़ाइल्स (ऑप्शनल)
    mkdir -p "${TERMUX_PKG_PREFIX}/share/roshan"
    if [ -d "assets" ]; then
        cp -r assets/* "${TERMUX_PKG_PREFIX}/share/roshan/"
    fi

    echo "[+] ${TERMUX_PKG_NAME} successfully installed to ${TERMUX_PKG_PREFIX}/bin/roshan"
}

termux_step_post_make_install() {
    # इंस्टॉलेशन के बाद वेरिफिकेशन
    if [ ! -f "${TERMUX_PKG_PREFIX}/bin/roshan" ]; then
        echo "[!] Installation verification failed!"
        return 1
    fi
}
