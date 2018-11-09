# Copyright 2018 The Bazel Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Dependencies for @com_github_google_rules_install"""

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def install_rules_dependencies():
  """Fetches dependencies for @com_github_google_rules_install"""
  _maybe(
      git_repository,
      name = "bazel_skylib",
      remote = "https://github.com/bazelbuild/bazel-skylib.git",
      commit = "6e2d7e4a75b8ec0c307cf2ff2ca3d837633413ca",  # 2018-09-28
  )

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)