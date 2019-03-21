# Sample build.sh for all packages.
# All comments here to be removed before submitting pull requests.
# Unless otherwise specified, variables are optional.
# Default values of all variables are found in build-package.sh

# IMPORTANT: build.sh script should not execute commands that
# require superuser (su/sudo) privileges or modify files outside
# of build directories.

# Core information about package.
TERMUX_PKG_HOMEPAGE= # REQUIRED. The homepage of a package.
TERMUX_PKG_DESCRIPTION= # REQUIRED. A brief description of the package. Should not be long and/or multiline.
TERMUX_PKG_LICENSE= # REQUIRED. The license of the package.
TERMUX_PKG_MAINTAINER= # Usually kept as Fredrik Fornwall.
TERMUX_PKG_API_LEVEL= # Minimal required Android API Level to run this package.
TERMUX_PKG_VERSION= # Version of package by original developer.
TERMUX_PKG_REVISION= # Bump after a fix within Termux.
TERMUX_PKG_SRCURL= # The URL of source archive.
TERMUX_PKG_SHA256= # REQUIRED if URL is specified. Prevents unauthorised changes during download.
TERMUX_PKG_SKIP_SRC_EXTRACT= # Set if no need to extract downloaded sources.
TERMUX_PKG_DEPENDS= # Runtime dependencies.
TERMUX_PKG_DEVPACKAGE_DEPENDS= # Header files dependencies.
TERMUX_PKG_BUILD_DEPENDS= # Build-time dependencies.

# Package relationships.
TERMUX_PKG_BREAKS= # Packages that the package will break.
TERMUX_PKG_CONFLICTS= # Conflicted packages. All users with conflicted packages installed will not be able to install this package.
TERMUX_PKG_REPLACES= # Packages that are not required anymore with this package.
TERMUX_PKG_PROVIDES= # Specifies virtual packages. Used primarily by secondary Termux repositories.
TERMUX_PKG_RECOMMENDS= # Packages that are recommended to be installed in addition.
TERMUX_PKG_SUGGESTS= # Packages that may be installed in addition.
TERMUX_PKG_ESSENTIAL= # Marks package as essential. User will not be able to freely uninstall it so potential system breakage will be prevented.

# Build configuration.
TERMUX_PKG_BUILD_IN_SRC= # Whether builds are done in source.
TERMUX_PKG_NO_DEVELSPLIT= # Prevent splitting into dev package.
TERMUX_PKG_HAS_DEBUG= # Whether debug builds are possible.
TERMUX_PKG_PLATFORM_INDEPENDENT= # Whether package is cross-platform (e.g. shell, java or python).
TERMUX_PKG_BLACKLISTED_ARCHES= # CPU architectures where the package could not be built.
TERMUX_PKG_HOSTBUILD= # Whether host builds are done (default:no).
TERMUX_PKG_FORCE_CMAKE= # Force using CMake even if configure or other GNU Automake files are present.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS= # Extra arguments passed to configuration utility.
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS= # Extra arguments passed to configuration utility during the host build.
TERMUX_PKG_EXTRA_MAKE_ARGS= # Extra arguments for make.
TERMUX_PKG_MAKE_INSTALL_TARGET= # Installation target equivalent to make install.

# Post-install steps configuration.
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE= # Files that are included in development package in addition to headers.
TERMUX_PKG_KEEP_STATIC_LIBRARIES= # Whether static libraries are kept.
TERMUX_PKG_KEEP_INFOPAGES= # Whether share/info files are kept.
TERMUX_PKG_KEEP_SHARE_DOC= # Whether share/doc files are kept.
TERMUX_PKG_RM_AFTER_INSTALL= # Remove specified files after 'make install' or equivalent.
TERMUX_PKG_CONFFILES= # Package configuration files. These files will not be overwritten on package update if modified by user.
