TERMUX_PKG_HOMEPAGE=http://www.calculix.de/
TERMUX_PKG_DESCRIPTION="CalculiX CrunchiX (ccx) - Three-Dimensional Structural Finite Element Solver"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_VERSION="2.23"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="CalculiX/ccx_${TERMUX_PKG_VERSION}/src/ccx_${TERMUX_PKG_VERSION}.c"
TERMUX_PKG_MAINTAINER="Daniel <danielpdiamon@gmail.com>"
TERMUX_PKG_SRCURL=(
	"http://www.dhondt.de/ccx_${TERMUX_PKG_VERSION}.src.tar.bz2"
	"http://www.netlib.org/linalg/spooles/spooles.2.2.tgz"
	"https://www.dhondt.de/ccx_${TERMUX_PKG_VERSION}.SPOOLEScorrection.tar.bz2"
)
TERMUX_PKG_SHA256=(
	"9c88385c10fb04f5dc6c4e98027a51bebdd8aee3920e05190d6c1dd08357d6e7"
	"a84559a0e987a1e423055ef4fdf3035d55b65bbe4bf915efaa1a35bef7f8c5dd"
	"15528f09312dc7605c0600358f5e6de12945449f249dfcfca7417eed6c220b93"
)
TERMUX_PKG_DEPENDS="arpack-ng, libopenblas"
TERMUX_PKG_BUILD_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_extract_src_archive() {
	local ccx_archive="$TERMUX_PKG_CACHEDIR/$(basename "${TERMUX_PKG_SRCURL[0]}")"
	local spooles_archive="$TERMUX_PKG_CACHEDIR/$(basename "${TERMUX_PKG_SRCURL[1]}")"
	local correction_archive="$TERMUX_PKG_CACHEDIR/$(basename "${TERMUX_PKG_SRCURL[2]}")"

	mkdir -p "$TERMUX_PKG_SRCDIR/CalculiX" "$TERMUX_PKG_SRCDIR/SPOOLES.2.2"
	tar -xjf "$ccx_archive" -C "$TERMUX_PKG_SRCDIR"
	tar -xzf "$spooles_archive" -C "$TERMUX_PKG_SRCDIR/SPOOLES.2.2"
	tar -xjf "$correction_archive" -C "$TERMUX_PKG_SRCDIR/SPOOLES.2.2"
}

termux_step_post_get_source() {
	# 1. Apply SPOOLES fixes (Tree draw typo & misc path)
	sed -i 's/drawTree.c/draw.c/g' "$TERMUX_PKG_SRCDIR/SPOOLES.2.2/Tree/src/makeGlobalLib"
	sed -i 's|# cd misc/src|cd misc/src|g' "$TERMUX_PKG_SRCDIR/SPOOLES.2.2/makefile"

	# 2. Fix CalculiX return type in void readnewmesh function (line 468)
	sed -i '468s/return NULL;/return;/' "$TERMUX_PKG_SRCDIR/CalculiX/ccx_${TERMUX_PKG_VERSION}/src/readnewmesh.c"

	# 3. Remove conflicting IMPLICIT NONE in matvec_struct.f
	sed -i '/IMPLICIT[[:space:]][[:space:]]*NONE/Id' "$TERMUX_PKG_SRCDIR/CalculiX/ccx_${TERMUX_PKG_VERSION}/src/matvec_struct.f"

	# 4. OpenMP Fortran compatibility header
	cd "$TERMUX_PKG_SRCDIR/CalculiX/ccx_${TERMUX_PKG_VERSION}/src"
	sed -i 's/use omp_lib/include "omp_lib.h"/gI' *.f
	cat > omp_lib.h <<- 'EOF'
	      integer omp_get_num_threads
	      integer omp_get_thread_num
	      integer omp_get_max_threads
	      external omp_set_num_threads
	EOF
}

termux_step_configure() {
	termux_setup_flang

	# Generate Make.inc for SPOOLES with cross-compiler toolchain
	cat <<- EOF > "$TERMUX_PKG_SRCDIR/SPOOLES.2.2/Make.inc"
	  CC = $CC
	  CFLAGS = -O2 $CFLAGS -fPIC -fPIE -I\$(DIR) -Wno-implicit-function-declaration -Wno-incompatible-pointer-types -Wno-int-conversion
	  AR = $AR
	  ARFLAGS = vr
	  RANLIB = $RANLIB
	EOF
}

termux_step_make() {
	# 1. Compile SPOOLES static libraries
	cd "$TERMUX_PKG_SRCDIR/SPOOLES.2.2"
	make lib -j"$TERMUX_PKG_MAKE_PROCESSES"
	cd MT/src
	make -j"$TERMUX_PKG_MAKE_PROCESSES"

	# 2. Link SPOOLES into CalculiX source directory
	cd "$TERMUX_PKG_SRCDIR/CalculiX/ccx_${TERMUX_PKG_VERSION}/src"
	ln -sf "$TERMUX_PKG_SRCDIR/SPOOLES.2.2" ../SPOOLES.2.2

	# 3. Compile CalculiX (ccx_2.23_MT)
	local CCX_CFLAGS="-Wall -O2 $CFLAGS -fPIC -fPIE -fopenmp -I../SPOOLES.2.2 -DARCH=\"Linux\" -DSPOOLES -DARPACK -DMATRIXSTORAGE -DUSE_MT=1"
	local CCX_FFLAGS="-Wall -O2 $FCFLAGS -fopenmp -cpp -fallow-argument-mismatch -Wno-error"
	local CCX_LIBS="../SPOOLES.2.2/MT/src/spoolesMT.a ../SPOOLES.2.2/spooles.a -larpack -lopenblas -lomp -lm"

	chmod +x date.pl
	make -f Makefile_MT \
		CC="$CC" \
		FC="$FC" \
		CFLAGS="$CCX_CFLAGS" \
		FFLAGS="$CCX_FFLAGS" \
		LIBS="$CCX_LIBS" \
		-j"$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_make_install() {
	cd "$TERMUX_PKG_SRCDIR/CalculiX/ccx_${TERMUX_PKG_VERSION}/src"
	install -Dm755 ccx_${TERMUX_PKG_VERSION}_MT "$TERMUX_PREFIX/bin/ccx"
}
