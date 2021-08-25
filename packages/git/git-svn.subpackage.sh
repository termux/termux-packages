TERMUX_SUBPKG_DESCRIPTION="Convert between Git and Subversion repositories"
TERMUX_SUBPKG_DEPENDS="subversion-perl"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
TERMUX_SUBPKG_INCLUDE="
libexec/git-core/git-svn*
share/man/man1/git-svn*
share/perl5/Git/SVN*
"
