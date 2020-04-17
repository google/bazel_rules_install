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

"""Installer Rules

Skylark rules for installing files using Bazel.
"""

load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:shell.bzl", "shell")

_INSTALLER_GEN_SUFFIX = "_gen"
_TEMPLATE_TARGET = "@com_github_google_rules_install//installer:installer_template"

def _install_files_depset(default_info):
    direct = []
    transitive = []
    if default_info.default_runfiles:
        transitive = [default_info.default_runfiles.files]
    if default_info.files_to_run and default_info.files_to_run.executable:
        direct = [default_info.files_to_run.executable]
    if direct or transitive:
        return depset(direct = direct, transitive = transitive)
    return None

def _gen_install_binary_impl(ctx):
    transitive_runfiles = []
    sources = []
    targets = []
    for input in ctx.attr.data:
        input_files = _install_files_depset(input[DefaultInfo])
        if not input_files:
            continue
        transitive_runfiles.append(input_files)
        for file in input_files.to_list():
            sources.append(file.short_path)
            target = paths.join(ctx.attr.target_subdir, paths.basename(file.short_path))
            targets.append(target)

    ctx.actions.expand_template(
        output = ctx.outputs.out,
        template = ctx.file._template,
        substitutions = {
            "@@SOURCE_FILES@@": shell.array_literal(sources),
            "@@TARGET_NAMES@@": shell.array_literal(targets),
            "@@EXECUTABLE@@": shell.quote(repr(ctx.attr.executable)),
            "@@INSTALLER_LABEL@@": shell.quote("@{}//{}:{}".format(
                ctx.workspace_name,
                ctx.label.package,
                # Strip leading '_' and suffix form the name.
                ctx.label.name[1:-len(_INSTALLER_GEN_SUFFIX)],
            )),
            "@@GENERATED_WARNING@@": (
                "# DO NOT EDIT THIS FILE.\n" +
                "# It was generated by {} in @{}.\n" +
                "#"
            ).format(ctx.label, ctx.workspace_name),
        },
        is_executable = True,
    )

    return [DefaultInfo(
        executable = ctx.outputs.out,
        runfiles = ctx.runfiles(
            files = [ctx.outputs.out],
            transitive_files = depset(transitive = transitive_runfiles),
        ),
    )]

def _compilation_mode_transition_impl(settings, attr):
    mode = attr.compilation_mode or settings["//command_line_option:compilation_mode"]
    return {"//command_line_option:compilation_mode": mode}

_compilation_mode_transition = transition(
    implementation = _compilation_mode_transition_impl,
    inputs = ["//command_line_option:compilation_mode"],
    outputs = ["//command_line_option:compilation_mode"],
)

_gen_installer = rule(
    implementation = _gen_install_binary_impl,
    attrs = {
        "compilation_mode": attr.string(),
        "data": attr.label_list(
            mandatory = True,
            allow_files = True,
            cfg = _compilation_mode_transition,
        ),
        "executable": attr.bool(default = True),
        "target_subdir": attr.string(default = ""),
        "_template": attr.label(
            allow_single_file = True,
            default = Label(_TEMPLATE_TARGET),
        ),
        "_whitelist_function_transition": attr.label(default = "@bazel_tools//tools/whitelists/function_transition_whitelist"),
    },
    executable = True,
    outputs = {
        "out": "%{name}.sh",
    },
)

def installer(name, data, compilation_mode = "opt", executable = True, target_subdir = ""):
    """Creates an installer

    This rule creates an installer for targets in data. Running the installer
    copies built targets to a given prefix. The prefix has to be passed as an
    argument to the installer.

    Args:
      name: A unique name of this rule.
      compilation_mode: If not empty, sets compilation_mode of targets in data.
      data: Targets to be installed. File names will not be changed.
      executable: If True, the copied files will be set as executable.
      target_subdir: Optional subdir under the prefix where the files will be
                     placed.
    """
    installer_name = "_{}{}".format(name, _INSTALLER_GEN_SUFFIX)
    _gen_installer(
        name = installer_name,
        compilation_mode = compilation_mode,
        data = data,
        executable = executable,
        target_subdir = target_subdir,
    )

    native.sh_binary(
        name = name,
        srcs = [":" + installer_name],
        deps = ["@bazel_tools//tools/bash/runfiles"],
    )
