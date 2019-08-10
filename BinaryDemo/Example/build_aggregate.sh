TARGET_NAME="PackageFramework"
if [[ $1 ]]
then
TARGET_NAME=$1
fi

PROJECT_NAME="Binary"

WORKSPACE="${PROJECT_NAME}.xcworkspace"
SCHEME="${TARGET_NAME}"

xcodebuild -workspace "${WORKSPACE}" -scheme "${SCHEME}" build