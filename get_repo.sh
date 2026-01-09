#!/usr/bin/env bash
# shellcheck disable=SC2129

set -e

# Echo all environment variables used by this script
echo "----------- get_repo -----------"
echo "Environment variables:"
echo "CI_BUILD=${CI_BUILD}"
echo "GITHUB_REPOSITORY=${GITHUB_REPOSITORY}"
echo "RELEASE_VERSION=${RELEASE_VERSION}"
echo "VSCODE_LATEST=${VSCODE_LATEST}"
echo "VSCODE_QUALITY=${VSCODE_QUALITY}"
echo "GITHUB_ENV=${GITHUB_ENV}"

echo "SHOULD_DEPLOY=${SHOULD_DEPLOY}"
echo "SHOULD_BUILD=${SHOULD_BUILD}"
echo "-------------------------"

# git workaround
if [[ "${CI_BUILD}" != "no" ]]; then
  git config --global --add safe.directory "/__w/$( echo "${GITHUB_REPOSITORY}" | awk '{print tolower($0)}' )"
fi

AINATIVE_BRANCH="main"
echo "Cloning AINative Studio IDE ${AINATIVE_BRANCH}..."

mkdir -p vscode
cd vscode || { echo "'vscode' dir not found"; exit 1; }

git init -q

# Use GitHub token for authentication if available (for private repos)
if [[ -n "${GITHUB_TOKEN}" ]]; then
  echo "Using authenticated access with GitHub token..."
  git remote add origin "https://x-access-token:${GITHUB_TOKEN}@github.com/AINative-Studio/AINativeStudio-IDE.git"
else
  echo "Using unauthenticated access (repository must be public)..."
  git remote add origin https://github.com/AINative-Studio/AINativeStudio-IDE.git
fi

echo "Setting git configurations for non-interactive mode..."
git config --local core.askpass ""
git config --local credential.helper ""

# Allow callers to specify a particular commit to checkout via the
# environment variable VOID_COMMIT.  We still default to the tip of the
# ${AINATIVE_BRANCH} branch when the variable is not provided.  Keeping
# AINATIVE_BRANCH as "main" ensures the rest of the script (and downstream
# consumers) behave exactly as before.
if [[ -n "${VOID_COMMIT}" ]]; then
  echo "Using explicit commit ${VOID_COMMIT}"
  # Fetch just that commit to keep the clone shallow.
  echo "Fetching commit ${VOID_COMMIT}..."
  git fetch --depth 1 --no-tags origin "${VOID_COMMIT}"
  echo "Checking out ${VOID_COMMIT}..."
  git checkout "${VOID_COMMIT}"
else
  echo "Fetching branch ${AINATIVE_BRANCH}..."
  git fetch --depth 1 --no-tags origin "${AINATIVE_BRANCH}"
  echo "Checking out FETCH_HEAD..."
  git checkout FETCH_HEAD
fi

# Find jq command - try different locations
if command -v jq >/dev/null 2>&1; then
    JQ_CMD="jq"
elif [ -f "../jq.exe" ]; then
    JQ_CMD="../jq.exe"
elif [ -f "../jq" ]; then
    JQ_CMD="../jq"
else
    echo "ERROR: jq not found. Tried: jq, ../jq.exe, ../jq"
    exit 1
fi

echo "Using jq command: $JQ_CMD"

# Check if package.json is in root or in ainative-studio subdirectory
if [ -f "package.json" ]; then
    PACKAGE_DIR="."
    echo "Found package.json in root directory"
elif [ -f "ainative-studio/package.json" ]; then
    PACKAGE_DIR="ainative-studio"
    echo "Found package.json in ainative-studio subdirectory"
else
    echo "ERROR: package.json not found in root or ainative-studio subdirectory"
    ls -la
    exit 1
fi

MS_TAG=$( $JQ_CMD -r '.version' "$PACKAGE_DIR/package.json" )
MS_COMMIT=$AINATIVE_BRANCH # AINative Studio - MS_COMMIT doesn't seem to do much
VOID_VERSION=$( $JQ_CMD -r '.voidVersion' "$PACKAGE_DIR/product.json" ) # Void added this

if [[ -n "${VOID_RELEASE}" ]]; then # Void added VOID_RELEASE as optional to bump manually
  RELEASE_VERSION="${MS_TAG}${VOID_RELEASE}"
else
  VOID_RELEASE=$( $JQ_CMD -r '.voidRelease' "$PACKAGE_DIR/product.json" )
  RELEASE_VERSION="${MS_TAG}${VOID_RELEASE}"
fi
# Void - RELEASE_VERSION is later used as version (1.0.3+RELEASE_VERSION), so it MUST be a number or it will throw a semver error in void


echo "RELEASE_VERSION=\"${RELEASE_VERSION}\""
echo "MS_COMMIT=\"${MS_COMMIT}\""
echo "MS_TAG=\"${MS_TAG}\""

cd ..

# for GH actions
if [[ "${GITHUB_ENV}" ]]; then
  echo "MS_TAG=${MS_TAG}" >> "${GITHUB_ENV}"
  echo "MS_COMMIT=${MS_COMMIT}" >> "${GITHUB_ENV}"
  echo "RELEASE_VERSION=${RELEASE_VERSION}" >> "${GITHUB_ENV}"
  echo "VOID_VERSION=${VOID_VERSION}" >> "${GITHUB_ENV}" # Void added this
fi



echo "----------- get_repo exports -----------"
echo "MS_TAG ${MS_TAG}"
echo "MS_COMMIT ${MS_COMMIT}"
echo "RELEASE_VERSION ${RELEASE_VERSION}"
echo "VOID VERSION ${VOID_VERSION}"
echo "----------------------"


export MS_TAG
export MS_COMMIT
export RELEASE_VERSION
export VOID_VERSION
