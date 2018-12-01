# Install rules for [Bazel](https://bazel.build)

This is not an officially supported Google product.

## Rules

* [installer](docs/external/com_github_google_rules_install/src/installer.md#installer)

## Setup

1.  In the `WORKSPACE` file of your Bazel project add the following:

    ```python
    git_repository(
        name = "com_github_google_rules_install",
        remote = "https://github.com/google/bazel_rules_install.git",
        commit = "{COMMIT_ID}",
    )

    load("@com_github_google_rules_install//:deps.bzl", "install_rules_dependencies")

    install_rules_dependencies()
    ```

1.  In the `BUILD` file of the package where you want to add an installer add the following:

    ````python
    # In file src/path/to/pkg/BUILD:

    load("@com_github_google_rules_install//installer:def.bzl", "installer")

    installer(
        name = "install_foo",
        data = [":foo"],
    )
    ````

1.  Run the installer using `bazel run -c opt`. This example installs `foo` in `~/bin`:

    ```shell
    bazel run -c opt //src/path/to/pkg:install_foo ~/bin
    ```

## See also

* [Examples](examples/README.md)
