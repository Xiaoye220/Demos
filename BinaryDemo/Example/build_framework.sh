#!/bin/sh

#要build的target名
TARGET_NAME="Binary_framework"
if [[ $1 ]]
then
TARGET_NAME=$1
fi

# 项目名
PROJECT_NAME="Binary"

# 模拟器支持架构,i386 x86_64
SIMULATOR_ARCHS="x86_64" 

# 真机支持架构,armv7 armv7s arm64
IPHONEOS_ARCHS="arm64"

CONFIGURATION="Release"

#构建一个xcode工作空间，你必须通过-workspace和-scheme定义这个构建。scheme参数控制哪一个targets被构建如何被构建
WORKSPACE="${PROJECT_NAME}.xcworkspace"
SCHEME="${TARGET_NAME}"

# 编译真机的Framework
xcodebuild -workspace "${WORKSPACE}" -scheme "${SCHEME}" ARCHS="${IPHONEOS_ARCHS}" -configuration "${CONFIGURATION}" -sdk "iphoneos" clean build CONFIGURATION_BUILD_DIR="build/${CONFIGURATION}-iphoneos" LIBRARY_SEARCH_PATHS="./Pods/build/${CONFIGURATION}-iphoneos"

#编译模拟器的Framework
xcodebuild -workspace "${WORKSPACE}" -scheme "${SCHEME}" ARCHS="${SIMULATOR_ARCHS}" -configuration "${CONFIGURATION}" -sdk "iphonesimulator" clean build CONFIGURATION_BUILD_DIR="build/${CONFIGURATION}-iphonesimulator" LIBRARY_SEARCH_PATHS="./Pods/build/${CONFIGURATION}-iphonesimulator"

# 创建输出目录，并删除之前的framework文件
OUTPUT_DIR="output"
mkdir -p "${OUTPUT_DIR}"

# 执行 xcodebuild 会在该目录下生成 framework
BUILD_DIR="build"

#拷贝framework到universal目录
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework" "${OUTPUT_DIR}"

#真机静态库路径
IPHONEOS_PATH="${BUILD_DIR}/${CONFIGURATION}-iphoneos/${TARGET_NAME}.framework/${TARGET_NAME}"
#模拟器静态库路径
SIMULATOR_PATH="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework/${TARGET_NAME}"
#输出路径
OUTPUT_PATH="${OUTPUT_DIR}/${TARGET_NAME}.framework/${TARGET_NAME}"

#合并framework，输出最终的framework到build目录
lipo -create "${IPHONEOS_PATH}" "${SIMULATOR_PATH}"  -output "${OUTPUT_PATH}" 

# 删除 build 文件夹
# rm -rf "${BUILD_DIR}"

#打开合并后的文件夹
# open "${OUTPUT_DIR}"

