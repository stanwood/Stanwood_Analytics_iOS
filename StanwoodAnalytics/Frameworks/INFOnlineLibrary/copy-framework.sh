#
# This script copies the correct framework over to the build product (i.e. is copies the
# framework for the current platform [iOS, tvOS, watchOS]).
# 
# After this it strips the framework from all unneeded architectures. This is neccessary
# due to an issue where the archive process in Xcode does not automatically strips unneeded
# architectures from dynamic frameworks and thus submitting to the App Store will fail. (rdar://19209161)
#
# The last part of the script then codesigns the framework with the same identity as the
# host app, so that the framework can be submitted to the App Store.
#

SCRIPTPATH=$(dirname $BASH_SOURCE)

FRAMEWORK_FILENAME="INFOnlineLibrary.framework"
FRAMEWORK_SRC_PATH="${SCRIPTPATH}/${PLATFORM_NAME}/${FRAMEWORK_FILENAME}/"
FRAMEWORK_BINARY=$(defaults read "${FRAMEWORK_SRC_PATH}Info.plist" CFBundleExecutable)

FRAMEWORK_DST_PATH="${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/${FRAMEWORK_FILENAME}/"
FRAMEWORK_DST_BINARY="${FRAMEWORK_DST_PATH}${FRAMEWORK_BINARY}"

echo "Copying INFOnlineLibrary.framework into product..."
[ -d ${FRAMEWORK_DST_PATH} ] || mkdir -p ${FRAMEWORK_DST_PATH}
cp -R "${FRAMEWORK_SRC_PATH}" "${FRAMEWORK_DST_PATH}" || exit 1

echo "Stripping non-valid architectures in INFOnlineLibrary.framework..."
FRAMEWORK_ARCHS="$(lipo -info "${FRAMEWORK_DST_BINARY}" | rev | cut -d ':' -f1 | rev)"
for arch in $FRAMEWORK_ARCHS; do
    if ! [[ "${VALID_ARCHS}" == *"${arch}"* ]]; then
      lipo -remove "${arch}" -output "${FRAMEWORK_DST_BINARY}" "${FRAMEWORK_DST_BINARY}" || exit 1
    fi
done

if [ "${CODE_SIGNING_REQUIRED}" == "YES" ]; then
	echo "Codesigning INFOnlineLibrary.framework..."
    /usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements "${FRAMEWORK_DST_BINARY}" || exit 1
fi
