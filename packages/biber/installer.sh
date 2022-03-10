#!@TERMUX_PREFIX@/bin/bash
set -e
# unset variables that the user might have set to force installation to $PREFIX
unset PERL_LOCAL_LIB_ROOT
unset PERL5LIB
unset PERL_MM_OPT
unset PERL_MB_OPT

export PREFIX=@TERMUX_PREFIX@
export TMPDIR=@TERMUX_PREFIX@/tmp
export EXTUTILS_LIBBUILDER_VERSION=@EXTUTILS_LIBBUILDER_VERSION@
export TEXT_BIBTEX_VERSION=@TEXT_BIBTEX_VERSION@
export NET_SSLEAY_VERSION=@NET_SSLEAY_VERSION@
export BIBER_VERSION=@BIBER_VERSION@

# Lock terminal to prevent sending text input and special key
# combinations that may break installation process.
stty -echo -icanon time 0 min 0 intr undef quit undef susp undef

# Use trap to unlock terminal at exit.
trap 'while read -r; do true; done; stty sane;' EXIT

echo "[*] Installing cpanm..."

cpan install App::cpanminus
export PATH="$PATH:$HOME/perl5/bin"

echo "[*] Downloading and patching troublesome dependencies..."

cd $TMPDIR
if [ ! -f ExtUtils-LibBuilder-${EXTUTILS_LIBBUILDER_VERSION}.tar.gz ]; then
	curl --fail --retry 3 --location --output "$TMPDIR/ExtUtils-LibBuilder-${EXTUTILS_LIBBUILDER_VERSION}.tar.gz" \
             "https://cpan.metacpan.org/authors/id/A/AM/AMBS/ExtUtils-LibBuilder-${EXTUTILS_LIBBUILDER_VERSION}.tar.gz"
else
	rm -rf ExtUtils-LibBuilder-${EXTUTILS_LIBBUILDER_VERSION}
fi
tar -xf ExtUtils-LibBuilder-${EXTUTILS_LIBBUILDER_VERSION}.tar.gz
cd ExtUtils-LibBuilder-${EXTUTILS_LIBBUILDER_VERSION}
patch -Np1 -i $PREFIX/opt/biber/ExtUtils-LibBuilder.diff
cpanm .

cd ..

if [ ! -f Text-BibTeX-${TEXT_BIBTEX_VERSION}.tar.gz ]; then
	curl --fail --retry 3 --location --output "$TMPDIR/Text-BibTeX-${TEXT_BIBTEX_VERSION}.tar.gz" \
             "https://cpan.metacpan.org/authors/id/A/AM/AMBS/Text-BibTeX-${TEXT_BIBTEX_VERSION}.tar.gz"
else
	rm -rf Text-BibTeX-${TEXT_BIBTEX_VERSION}
fi
tar -xf Text-BibTeX-${TEXT_BIBTEX_VERSION}.tar.gz
cd Text-BibTeX-${TEXT_BIBTEX_VERSION}
patch -Np1 -i $PREFIX/opt/biber/Text-BibTeX.diff
cpanm .

cd ..

if [ ! -f p5-net-ssleay-${NET_SSLEAY_VERSION}.tar.gz ]; then
        curl --fail --retry 3 --location --output "$TMPDIR/p5-net-ssleay-${NET_SSLEAY_VERSION}.tar.gz" \
        "https://github.com/radiator-software/p5-net-ssleay/archive/${NET_SSLEAY_VERSION}.tar.gz"
else
        rm -rf p5-net-ssleay-${NET_SSLEAY_VERSION}
fi
tar -xf p5-net-ssleay-${NET_SSLEAY_VERSION}.tar.gz
cd p5-net-ssleay-${NET_SSLEAY_VERSION}
patch -Np1 -i $PREFIX/opt/biber/Net-SSLeay.diff
cpanm .

cd ..

echo "[*] Installing biber and its dependencies (may take long time)..."

if [ ! -f biber-${BIBER_VERSION}.tar.gz ]; then
	curl --fail --retry 3 --location --output "biber-${BIBER_VERSION}.tar.gz" \
             "https://github.com/plk/biber/archive/v${BIBER_VERSION}.tar.gz"
else
	rm -rf biber-${BIBER_VERSION}
fi
tar -xf biber-${BIBER_VERSION}.tar.gz && cd biber-${BIBER_VERSION}
cpanm --notest .

cd ..

echo "[*] biber installation finished."

exit 0
