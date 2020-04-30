#!/usr/bin/env bash

# Copyright 2018 The Bazel Authors. All rights reserved.
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

set -eu

# -------------------------------------------------------------------------
# Asked to do a docs build.
if [[ -z "${RUN_REGEN_DOCS:-}" ]]; then
  echo >&2 "Skipping docs regen"
else
  if ! diff -u <(git status --porcelain=v2) /dev/null; then
    echo >&2 "Repository is not in a clean state"
    exit 1
  fi

  ./docs/regen.sh

  if ! diff -u <(git status --porcelain=v2) /dev/null; then
    echo >&2 "The documentation is out of date. Run ./docs/regen.sh"
    exit 1
  fi
fi
