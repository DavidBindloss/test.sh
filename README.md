# test.sh
Tiny expect library for unit testing bash scripts

test.sh provides four functions: `test-start`, `expect`, `contains` and `test-end`.

#### test-start
will start a timer for monitoring tests, takes a single argument, which is the name of your test suite

#### expect

the `expect` function can test for exit codes:

`expect <function> [arg..N] <expected_exit_code (default: 0)>`

_**examples:**_
```
expect echo 0 1 foo bar buzz 0
# passes - exit code will be 0

expect my-important-function "a-amazing-variable"
# passes if my-important-function is successful 
# (note the omission of the expected status code)
```

it can also test for variable equality:

`expect <variable> <expected_value (default: "")>`

_**examples:**_

```
expect $(echo "foo") "foo"
# passes

expect "foo" "fuzz"
# fails - "foo" is not equal to "fuzz"

expect 0 0
# passes

expect 0 1
# fails - 0 != 1

expect 0
# pass
```

#### contains

`contains` is a method which returns 0 1 if a given haystack contains a needle

_**examples**_

```
contains "foobar" "f"
# returns 0

contains "foobar" "buzz"
# returns 1
```

in order to get a test result out of a contains, you can chain it with expect

```
$(contains "foobar" "f"); expect $?
# passes

$(contains "fizz" "buzz"); expect $? 1
# passes

$(contains "fizz" "buzz"); expect $?
# fails - the contains subshell returns an exit code of 1 and 1 != 0
```


#### test-end

the `test-end` call should only be made once all tests fns have finished. 
this will echo a report to stdout that gives some detail about the suite run
and if there were any failures, gives a breakdown of the test function that
failed, and what parameters were used when the failure happened.

#### Download
```bash
wget -N https://raw.githubusercontent.com/DavidBindloss/test.sh/master/test.sh
# or
curl -O https://raw.githubusercontent.com/DavidBindloss/test.sh/master/test.sh
```

#### Use
```bash
#!/usr/bin/env bash

. test.sh

my-test-fn() {
  expect echo "0" 0
  expect echo "1" 0
}
# start timer
test-start my-test-suite

my-test-fn
# more fns...

# end timer and generate report
test-end my-test-suite
```

#### Output
```bash
started my-test-suite test suite
..
completed in 0.000s
my-test-suite test suite results

Ran 2 tests - 0/2 failed, 2/2 passed
All tests in my-test-suite suite passed =D
```

#### Examples
You can run and explore the `examples.sh`

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FDavidBindloss%2Ftest.sh.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2FDavidBindloss%2Ftest.sh?ref=badge_large)
