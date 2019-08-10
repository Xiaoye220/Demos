
#要build的target名
TARGET_NAME="Binary_lib"
if [[ $1 ]]
then
TARGET_NAME=$1
fi

# 项目名
PROJECT_NAME="Binary"

# 模拟器支持架构,i386 x86_64
SIMULATOR_ARCHS="x86_64" 
#
# 真机支持架构,armv7 armv7s arm64
IPHONEOS_ARCHS="arm64"

CONFIGURATION="Release"



PROJECT=${PROJECT_NAME}.xcodeproj

TARGET="${TARGET_NAME}"

# 制作的静态库在根目录的 build 文件夹下
# 制作真机的静态库
xcodebuild -project $PROJECT -target $TARGET -sdk "iphoneos" -configuration $CONFIGURATION ARCHS="${IPHONEOS_ARCHS}" build CONFIGURATION_BUILD_DIR="build/${CONFIGURATION}-iphoneos" LIBRARY_SEARCH_PATHS="./Pods/build/${CONFIGURATION}-iphoneos" HEADER_SEARCH_PATHS="./Pods/Headers/Public"
# 制作模拟器的静态库
xcodebuild -project $PROJECT -target $TARGET -sdk "iphonesimulator" -configuration $CONFIGURATION ARCHS="${SIMULATOR_ARCHS}" build CONFIGURATION_BUILD_DIR="build/${CONFIGURATION}-iphonesimulator" LIBRARY_SEARCH_PATHS="./Pods/build/${CONFIGURATION}-iphonesimulator" HEADER_SEARCH_PATHS="./Pods/Headers/Public"

#静态库名
LIB_NAME="lib${TARGET}.a"
#真机静态库路径
IPHONEOS_PATH="build/${CONFIGURATION}-iphoneos/${LIB_NAME}"
#模拟器静态库路径
SIMULATOR_PATH="build/${CONFIGURATION}-iphonesimulator/${LIB_NAME}"
#include 路径
INCLUDE_PATH="build/${CONFIGURATION}-iphoneos/include"

#输出文件夹
OUTPUT_DIR="output"
#创建输出文件夹
mkdir -p "${OUTPUT_DIR}"

# *************************************
# .a 静态库合并成 framework 静态库所做操作
# *************************************
mkdir -p "${OUTPUT_DIR}/${TARGET}.framework/Versions/A/Headers"
ln -sfh "A" "${OUTPUT_DIR}/${TARGET}.framework/Versions/Current"
ln -sfh "Versions/Current/Headers" "${OUTPUT_DIR}/${TARGET}.framework/Headers"
ln -sfh "Versions/Current/${TARGET}" "${OUTPUT_DIR}/${TARGET}.framework/${TARGET}"

cp -a "build/${CONFIGURATION}-iphoneos/include/${TARGET}/" "${OUTPUT_DIR}/${TARGET}.framework/Versions/A/Headers"

#输出路径
OUTPUT_PATH="${OUTPUT_DIR}/${TARGET}.framework/Versions/A/${TARGET}"

#合并真机、模拟器静态库为一个，-create 输入两个静态库的路径，-output 输出静态库路径
lipo -create "${IPHONEOS_PATH}" "${SIMULATOR_PATH}" -output "${OUTPUT_PATH}"