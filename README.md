# Install rules for [Bazel](https://bazel.build)

This is not an officially supported Google product.

## Overview

This project aims at making it easy to install Bazel projects on local workstations.
Think: `make install`. Someday: `bazel run install`.

### Features

- [ ] `installer` rule:
    - [x] Installs given file(s) in a directory.
    - [ ] Installs a directory tree.
    - [x] Prevents accidental instalation of debug builds (disabled with a `-g` flag).
    - [ ] Renames installed files.
    - [ ] Selects a sensible default install prefix.
    - [ ] When needed asks for write access (`sudo`).
- [ ] OS support:
    - [x] Linux
    - [ ] macOS
    - [ ] Windows

## Rules

* [installer](docs/installer_rule.md#installer)

## Setup

1.  In the WORKSPACE file of your Bazel project add the following:

    ```python
    git_repository(
        name = "com_github_google_rules_install",
        remote = "https://github.com/google/bazel_rules_install.git",
        tag = "0.0.2",
    )

    load("@com_github_google_rules_install//:deps.bzl", "install_rules_dependencies")

    install_rules_dependencies()
    ```

1.  In the BUILD file of the package where you want to add an installer add the following:

    ````python
    # In file src/path/to/pkg/BUILD:

    load("@com_github_google_rules_install//installer:def.bzl", "installer")

    installer(
        name = "install_foo",
        data = [":foo"],
    )
    ````

1.  Run the installer using `bazel run`. This example installs `foo` in `~/bin`:

    ```shell
    bazel run //src/path/to/pkg:install_foo -c opt ~/bin
    ```

    If you need to use `sudo` to install a file in a system directory:

    * **Do not** run `sudo bazel`.
    * Instead pass flag `-s` to the installer.

    ```shell
    bazel run //src/path/to/pkg:install_foo -c opt -- -s /usr/local/bin
    ```

## See also

* [Examples](examples/README.md)
