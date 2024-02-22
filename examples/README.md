# Example of using install rules for [Bazel](https://bazel.build)

To install a "hello world" binary in `~/bin` run:

```shell
rules_install/examples$ bazel run -c opt //:install_hello_world ~/bin
```
