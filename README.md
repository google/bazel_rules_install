# Install rules for [Bazel](https://bazel.build)

This is not an officially supported Google product.

## Overview

This project aims at making it easy to install Bazel projects on local
workstations.

### Features

- [ ] `installer` rule:
    - [x] Installs given file(s) in a directory.
    - [ ] Installs a directory tree.
    - [x] Prevents accidental installation of debug builds.
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

1.  In the `WORKSPACE` file of your Bazel project add the following:

    ```python
    load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

    http_archive(
        name = "com_github_google_rules_install",
        urls = ["https://github.com/google/bazel_rules_install/releases/download/0.3/bazel_rules_install-0.3.tar.gz"],
        sha256 = "ea2a9f94fed090859589ac851af3a1c6034c5f333804f044f8f094257c33bdb3",
        strip_prefix = "bazel_rules_install-0.3",
    )

    load("@com_github_google_rules_install//:deps.bzl", "install_rules_dependencies")

    install_rules_dependencies()

    load("@com_github_google_rules_install//:setup.bzl", "install_rules_setup")

    install_rules_setup()
    ```

1.  In the `BUILD` file of the package where you want to add an installer add
    the following:

    ````python
    # In file src/path/to/pkg/BUILD:

    load("@com_github_google_rules_install//installer:def.bzl", "installer")

    installer(
        name = "install_foo",
        data = [":foo"],
    )
    ````

## Usage

Run the `installer` using `bazel run`. The following example installs `foo` in
`~/bin`:

```shell
bazel run //src/path/to/pkg:install_foo -c opt -- ~/bin
```

### sudo

If you need to use `sudo` to install a file in a system directory:

* **Do not** run `sudo bazel`.
* Instead pass flag `-s` to the installer.

```shell
bazel run //src/path/to/pkg:install_foo -c opt -- -s /usr/local/bin
```

## See also

* [Examples](examples/README.md)
