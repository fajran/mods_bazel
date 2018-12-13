Mods
====

Bazel rules to define modules in a monorepo not managed by Bazel.


Usage
-----

Add the following into the `WORKSPACE` file

```python
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "mods",
    remote = "https://github.com/fajran/mods_bazel.git",
    commit = "1048864b7dfe3d3d7f02d7c64103843ac4e38cbc",
)
```

When you want to declare a module, add the following to the `BUILD` file of that module.

```python
load("@mods//mods:def.bzl", "module")

module(
    name = "service",
    srcs = glob(["**"]),
)
```


Use Cases
---------

1. Find all modules

    ```bash
    bazel query "kind(module, //...)"
    ```

2. Find all buildable modules

    ```bash
    bazel query "kind(build_trigger, //...)"
    ```

3. Find affected buildable modules from a commit

    Run this from the root git project directory. Add `--keep_going` to recover
    from failures and get as much as possible.

    ```bash
    bazel query --keep_going "kind(build_trigger, rdeps(//..., set($(git diff --name-only HEAD^))))"
    ```

