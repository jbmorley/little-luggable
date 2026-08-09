#!/usr/bin/env bash

# Copyright (c) 2018-2026 Jason Morley
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -e
set -o pipefail
set -x
set -u

ROOT_DIRECTORY="$( cd "$( dirname "$( dirname "${BASH_SOURCE[0]}" )" )" &> /dev/null && pwd )"
ARTIFACTS_DIRECTORY="$ROOT_DIRECTORY/artifacts"
BUILD_DIRECTORY="$ROOT_DIRECTORY/build"
SCRIPTS_DIRECTORY="$ROOT_DIRECTORY/scripts"

ENV_PATH="$ROOT_DIRECTORY/.env"
RELEASE_SCRIPT_PATH="$SCRIPTS_DIRECTORY/gh-release.sh"

# Check that the GitHub command is available on the path.
which gh || (echo "GitHub cli (gh) not available on the path." && exit 1)

# Source the .env file if present, to ease local development.
if [ -f "$ENV_PATH" ] ; then
    echo "Sourcing .env..."
    source "$ENV_PATH"
fi

# Fall back to computing the version and build numbers if CI hasn't set them.
VERSION_NUMBER=${VERSION_NUMBER:-$(changes version)}
BUILD_NUMBER=${BUILD_NUMBER:-$(build-tools generate-build-number)}

cd "$ROOT_DIRECTORY"

# Recreate the output directory.
if [ -d "$BUILD_DIRECTORY" ] ; then
    rm -r "$BUILD_DIRECTORY"
fi
mkdir -p "$BUILD_DIRECTORY"

# List the downloaded firmware artifacts.
find "$ARTIFACTS_DIRECTORY"

cd "$BUILD_DIRECTORY"

# nice!nano v1.
LITTLE_KEYBOARD_NICE_NANO_V1_NAME="little-keyboard-nice-nano-v1-$VERSION_NUMBER-$BUILD_NUMBER.uf2"
cp "$ARTIFACTS_DIRECTORY/little-keyboard-nice-nano-v1.uf2" "$LITTLE_KEYBOARD_NICE_NANO_V1_NAME"

# nice!nano v2.
LITTLE_KEYBOARD_NICE_NANO_V2_NAME="little-keyboard-nice-nano-v2-$VERSION_NUMBER-$BUILD_NUMBER.uf2"
cp "$ARTIFACTS_DIRECTORY/little-keyboard-nice-nano-v2.uf2" "$LITTLE_KEYBOARD_NICE_NANO_V2_NAME"

# Settings reset firmware. This wipes the on-device settings partition (bonds
# and the stored BLE device name); it is version-independent, so it keeps a
# stable filename rather than being tagged with the version and build numbers.
SETTINGS_RESET_NICE_NANO_V1_NAME="settings-reset-nice-nano-v1.uf2"
cp "$ARTIFACTS_DIRECTORY/settings-reset-nice-nano-v1.uf2" "$SETTINGS_RESET_NICE_NANO_V1_NAME"

SETTINGS_RESET_NICE_NANO_V2_NAME="settings-reset-nice-nano-v2.uf2"
cp "$ARTIFACTS_DIRECTORY/settings-reset-nice-nano-v2.uf2" "$SETTINGS_RESET_NICE_NANO_V2_NAME"

changes \
    release \
    --skip-if-empty \
    --push \
    --exec "$RELEASE_SCRIPT_PATH" \
    "$BUILD_DIRECTORY/$LITTLE_KEYBOARD_NICE_NANO_V1_NAME" \
    "$BUILD_DIRECTORY/$LITTLE_KEYBOARD_NICE_NANO_V2_NAME" \
    "$BUILD_DIRECTORY/$SETTINGS_RESET_NICE_NANO_V1_NAME" \
    "$BUILD_DIRECTORY/$SETTINGS_RESET_NICE_NANO_V2_NAME"
