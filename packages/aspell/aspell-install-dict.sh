#!/bin/bash
set -e -u

SCRIPTNAME=aspell-install-dict
show_usage () {
    echo "Usage: $SCRIPTNAME dictionary-to-install"
    echo "Download and install an Aspell dictionary from ftp://ftp.gnu.org/gnu/aspell/dict/0index.html"
    echo "Available dictionaries: af am ar ast az be bg bn br ca cs csb cy da de de-alt el en eo es et fa fi fo fr fy ga gd gl grc gu gv he hi hil hr hsb hu hus hy ia id is it kn ku ky la lt lv mg mi mk ml mn mr ms mt nb nds nl nn ny or pa pl pt_BR pt_PT qu ro ru rw sc sk sl sr sv sw ta te tet tk tl tn tr uk uz vi wa yi zu"
    echo ""
    exit 0
}

declare -A dictionaries
dictionaries[af]='ftp://ftp.gnu.org/gnu/aspell/dict/af/aspell-af-0.50-0.tar.bz2'
dictionaries[am]='ftp://ftp.gnu.org/gnu/aspell/dict/am/aspell6-am-0.03-1.tar.bz2'
dictionaries[ar]='ftp://ftp.gnu.org/gnu/aspell/dict/ar/aspell6-ar-1.2-0.tar.bz2'
dictionaries[ast]='ftp://ftp.gnu.org/gnu/aspell/dict/ast/aspell6-ast-0.01.tar.bz2'
dictionaries[az]='ftp://ftp.gnu.org/gnu/aspell/dict/az/aspell6-az-0.02-0.tar.bz2'
dictionaries[be]='ftp://ftp.gnu.org/gnu/aspell/dict/be/aspell5-be-0.01.tar.bz2'
dictionaries[bg]='ftp://ftp.gnu.org/gnu/aspell/dict/bg/aspell6-bg-4.1-0.tar.bz2'
dictionaries[bn]='ftp://ftp.gnu.org/gnu/aspell/dict/bn/aspell6-bn-0.01.1-1.tar.bz2'
dictionaries[br]='ftp://ftp.gnu.org/gnu/aspell/dict/br/aspell-br-0.50-2.tar.bz2'
dictionaries[ca]='ftp://ftp.gnu.org/gnu/aspell/dict/ca/aspell6-ca-2.1.5-1.tar.bz2'
dictionaries[cs]='ftp://ftp.gnu.org/gnu/aspell/dict/cs/aspell6-cs-20040614-1.tar.bz2'
dictionaries[csb]='ftp://ftp.gnu.org/gnu/aspell/dict/csb/aspell6-csb-0.02-0.tar.bz2'
dictionaries[cy]='ftp://ftp.gnu.org/gnu/aspell/dict/cy/aspell-cy-0.50-3.tar.bz2'
dictionaries[da]='ftp://ftp.gnu.org/gnu/aspell/dict/da/aspell5-da-1.4.42-1.tar.bz2'
dictionaries[de]='ftp://ftp.gnu.org/gnu/aspell/dict/de/aspell6-de-20030222-1.tar.bz2'
dictionaries[de-alt]='ftp://ftp.gnu.org/gnu/aspell/dict/de-alt/aspell6-de-alt-2.1-1.tar.bz2'
dictionaries[el]='ftp://ftp.gnu.org/gnu/aspell/dict/el/aspell-el-0.50-3.tar.bz2'
dictionaries[en]='ftp://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-2016.01.19-0.tar.bz2'
dictionaries[eo]='ftp://ftp.gnu.org/gnu/aspell/dict/eo/aspell6-eo-2.1.20000225a-2.tar.bz2'
dictionaries[es]='ftp://ftp.gnu.org/gnu/aspell/dict/es/aspell6-es-1.11-2.tar.bz2'
dictionaries[et]='ftp://ftp.gnu.org/gnu/aspell/dict/et/aspell6-et-0.1.21-1.tar.bz2'
dictionaries[fa]='ftp://ftp.gnu.org/gnu/aspell/dict/fa/aspell6-fa-0.11-0.tar.bz2'
dictionaries[fi]='ftp://ftp.gnu.org/gnu/aspell/dict/fi/aspell6-fi-0.7-0.tar.bz2'
dictionaries[fo]='ftp://ftp.gnu.org/gnu/aspell/dict/fo/aspell5-fo-0.2.16-1.tar.bz2'
dictionaries[fr]='ftp://ftp.gnu.org/gnu/aspell/dict/fr/aspell-fr-0.50-3.tar.bz2'
dictionaries[fy]='ftp://ftp.gnu.org/gnu/aspell/dict/fy/aspell6-fy-0.12-0.tar.bz2'
dictionaries[ga]='ftp://ftp.gnu.org/gnu/aspell/dict/ga/aspell5-ga-4.5-0.tar.bz2'
dictionaries[gd]='ftp://ftp.gnu.org/gnu/aspell/dict/gd/aspell5-gd-0.1.1-1.tar.bz2'
dictionaries[gl]='ftp://ftp.gnu.org/gnu/aspell/dict/gl/aspell6-gl-0.5a-2.tar.bz2'
dictionaries[grc]='ftp://ftp.gnu.org/gnu/aspell/dict/grc/aspell6-grc-0.02-0.tar.bz2'
dictionaries[gu]='ftp://ftp.gnu.org/gnu/aspell/dict/gu/aspell6-gu-0.03-0.tar.bz2'
dictionaries[gv]='ftp://ftp.gnu.org/gnu/aspell/dict/gv/aspell-gv-0.50-0.tar.bz2'
dictionaries[he]='ftp://ftp.gnu.org/gnu/aspell/dict/he/aspell6-he-1.0-0.tar.bz2'
dictionaries[hi]='ftp://ftp.gnu.org/gnu/aspell/dict/hi/aspell6-hi-0.02-0.tar.bz2'
dictionaries[hil]='ftp://ftp.gnu.org/gnu/aspell/dict/hil/aspell5-hil-0.11-0.tar.bz2'
dictionaries[hr]='ftp://ftp.gnu.org/gnu/aspell/dict/hr/aspell-hr-0.51-0.tar.bz2'
dictionaries[hsb]='ftp://ftp.gnu.org/gnu/aspell/dict/hsb/aspell6-hsb-0.02-0.tar.bz2'
dictionaries[hu]='ftp://ftp.gnu.org/gnu/aspell/dict/hu/aspell6-hu-0.99.4.2-0.tar.bz2'
dictionaries[hus]='ftp://ftp.gnu.org/gnu/aspell/dict/hus/aspell6-hus-0.03-1.tar.bz2'
dictionaries[hy]='ftp://ftp.gnu.org/gnu/aspell/dict/hy/aspell6-hy-0.10.0-0.tar.bz2'
dictionaries[ia]='ftp://ftp.gnu.org/gnu/aspell/dict/ia/aspell-ia-0.50-1.tar.bz2'
dictionaries[id]='ftp://ftp.gnu.org/gnu/aspell/dict/id/aspell5-id-1.2-0.tar.bz2'
dictionaries[is]='ftp://ftp.gnu.org/gnu/aspell/dict/is/aspell-is-0.51.1-0.tar.bz2'
dictionaries[it]='ftp://ftp.gnu.org/gnu/aspell/dict/it/aspell6-it-2.2_20050523-0.tar.bz2'
dictionaries[kn]='ftp://ftp.gnu.org/gnu/aspell/dict/kn/aspell6-kn-0.01-1.tar.bz2'
dictionaries[ku]='ftp://ftp.gnu.org/gnu/aspell/dict/ku/aspell5-ku-0.20-1.tar.bz2'
dictionaries[ky]='ftp://ftp.gnu.org/gnu/aspell/dict/ky/aspell6-ky-0.01-0.tar.bz2'
dictionaries[la]='ftp://ftp.gnu.org/gnu/aspell/dict/la/aspell6-la-20020503-0.tar.bz2'
dictionaries[lt]='ftp://ftp.gnu.org/gnu/aspell/dict/lt/aspell6-lt-1.2.1-0.tar.bz2'
dictionaries[lv]='ftp://ftp.gnu.org/gnu/aspell/dict/lv/aspell6-lv-0.5.5-1.tar.bz2'
dictionaries[mg]='ftp://ftp.gnu.org/gnu/aspell/dict/mg/aspell5-mg-0.03-0.tar.bz2'
dictionaries[mi]='ftp://ftp.gnu.org/gnu/aspell/dict/mi/aspell-mi-0.50-0.tar.bz2'
dictionaries[mk]='ftp://ftp.gnu.org/gnu/aspell/dict/mk/aspell-mk-0.50-0.tar.bz2'
dictionaries[ml]='ftp://ftp.gnu.org/gnu/aspell/dict/ml/aspell6-ml-0.03-1.tar.bz2'
dictionaries[mn]='ftp://ftp.gnu.org/gnu/aspell/dict/mn/aspell6-mn-0.06-2.tar.bz2'
dictionaries[mr]='ftp://ftp.gnu.org/gnu/aspell/dict/mr/aspell6-mr-0.10-0.tar.bz2'
dictionaries[ms]='ftp://ftp.gnu.org/gnu/aspell/dict/ms/aspell-ms-0.50-0.tar.bz2'
dictionaries[mt]='ftp://ftp.gnu.org/gnu/aspell/dict/mt/aspell-mt-0.50-0.tar.bz2'
dictionaries[nb]='ftp://ftp.gnu.org/gnu/aspell/dict/nb/aspell-nb-0.50.1-0.tar.bz2'
dictionaries[nds]='ftp://ftp.gnu.org/gnu/aspell/dict/nds/aspell6-nds-0.01-0.tar.bz2'
dictionaries[nl]='ftp://ftp.gnu.org/gnu/aspell/dict/nl/aspell-nl-0.50-2.tar.bz2'
dictionaries[nn]='ftp://ftp.gnu.org/gnu/aspell/dict/nn/aspell-nn-0.50.1-1.tar.bz2'
dictionaries[ny]='ftp://ftp.gnu.org/gnu/aspell/dict/ny/aspell5-ny-0.01-0.tar.bz2'
dictionaries[or]='ftp://ftp.gnu.org/gnu/aspell/dict/or/aspell6-or-0.03-1.tar.bz2'
dictionaries[pa]='ftp://ftp.gnu.org/gnu/aspell/dict/pa/aspell6-pa-0.01-1.tar.bz2'
dictionaries[pl]='ftp://ftp.gnu.org/gnu/aspell/dict/pl/aspell6-pl-6.0_20061121-0.tar.bz2'
dictionaries[pt_BR]='ftp://ftp.gnu.org/gnu/aspell/dict/pt_BR/aspell6-pt_BR-20090702-0.tar.bz2'
dictionaries[pt_PT]='ftp://ftp.gnu.org/gnu/aspell/dict/pt_PT/aspell6-pt_PT-20070510-0.tar.bz2'
dictionaries[qu]='ftp://ftp.gnu.org/gnu/aspell/dict/qu/aspell6-qu-0.02-0.tar.bz2'
dictionaries[ro]='ftp://ftp.gnu.org/gnu/aspell/dict/ro/aspell5-ro-3.3-2.tar.bz2'
dictionaries[ru]='ftp://ftp.gnu.org/gnu/aspell/dict/ru/aspell6-ru-0.99f7-1.tar.bz2'
dictionaries[rw]='ftp://ftp.gnu.org/gnu/aspell/dict/rw/aspell-rw-0.50-0.tar.bz2'
dictionaries[sc]='ftp://ftp.gnu.org/gnu/aspell/dict/sc/aspell5-sc-1.0.tar.bz2'
dictionaries[sk]='ftp://ftp.gnu.org/gnu/aspell/dict/sk/aspell6-sk-2.01-2.tar.bz2'
dictionaries[sl]='ftp://ftp.gnu.org/gnu/aspell/dict/sl/aspell-sl-0.50-0.tar.bz2'
dictionaries[sr]='ftp://ftp.gnu.org/gnu/aspell/dict/sr/aspell6-sr-0.02.tar.bz2'
dictionaries[sv]='ftp://ftp.gnu.org/gnu/aspell/dict/sv/aspell-sv-0.51-0.tar.bz2'
dictionaries[sw]='ftp://ftp.gnu.org/gnu/aspell/dict/sw/aspell-sw-0.50-0.tar.bz2'
dictionaries[ta]='ftp://ftp.gnu.org/gnu/aspell/dict/ta/aspell6-ta-20040424-1.tar.bz2'
dictionaries[te]='ftp://ftp.gnu.org/gnu/aspell/dict/te/aspell6-te-0.01-2.tar.bz2'
dictionaries[tet]='ftp://ftp.gnu.org/gnu/aspell/dict/tet/aspell5-tet-0.1.1.tar.bz2'
dictionaries[tk]='ftp://ftp.gnu.org/gnu/aspell/dict/tk/aspell5-tk-0.01-0.tar.bz2'
dictionaries[tl]='ftp://ftp.gnu.org/gnu/aspell/dict/tl/aspell5-tl-0.02-1.tar.bz2'
dictionaries[tn]='ftp://ftp.gnu.org/gnu/aspell/dict/tn/aspell5-tn-1.0.1-0.tar.bz2'
dictionaries[tr]='ftp://ftp.gnu.org/gnu/aspell/dict/tr/aspell-tr-0.50-0.tar.bz2'
dictionaries[uk]='ftp://ftp.gnu.org/gnu/aspell/dict/uk/aspell6-uk-1.4.0-0.tar.bz2'
dictionaries[uz]='ftp://ftp.gnu.org/gnu/aspell/dict/uz/aspell6-uz-0.6-0.tar.bz2'
dictionaries[vi]='ftp://ftp.gnu.org/gnu/aspell/dict/vi/aspell6-vi-0.01.1-1.tar.bz2'
dictionaries[wa]='ftp://ftp.gnu.org/gnu/aspell/dict/wa/aspell-wa-0.50-0.tar.bz2'
dictionaries[yi]='ftp://ftp.gnu.org/gnu/aspell/dict/yi/aspell6-yi-0.01.1-1.tar.bz2'
dictionaries[zu]='ftp://ftp.gnu.org/gnu/aspell/dict/zu/aspell-zu-0.50-0.tar.bz2'

MAKE_INSTALLED=`which make`

if [ "x$MAKE_INSTALLED" == "x" ]; then
    echo "You need to install 'make' package to build dictionaries"
elif [ $# == 0 ]; then
    show_usage
else
    cd $HOME
    for i in "$@"
    do
        if [ ${dictionaries[$i]} ]; then
            URL=${dictionaries[$i]}
            FILE=$(basename $URL)
            FOLDER=$(basename $URL .tar.bz2)

            wget $URL
            tar xjvf $FILE
            cd $FOLDER
            termux-fix-shebang configure
            ./configure
            make
            make install
            cd ..
            rm -f $FILE
            rm -rf $FOLDER
        else
            echo "Dictionary $i not available"
        fi
    done
fi