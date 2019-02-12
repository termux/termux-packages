# Sample build.sh for all packages.
# All comments here to be removed before submitting pull requests.
# Unless otherwise specified, variables are optional.
# Default values of all variables are found in build-package.sh

TERMUX_PKG_API_LEVEL= # Android API Level.
TERMUX_PKG_BLACKLISTED_ARCHES= # Arches where the package could not be built.
TERMUX_PKG_BREAKS= # Packages that the package will break.
TERMUX_PKG_BUILD_DEPENDS= # Build dependencies.
TERMUX_PKG_BUILD_IN_SRC= # Whether builds are in source.
TERMUX_PKG_CONFFILES= # Package config files
TERMUX_PKG_CONFLICTS= # Conflicted packages. All users with conflicted packages installed will not be able to install this package.
TERMUX_PKG_DEPENDS= # Runtime dependencies.
TERMUX_PKG_DESCRIPTION= # REQUIRED. A brief description of the package.
TERMUX_PKG_DEVPACKAGE_DEPENDS= # Header files dependencies.
TERMUX_PKG_ESSENTIAL= # If package is essential, it will be a dependency of any package.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS= # Extra arguments for configure script.
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS= # Extra configuration arguments during configuration of host build.
TERMUX_PKG_EXTRA_MAKE_ARGS= # Extra arguments for make.
TERMUX_PKG_FORCE_CMAKE= # Force using CMake even if configure or other GNU Automake files are present.
TERMUX_PKG_HAS_DEBUG= # Whether debug builds are possible.
TERMUX_PKG_HOMEPAGE= # REQUIRED. The homepage of a package.
TERMUX_PKG_HOSTBUILD= # Whether host builds are done (default:no)
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE= # Files that are included in dev package in addition to headers.
TERMUX_PKG_KEEP_INFOPAGES= # Whether info pages are kept.
TERMUX_PKG_KEEP_SHARE_DOC= # Whether doc pages are kept.
TERMUX_PKG_KEEP_STATIC_LIBRARIES= # Whether static libraries are kept.
TERMUX_PKG_LICENSE= # REQUIRED. The license of the package.
TERMUX_PKG_MAINTAINER= # Usually kept as Fredrik Fornwall.
TERMUX_PKG_MAKE_INSTALL_TARGET= # Installation target equivalent to make install.
TERMUX_PKG_NO_DEVELSPLIT= # Prevent splitting into dev package.
TERMUX_PKG_PLATFORM_INDEPENDENT= # Whether package is cross-platform (e.g. shell or java or python).
TERMUX_PKG_RECOMMENDS= # Packages that are recommended to be installed in addition.
TERMUX_PKG_REPLACES= # Packaged that are not required anymore with this package.
TERMUX_PKG_REVISION= # Bump after a fix within Termux.
TERMUX_PKG_RM_AFTER_INSTALL= # Remove the files after make install or equivalent.
TERMUX_PKG_SHA256= # REQUIRED. Prevents unauthorised changes during download.
TERMUX_PKG_SKIP_SRC_EXTRACT= # No need to extract from archive.
TERMUX_PKG_SRCURL= # The URL of source archive.
TERMUX_PKG_SUGGESTS= # Packages that may be installed in addition.
TERMUX_PKG_VERSION= # Version of package by original developer.
