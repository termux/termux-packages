TERMUX_SUBPKG_INCLUDE="
lib/apt/methods/tor
lib/apt/methods/tor+http
lib/apt/methods/tor+https
"

TERMUX_SUBPKG_DESCRIPTION="APT transport for anonymous package downloads via Tor"
TERMUX_SUBPKG_DEPENDS="tor"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=yes
