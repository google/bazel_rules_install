# Example of using install rules for [Bazel](https://bazel.build)

To install
[buildifier from bazelbuild/buildtools](https://github.com/bazelbuild/buildtools/blob/master/buildifier/README.md)
in `~/bin` run:

```shell
rules_install/examples$ bazel run -c opt //:install_buildifier ~/bin
```
