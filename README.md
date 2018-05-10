# test.sh
Tiny expect library for unit testing bash scripts

test.sh provides three functions: `test-start`, `expect` and `test-end`.

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
# Caveat - the default check is against an empty string so this will fail.
```

#### test-end

the `test-end` call should only be made once all tests fns have finished. 
this will echo a report to stdout that gives some detail about the suite run
and if there were any failures, gives a breakdown of the test function that
failed, and what parameters were used when the failure happened.

### Get
```bash
wget -N https://raw.githubusercontent.com/DavidBindloss/test.sh/master/test.sh
# or
curl -O https://raw.githubusercontent.com/DavidBindloss/test.sh/master/test.sh
```

### Use
```bash
#!/usr/bin/env bash

. test.sh

my-test-fn() {
  expect echo "0" 0
  expect echo "1" 0
}
# start timer
test-end my-test-suite

my-test-fn
# more fns...

# end timer and generate report
test-end my-test-suite

```

