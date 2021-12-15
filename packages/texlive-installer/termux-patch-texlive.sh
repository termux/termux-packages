#!@TERMUX_PREFIX@/bin/bash

set -e

PREFIX=@TERMUX_PREFIX@
TL_ROOT=$PREFIX/share/texlive

cd $TL_ROOT
for patch in $PREFIX/opt/texlive/*.diff; do
    printf "Checking if \$PREFIX/opt/texlive/$(basename $patch) can be applied.. "
    # --forward so that patch does not apply reversed patches
    # --reject-file /dev/null so we do not get .rej files
    # --strip 0 to not strip folders from file path
    # --batch to not ask user for input
    # Redirect output to /dev/null to not show warnings/errors for failed patches
    if ! patch --forward \
         --reject-file /dev/null \
         --strip 0 \
         --batch > /dev/null < $patch; then
        echo "Nope"
    else
        echo "Yes"
    fi
done
