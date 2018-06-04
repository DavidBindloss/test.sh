#!/usr/bin/env bash

# import test.sh
. test.sh

test-start 'example-test-suite'

# Call expect plain directly
expect "foo" "foo"

function test-case() {
  CMD=$(echo "foo")
  expect "$CMD" "foo"
}

# or call a function 
test-case

# calling a function will return an exit code for expect to validate
expect echo "foo" 0
# we expect echo foo to execute successfully

expect echo "foo"
# The same as above 0 is the expected exit code of any function

# contains by itself doesn\'t do anything
contains "foo" "f"
# But does set the exit code, here $? will be 0

# which means
contains "foo" "f"; expect $?
# will assert that the contains fn returns a 0 exit code

# Get funky expect 1 to not equal 0:
[ 1 -eq 0 ]; expect $([ $? -eq 1 ]) 0

[ "foo" = "foo" ]; expect $?

# Or even 
curl -Ss https://google.com > /dev/null; expect $?