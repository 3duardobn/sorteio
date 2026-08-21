#!/usr/bin/env bash
# Roleta
# Copyright (C) 2026 Eduardo Barroso Nunes
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# SPDX-License-Identifier: GPL-3.0-only
set -euo pipefail

export PATH="/home/eduardo/projetos/bin/flutter/flutter/bin:$PATH"
export ANDROID_HOME="${ANDROID_HOME:-/home/eduardo/Android/Sdk}"
export JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk-amd64}"

source "$HOME/projetos/personal/keystores/signing.env"
export KEYSTORE_PATH="$ROLETA_KEYSTORE"
export KEYSTORE_PASSWORD="$ROLETA_PASSWORD"
export KEY_ALIAS="$ROLETA_ALIAS"
export KEY_PASSWORD="$ROLETA_PASSWORD"

flutter config --jdk-dir="$JAVA_HOME" >/dev/null

echo "==> pub get"
flutter pub get

echo "==> analyze"
flutter analyze

echo "==> test"
flutter test

echo "==> build APK (release)"
flutter build apk --release

echo "==> build AAB (release)"
flutter build appbundle --release

echo ""
echo "APK: build/app/outputs/flutter-apk/app-release.apk"
echo "AAB: build/app/outputs/bundle/release/app-release.aab"
