# Katas

This is a repository to hold all of the daily katas.

## Format

At the root level katas are bucketed in directories by language (e.g. `ruby` and `javascript`). Within a language directory they are grouped again by topic (e.g. `flow_control`, `methods`, etc.). Even if a kata touches on multiple topics choose the one that the exercise is meant to test.

For example, the [Fizz buzz][fizz_buzz] kata might be organized as follows:

```no-highlight
/ruby
/ruby/flow_control
/ruby/flow_control/fizz_buzz
/ruby/flow_control/fizz_buzz/.kata
/ruby/flow_control/fizz_buzz/README.md
/ruby/flow_control/fizz_buzz/lib/fizz_buzz.rb
/ruby/flow_control/fizz_buzz/test/fizz_buzz_test.rb
```

The name of the directory for the kata is known as the **slug** and is used to identify katas. Once a kata has been published the directory name for that kata *should not* change otherwise it will be treated as a brand new kata.

Within a kata directory there should exist the following files at a minimum:

* `.kata`: Contains metadata for the kata such as the display name, the difficulty level, the test suite runner, etc. More details and an example can be found in the [metadata][metadata] section.
* `README.md`: Contains the problem description, requirements, and brief instructions on how to solve it.
* `lib/...`: The `lib` directory should contain one or more placeholder files needed to solve the kata, usually in the format of `lib/<slug>.<ext>` (e.g. `lib/fizz_buzz.rb`). The user is free to add additional files as needed in this directory when solving the kata although the test suite will be expecting the placeholder file to contain the implementation.
* `test/...`: The `test` directory should contain the test suite for the kata. There should be one file in the format of `test/<slug>_test.<ext>` (e.g. `test/fizz_buzz_test.rb`) as well as any additional files needed for the test suite. The suite should require the placeholder file `lib/<slug>.<ext>` where the user will have implemented the solution.

## Metadata

Metadata should be stored in the root of each kata directory in a file named `.kata`. The metadata contains key-value pairs stored in YAML format. Valid attributes include:

* `name`: The display name of the kata.
* `difficulty`: A numerical difficulty level for the kata. At this point valid values include 1, 2, or 3 for easy, intermediate, or hard.
* `test_runner`: The command used to run the test suite. The full command will use the format `<test_runner> test/<slug>_test.<ext>`. For minitest the runner would simply be `ruby` (e.g. `ruby test/fizz_buzz_test.rb`).

An example metadata file for the Fizz buzz kata is shown here:

```YAML
---
name: Fizz buzz
difficulty: 1
test_runner: ruby
```

[fizz_buzz]: http://en.wikipedia.org/wiki/Fizz_buzz
[metadata]: #metadata
