#!/bin/bash

set -x

CURRENT=`pwd`
__pr="--print-path"
__name="xcode-select"
DEVELOPER=`${__name} ${__pr}`

SDKVERSION=`xcrun -sdk iphoneos --show-sdk-version`

MIN_IOS="14.0"

BITCODE="-fembed-bitcode"

OSX_PLATFORM=`xcrun --sdk macosx --show-sdk-platform-path`
OSX_SDK=`xcrun --sdk macosx --show-sdk-path`

IPHONEOS_PLATFORM=`xcrun --sdk iphoneos --show-sdk-platform-path`
IPHONEOS_SDK=`xcrun --sdk iphoneos --show-sdk-path`

IPHONESIMULATOR_PLATFORM=`xcrun --sdk iphonesimulator --show-sdk-platform-path`
IPHONESIMULATOR_SDK=`xcrun --sdk iphonesimulator --show-sdk-path`

CLANG=`xcrun --sdk iphoneos --find clang`
CLANGPP=`xcrun --sdk iphoneos --find clang++`


build()
{
	ARCH=$1
	SDK=$2
	PLATFORM=$3
	COMPILEARGS=$4
	CONFIGUREARGS=$5

	make clean
	make distclean

	export PATH="${PLATFORM}/Developer/usr/bin:${DEVELOPER}/usr/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

	EXTRAS=""
	if [ "${ARCH}" != "x86_64" ]; then
		EXTRAS="-miphoneos-version-min=${MIN_IOS} -no-integrated-as -arch ${ARCH} -target ${ARCH}-apple-darwin"
	fi

	CFLAGS="${BITCODE} -isysroot ${SDK} -Wno-error -Wno-implicit-function-declaration ${EXTRAS} ${COMPILEARGS}"

	./configure CC="${CLANG} ${CFLAGS}"  CPP="${CLANG} -E"  CPPFLAGS="${CFLAGS}" \
	--host=aarch64-apple-darwin --disable-assembly --enable-static --disable-shared ${CONFIGUREARGS}

	echo "make in progress for ${ARCH}"
	make &> "${CURRENT}/build.log"
}

# code signing: get the correct expanded identity with the command $security find-identity 

rm -rf iPhone simulator catalyst
mkdir iPhone simulator catalyst

cd gmp

build "arm64" "${IPHONEOS_SDK}" "${IPHONEOS_PLATFORM}"
cp .libs/libgmp.a ../iPhone/libgmp.a

build "x86_64" "${IPHONESIMULATOR_SDK}" "${IPHONESIMULATOR_PLATFORM}"
cp .libs/libgmp.a ../simulator/libgmp.a

build "x86_64" "${OSX_SDK}" "${OSX_PLATFORM}" "-target x86_64-apple-ios-macabi"
cp .libs/libgmp.a ../catalyst/libgmp.a

cd ../mpfr
build "arm64" "${IPHONEOS_SDK}" "${IPHONEOS_PLATFORM}" "" "--with-gmp-lib=/Users/joachim/projects/Calculator/dist/iPhone --with-gmp-include=/Users/joachim/projects/Calculator/dist/include"
cp src/.libs/libmpfr.a ../iPhone/libmpfr.a

build "x86_64" "${IPHONESIMULATOR_SDK}" "${IPHONESIMULATOR_PLATFORM}" "" "--with-gmp-lib=/Users/joachim/projects/Calculator/dist/simulator --with-gmp-include=/Users/joachim/projects/Calculator/dist/include"
cp src/.libs/libmpfr.a ../simulator/libmpfr.a

build "x86_64" "${OSX_SDK}" "${OSX_PLATFORM}" "-target x86_64-apple-ios-macabi" "--with-gmp-lib=/Users/joachim/projects/Calculator/dist/catalyst --with-gmp-include=/Users/joachim/projects/Calculator/dist/include"
cp src/.libs/libmpfr.a ../catalyst/libmpfr.a

cd ..

codesign -s 5D0F9B026D6B6975270955D7CA9A986F6D6B0DE1 iPhone/libgmp.a
codesign -s 5D0F9B026D6B6975270955D7CA9A986F6D6B0DE1 iPhone/libmpfr.a
codesign -s 5D0F9B026D6B6975270955D7CA9A986F6D6B0DE1 simulator/libgmp.a
codesign -s 5D0F9B026D6B6975270955D7CA9A986F6D6B0DE1 simulator/libmpfr.a
codesign -s 5D0F9B026D6B6975270955D7CA9A986F6D6B0DE1 catalyst/libgmp.a
codesign -s 5D0F9B026D6B6975270955D7CA9A986F6D6B0DE1 catalyst/libmpfr.a

rm -rf mpfr.xcframework gmp.xcframework
xcodebuild -create-xcframework -library iPhone/libgmp.a  -library simulator/libgmp.a  -library catalyst/libgmp.a  -output gmp.xcframework
xcodebuild -create-xcframework -library iPhone/libmpfr.a -library simulator/libmpfr.a -library catalyst/libmpfr.a -output mpfr.xcframework
