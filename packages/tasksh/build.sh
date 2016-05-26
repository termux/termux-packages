TERMUX_PKG_HOMEPAGE=https://tasktools.org/projects/tasksh.html
TERMUX_PKG_DESCRIPTION="Shell command that wraps Taskwarrior commands"
# Package version scheme until release:
#
#     <version>~git<commit-date>.<package-version-for-that-date>.<commit-short-sha1>
#
# Because `dpkg --compare-versions '1.1.0~git3.1.337' lt 1.1.0` is true.
#
# <package-version-for-that-date> should increase for every package with the
# same <commit-date> part because <commit-short-sha1> could contain "random"
# character out of the desired sorting order. <package-version-for-that-date>
# should be 1 for package with new <commit-date>.
TERMUX_PKG_VERSION=1.1.0~git20160330.1.726a163
# https://git.tasktools.org/projects/EX/repos/tasksh/commits?until=refs%2Fheads%2F1.1.0
# Look for link "Download" at the top right corner.
TERMUX_PKG_SRCURL=https://git.tasktools.org/plugins/servlet/archive/projects/EX/repos/tasksh?at=726a1630bfd60fdfba36e4a3aa8b21ee04ab970a
TERMUX_PKG_RENAME_DISTFILE_TO=tasksh-${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_DEPENDS="libgnustl, libandroid-glob, readline"

LDFLAGS+=" -landroid-glob"

termux_step_post_extract_package () {
	# Saved commit SHA1 is used by patched CMakeFiles.txt.
	echo -n "${TERMUX_PKG_VERSION##*.}" \
		> "${TERMUX_PKG_SRCDIR}/commit.sha1.savedbytermuxbuildsh.txt"
}

termux_step_configure () {
	cd $TERMUX_PKG_BUILDDIR
	# Point to libandroid-glob header location through
	# -DTASKSH_INCLUDE_DIRS.
	#
	# Other -D values were copied from taskwarrior package with removing
	# some of them that CMake detected as not used in the building process.
	cmake -G "Unix Makefiles" .. \
		-DTASKSH_INCLUDE_DIRS="${TERMUX_PREFIX}/include" \
		-DCMAKE_AR=`which ${TERMUX_HOST_PLATFORM}-ar` \
		-DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_C_FLAGS="$CFLAGS $CPPFLAGS" \
		-DCMAKE_CROSSCOMPILING=True \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS" \
		-DCMAKE_FIND_ROOT_PATH=$TERMUX_PREFIX \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX \
		-DCMAKE_LINKER=`which ${TERMUX_HOST_PLATFORM}-ld` \
		-DCMAKE_MAKE_PROGRAM=`which make` \
		-DCMAKE_RANLIB=`which ${TERMUX_HOST_PLATFORM}-ranlib` \
		-DCMAKE_SKIP_INSTALL_RPATH=ON \
		-DCMAKE_SYSTEM_NAME=Linux \
		$TERMUX_PKG_SRCDIR
}
