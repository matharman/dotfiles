#!/bin/bash
M2MD_REPO=$1
MY_PREFIX=`pwd`
echo $MY_PREFIX

git clone git://git.kernel.org/pub/scm/utils/i2c-tools/i2c-tools.git

MY_CC=${M2MD_REPO}/tools/linaro/gcc-linaro-4.9-2015.02-3-x86_64_arm-linux-gnueabi/bin/arm-linux-gnueabi-gcc
MY_AR=${M2MD_REPO}/tools/linaro/gcc-linaro-4.9-2015.02-3-x86_64_arm-linux-gnueabi/bin/arm-linux-gnueabi-ar
MY_STRIP=${M2MD_REPO}/tools/linaro/gcc-linaro-4.9-2015.02-3-x86_64_arm-linux-gnueabi/bin/arm-linux-gnueabi-strip
pushd i2c-tools

PREFIX=$MY_PREFIX CC=$MY_CC AR=$MY_AR STRIP=$MY_STRIP make

popd
