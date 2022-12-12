#!/usr/bin/env bash

# Copyright 2019 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -xeu

cd "$(dirname "$0")"

if [[ "${CI:-false}" = "true" ]]; then
  declare -r installdir="${GITHUB_WORKSPACE}/testinstall"
  mkdir -p "${installdir}"
else
  declare -r installdir="$(mktemp -d)"
fi

ls -alh "${installdir}"

bazel run  --show_progress_rate_limit=30.0 -c opt :install_buildifier -- "${installdir}"
"${installdir}/buildifier" --version

rm -rf "${installdir}"
