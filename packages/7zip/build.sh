TERMUX_PKG_HOMEPAGE=https://www.7-zip.org
TERMUX_PKG_DESCRIPTION="7-Zip file archiver with a high compression ratio"
TERMUX_PKG_LICENSE="LGPL-2.1, BSD 3-Clause, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="
DOC/copying.txt
DOC/License.txt
DOC/unRarLicense.txt
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.02"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=(
	"https://www.7-zip.org/a/7z${TERMUX_PKG_VERSION//./}-src.tar.xz"
	"https://www.7-zip.org/a/7z${TERMUX_PKG_VERSION//./}-linux-arm.tar.xz" # for manual, arm is smallest
)
TERMUX_PKG_SHA256=(
	cf967c98bca02a4b8b16375f441825a8e141362f14be1969bbec8e1ca0bff9dd
	81b7f04b3528852fac10f5becf9f15870a5da4cb94fbcb8a138197eb937468bf
)
TERMUX_PKG_BUILD_DEPENDS="dos2unix"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFLICTS="p7zip"
TERMUX_PKG_PROVIDES="p7zip"
TERMUX_PKG_REPLACES="p7zip"

# The original "termux_extract_src_archive" always strips the first components
# but the source of 7zip is directly under the root directory of the tar file
termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "$TERMUX_PKG_SRCURL")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	tar -xf "$file" -C "$TERMUX_PKG_SRCDIR"
}

termux_step_post_get_source() {
	# convert CRLF to LF like in libpluto package
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		DOS2UNIX="$TERMUX_PKG_TMPDIR/dos2unix"
		(
			. "$TERMUX_SCRIPTDIR/packages/dos2unix/build.sh"
			. "$TERMUX_SCRIPTDIR/scripts/build/get_source/termux_unpack_src_archive.sh"
			TERMUX_PKG_SRCDIR="$DOS2UNIX" termux_step_get_source
		)
		pushd "$DOS2UNIX"
		make dos2unix
		popd # DOS2UNIX
		export PATH="$DOS2UNIX:$PATH"
	fi

	find "$TERMUX_PKG_SRCDIR" -type f -print0 | xargs -0 dos2unix
}

termux_step_pre_configure() {
	# Remove executable perms from docs
	chmod -x DOC/*.txt
	# Remove -Werror to make build succeed
	sed -i -e 's/-Werror//' CPP/7zip/7zip_gcc.mak
}

termux_step_make() {
	local optim_args
	case "$TERMUX_ARCH" in
		x86_64)  optim_args='-f ../../cmpl_clang_x64.mak' ;;
		i686)    optim_args='-f ../../cmpl_clang_x86.mak' ;;
		arm)     optim_args='-f ../../cmpl_clang.mak PLATFORM=arm USE_ASM=1' ;;
		aarch64) optim_args='-f ../../cmpl_clang_arm64.mak' ;;
	esac

	# from https://git.alpinelinux.org/aports/tree/community/7zip/APKBUILD?id=b4601c88f608662c75422311b7ca3c26fab4b1f4
	# -D_GNU_SOURCE: broken sched.h defines
	local bin
	for bin in Bundles/{Format7zF,Alone,Alone7z,Alone2,SFXCon} UI/Console; do
		make -C "CPP/7zip/$bin" \
			CC="$CC $CFLAGS $LDFLAGS -D_GNU_SOURCE" \
			CXX="$CXX $CXXFLAGS $LDFLAGS -D_GNU_SOURCE" \
			O=b/c \
			$optim_args \
			--jobs "$TERMUX_PKG_MAKE_PROCESSES"
	done
}

termux_step_make_install() {
	install -Dm0755 \
		-t "$TERMUX_PREFIX"/bin \
		"$TERMUX_PKG_BUILDDIR"/CPP/7zip/UI/Console/b/c/7z \
		"$TERMUX_PKG_BUILDDIR"/CPP/7zip/Bundles/Alone/b/c/7za \
		"$TERMUX_PKG_BUILDDIR"/CPP/7zip/Bundles/Alone7z/b/c/7zr \
		"$TERMUX_PKG_BUILDDIR"/CPP/7zip/Bundles/Alone2/b/c/7zz
	install -Dm0755 \
		"$TERMUX_PKG_BUILDDIR"/CPP/7zip/Bundles/SFXCon/b/c/7zCon \
		"$TERMUX_PREFIX"/libexec/7zip/7zCon.sfx
	install -Dm0755 \
		-t "$TERMUX_PREFIX"/libexec/7zip \
		"$TERMUX_PKG_BUILDDIR"/CPP/7zip/Bundles/Format7zF/b/c/7z.so
	install -Dm0644 \
		-t "$TERMUX_PREFIX"/share/doc/"$TERMUX_PKG_NAME" \
		"$TERMUX_PKG_BUILDDIR"/DOC/{7zC,7zFormat,lzma,Methods,readme,src-history}.txt
	tar -C "$TERMUX_PREFIX"/share/doc/"$TERMUX_PKG_NAME" \
		-xvf "$TERMUX_PKG_CACHEDIR/$(basename "${TERMUX_PKG_SRCURL[1]}")" MANUAL
	# Remove carriage returns from docs
	find "$TERMUX_PREFIX"/share/doc/"$TERMUX_PKG_NAME" \
		-type f -execdir sed -i -e 's/\r$//g' {} +
}
