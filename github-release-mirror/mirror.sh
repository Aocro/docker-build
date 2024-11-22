#!/usr/bin/env bash

# Exit on error
set -e

# Check arguments
if [ "$#" -lt 2 ]; then
    echo "Error: Missing required arguments"
    echo "Usage: $0 owner/repository [latest|all]"
    exit 1
fi

# Get repository and mode from arguments
REPO=${1}
MODE=${2}

if [[ "${MODE}" != "latest" && "${MODE}" != "all" ]]; then
    echo "Error: Mode must be either 'latest' or 'all'"
    echo "Usage: $0 owner/repository [latest|all]"
    exit 1
fi

# Constants
MIRROR_DIR="/mirror"
DEST="${MIRROR_DIR}/${REPO}"
mkdir -p ${DEST}

mirror_latest() {
    local SRC_URL="https://api.github.com/repos/${REPO}/releases/latest"
    echo "Fetching latest release for ${REPO}..."
    
    RELEASE=$(curl -s ${SRC_URL})
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fetch release information"
        exit 1

    TAG_NAME=$(echo ${RELEASE} | jq -r '.tag_name')
    if [ "${TAG_NAME}" == "null" ]; then
        echo "Error: No releases found for ${REPO}"
        exit 1
    fi

    URLS=$(echo ${RELEASE} | jq -r '.assets[].browser_download_url')
    if [ -z "${URLS}" ]; then
        echo "Warning: No assets found for release ${TAG_NAME}"
        exit 0
    fi

    RELEASE_DEST="${DEST}/${TAG_NAME}"
    if [[ -d ${RELEASE_DEST} ]]; then
        echo "Release ${TAG_NAME} already mirrored, skipping..."
        return
    fi

    echo "Mirroring release ${TAG_NAME}..."
    mkdir -p ${RELEASE_DEST}
    wget -P ${RELEASE_DEST} --no-verbose ${URLS}
    ln -sf ${TAG_NAME} ${DEST}/latest
}

mirror_all() {
    local SRC_URL="https://api.github.com/repos/${REPO}/releases"
    echo "Fetching all releases for ${REPO}..."
    
    RELEASES=$(curl -s ${SRC_URL} | jq '[.[] | {tag_name: .tag_name, draft: .draft, assets: [.assets[].browser_download_url]}]')
    
    for RELEASE in $(echo ${RELEASES} | jq -r '.[] | @base64'); do
        DRAFT=$(echo ${RELEASE} | base64 --decode | jq -r '.draft')
        NAME=$(echo ${RELEASE} | base64 --decode | jq -r '.tag_name')
        URLS=$(echo ${RELEASE} | base64 --decode | jq -r '.assets | .[]')

        if [[ "${DRAFT}" != "false" ]]; then
            continue
        fi

        RELEASE_DEST=${DEST}/${NAME}
        if [[ -d ${RELEASE_DEST} ]]; then
            echo "Release ${NAME} already mirrored, skipping..."
            continue
        fi

        echo "Mirroring release ${NAME}..."
        mkdir -p ${RELEASE_DEST}
        wget -P ${RELEASE_DEST} --no-verbose ${URLS}
    done
    
    # Update latest symlink to point to the newest release
    LATEST_TAG=$(echo ${RELEASES} | jq -r '.[0].tag_name')
    if [ "${LATEST_TAG}" != "null" ]; then
        ln -sf ${LATEST_TAG} ${DEST}/latest
    fi
}

# Main execution
echo "Starting mirror process for ${REPO} in ${MODE} mode..."

case ${MODE} in
    "latest")
        mirror_latest
        ;;
    "all")
        mirror_all
        ;;
esac

echo "Mirror process completed for ${REPO}"