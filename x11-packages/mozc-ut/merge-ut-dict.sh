#! /bin/sh

USE_DICTS=
#USE_DICTS="$USE_DICTS alt-cannadic"
#USE_DICTS="$USE_DICTS edict2"
USE_DICTS="$USE_DICTS jawiki"
USE_DICTS="$USE_DICTS neologd"
USE_DICTS="$USE_DICTS personal-names"
USE_DICTS="$USE_DICTS place-names"
#USE_DICTS="$USE_DICTS skk-jisyo"
USE_DICTS="$USE_DICTS sudachidict"

if [ -z "$1" ]; then
    DATE=$(date +"%Y-%m-%d")
else
    DATE="$(echo $1|awk '{printf "%s-%s-%s",substr($0,0,4),substr($0,5,2),substr($0,7,2)}')"
fi

rm -f mozcdic-ut.txt
rm -rf mozcdic-ut-*/{*,.git}

module_checkout() {
    name="mozcdic-ut-$1"
    git clone "https://github.com/utuhiro78/${name}.git"
    cd "$name"
    echo $(git rev-list -n 1 --before="$DATE 23:59" main)
    git reset --hard $(git rev-list -n 1 --before="$DATE 23:59" main)
    cd ..
}

for d in $USE_DICTS; do module_checkout "$d"; done
mv mozcdic-ut-*/mozcdic-ut-*.txt.tar.bz2 .
for f in mozcdic-ut-*.txt.tar.bz2; do tar xf "$f"; done

cat mozcdic-ut-*.txt > mozcdic-ut.txt

ruby remove_duplicate_ut_entries.rb mozcdic-ut.txt
ruby count_word_hits.rb
ruby apply_word_hits.rb mozcdic-ut.txt
