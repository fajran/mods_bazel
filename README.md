Mods
====

Bazel rules to define modules in a monorepo not managed by Bazel.



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

