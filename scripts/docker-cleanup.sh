#!/bin/bash
set -e -u

echo "Cleaning APT"
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

echo "Cleaning unneeded NDK modules"
cd /home/builder/lib/android-ndk/sources
rm -Rf cxx-stl/system third_party/shaderc third_party/vulkan
cd /home/builder/lib/android-ndk/platforms
rm -Rf android-16 android-17 android-18 android-19
cd /home/builder/lib/android-ndk
rm -Rf shader-tools

echo "Cleaning unneeded SDK modules"
cd /home/builder/lib/android-sdk/tools
mkdir -p lib2
cp $(grep "CLASSPATH=" bin/sdkmanager | head -n 1 | cut -d '=' -f 2 | tr ':' ' ' | sed 's%\$APP_HOME/%%g') lib2
rm -Rf emulator* lib proguard template support/*.txt
mv lib2 lib
cd /home/builder/lib/android-sdk/platforms
rm -Rf android-21/templates android-28/templates

echo "Zipping notices"
cd /home/builder/lib/android-ndk
bzip2 NOTICE NOTICE.toolchain sysroot/NOTICE
cd /home/builder/lib/android-sdk
bzip2 tools/NOTICE.txt build-tools/28.0.3/NOTICE.txt platform-tools/NOTICE.txt
cd /home/builder/lib/android-sdk/platforms
bzip2 android-21/skins/NOTICE.txt android-21/data/NOTICE.txt android-28/skins/NOTICE.txt android-28/data/NOTICE.txt

echo "Removing duplicate files"
fdupes -r -1 /home/builder/lib/android-ndk /home/builder/lib/android-sdk | \
	while read line; do
		master=""
		for file in ${line[*]}; do
			if [ "x${master}" == "x" ]; then
				master=$file
			else
				ln -sf "${master}" "${file}"
			fi
		done
	done

echo "Cleaning done"
