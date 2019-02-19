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
rm -Rf emulator* lib* proguard template support/*.txt
cd /home/builder/lib/android-sdk/platforms
rm -Rf android-21/templates android-28/templates

echo "Removing duplicate files"
fdupes -r -1 /home/builder/lib/android-ndk /home/builder/lib/android-sdk | \
	while read line; do
		master=""
		for file in ${line[*]}; do
			if [ "x${master}" == "x" ]; then
				master=$file
			else
				ln -f "${master}" "${file}"
			fi
		done
	done

echo "Cleaning done"
