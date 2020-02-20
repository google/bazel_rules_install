#!/bin/bash

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

set -eu

# -------------------------------------------------------------------------
# Asked to do a buildifier run.
if [[ -z "${RUN_BUILDIFIER:-}" ]]; then
  echo >&2 "Skipping buildifier"
else
  if ! diff -u <(git status --porcelain=v2) /dev/null; then
    echo >&2 "Repository is not in a clean state"
    exit 1
  fi

  if ! bazel run  --show_progress_rate_limit=30.0 :buildifier -- --mode=check; then
    echo >&2 "Run `bazel run :buildifier`"
    exit 1
  fi
fi
