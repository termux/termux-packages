#! /bin/bash

set -u -e -o pipefail

post_status()
{
curl -s \
	-X POST \
	-d '{"state":"'"$2"'", "target_url":"https://gitlab.com/'"$GITUSER"'/termux-packages/builds/'"$CI_JOB_ID"'", "description":"'"$1"'", "context":"gitlab-ci/'"$CI_PIPELINE_ID"'/'"$arch"'"}' \
	https://api.github.com/repos/$GITUSER/termux-packages/statuses/$CI_COMMIT_SHA?access_token=$GITHUB_TOKEN &> /dev/null
}

on_error()
{
case $STAGE in
1)
tail -n 100 ${arch}-setup.{out,err}
post_status "Changing permissions failed." "failure"
;;
2)
tail -n 100 ${arch}-setup.{out,err}
post_status "Setup environment failed." "failure"
;;
3)
tail -n 500 ${arch}-${pkg}.out
tail -n 500 ${arch}-${pkg}.err
post_status "Build failed at ${pkg}." "failure"
;;
4)
post_status "Compression failed." "failure"
;;
5)
post_status "Time script failed." "failure"
;;
esac
}

trap 'on_error' ERR
trap 'post_status "Force termination." "error"' SIGINT SIGTERM

if [[ $1 == "-a" ]]
then artifacts=1
shift
else artifacts=0
fi

build0=$(date +"%s")
arch=$CI_JOB_NAME

export STAGE=1
date +"%F %T"
apt-get update > ${arch}-setup.out 2> ${arch}-setup.err
apt-get -y upgrade >> ${arch}-setup.out 2>> ${arch}-setup.err
apt-get install -y sudo coreutils curl >> ${arch}-setup.out 2>> ${arch}-setup.err
post_status "Changing permissions." "pending"
echo "Changing permissions..."
export FORCE_UNSAFE_CONFIGURE=1
export TERM=xterm
find . -exec chmod 777 {} \;
build1=$(date +"%s")
echo "$(( $build1 - $build0 )) seconds used."

export STAGE=2
date +"%F %T"
post_status "Setup Ubuntu" "pending"
echo "Setup ubuntu for packages..."
sudo bash scripts/setup-ubuntu.sh >> ${arch}-setup.out 2>> ${arch}-setup.err
post_status "Setup Android SDK" "pending"
echo "Setup Android SDK for packages..."
sudo bash scripts/setup-android-sdk.sh >> ${arch}-setup.out 2>> ${arch}-setup.err
build2=$(date +"%s")
echo "$(( $build2 - $build1 )) seconds used."

export STAGE=3
date +"%F %T"
git remote add compare https://github.com/$GITUSER/termux-packages.git &> /dev/null
git fetch compare &> /dev/null
gitdiff=$(git diff --name-only compare/master..HEAD)
pkglist=""
build=0
if [[ $(echo "$gitdiff" | grep -v 'packages/' | grep -v 'disabled-packages/' | grep -v 'clang' | grep -v 'check' | grep -v 'apt' | grep -v 'list') != "" ]]
then
echo "Building all packages for $arch architecture..."
build=1
elif [[ $(echo "$gitdiff" | grep 'packages/') != "" ]]
then
for pkg in $(echo "$gitdiff" | grep 'packages/')
do
pkglist+=$(echo "$pkg" | cut -d '/' -f2)
pkglist+=" "
done
echo "Building $pkglist for $arch architecture..."
build=1
fi
if [[ $build == 1 ]]
then
current=0
total=$(python3.6 scripts/buildorder.py | wc -l)
for pkg in $(python3.6 scripts/buildorder.py $pkglist)
do
export pkg
current=$(( $current + 1 ))
echo -n "Building $pkg, ${current}/${total}..."
post_status "Building ${current}/${total} packages" "pending"
buildstart=$(date +"%s")
bash build-package.sh -s -a $arch $pkg >> ${arch}-${pkg}.out 2>> ${arch}-${pkg}.err
buildend=$(date +"%s")
printf "Built in $(( $buildend - $buildstart )) seconds.\n"
done
fi
build3=$(date +"%s")
echo "$(( $build3 - $build2 )) seconds used."

if [[ $artifacts == 1 ]] && [[ $build == 1 ]];
then
export STAGE=4
date +"%F %T"
post_status "Compressing packages" "pending"
echo "Compressing packages for distribution..."
mv -f debs/*.deb .
mv -f $HOME/.termux-build/_buildall-$arch/*.{out,err} .
tar cvzf termux-packages-$arch.tar.gz *.deb
echo "Compressing logs for distribution..."
tar cvzf termux-packages-${arch}-logs.tar.gz *.out *.err
build4=$(date +"%s")
echo "$(( $build4 - $build3 )) seconds used."
fi

export STAGE=5
echo "Finished!"
date +"%F %T"
build5=$(date +"%s")
echo "$(( $build5 - $build4 )) seconds used."
post_status "Finished" "success"
