#!/usr/bin/env bash
# shellcheck disable=SC1091

set -ex

if [[ "${CI_BUILD}" == "no" ]]; then
  exit 1
fi

tar -xzf ./vscode.tar.gz

cd vscode || { echo "'vscode' dir not found"; exit 1; }

# Check if package.json is in root or in ainative-studio subdirectory
if [[ -f "package.json" ]]; then
    echo "Found package.json in root directory"
elif [[ -f "ainative-studio/package.json" ]]; then
    echo "Found package.json in ainative-studio subdirectory"
    cd ainative-studio || { echo "'ainative-studio' dir not found"; exit 1; }
else
    echo "ERROR: package.json not found in root or ainative-studio subdirectory"
    ls -la
    exit 1
fi

for i in {1..5}; do # try 5 times
  if [[ -f "package-lock.json" ]]; then
    npm ci && break
  else
    echo "No package-lock.json found, using npm install"
    npm install && break
  fi
  if [[ $i -eq 3 ]]; then
    echo "Npm install failed too many times" >&2
    exit 1
  fi
  echo "Npm install failed $i, trying again..."
done

node build/azure-pipelines/distro/mixin-npm

. ../build/windows/rtf/make.sh

npm run gulp "vscode-win32-${VSCODE_ARCH}-min-ci"

. ../build_cli.sh

if [[ "${VSCODE_ARCH}" == "x64" ]]; then
  if [[ "${SHOULD_BUILD_REH}" != "no" ]]; then
    echo "Building REH"
    npm run gulp minify-vscode-reh
    npm run gulp "vscode-reh-win32-${VSCODE_ARCH}-min-ci"
  fi

  if [[ "${SHOULD_BUILD_REH_WEB}" != "no" ]]; then
    echo "Building REH-web"
    npm run gulp minify-vscode-reh-web
    npm run gulp "vscode-reh-web-win32-${VSCODE_ARCH}-min-ci"
  fi
fi

cd ..
