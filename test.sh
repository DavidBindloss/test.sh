#!/usr/bin/env bash

TESTS_RAN=0
PASSED=0
FAILED=()

darwin-now() {
    echo "$(python -c 'import time; print "%.9f" % time.time()')" | sed 's/\.//g'
}

function test-start() {
    # What env are we in?
    OS=$(echo $OSTYPE | sed 's/[[:digit:]]//g')
    case "$OS" in
        darwin) START=$(darwin-now);;
        *) START="$(date +%s%N)";;
    esac
    SUITE_NAME="$1"
    echo "starting \"$SUITE_NAME\" test suite"
}

function expect() {
    (( TESTS_RAN++ ))
    CALLING=${FUNCNAME[${#FUNCNAME[@]}-2]}
    EXPECTED="${@:${#}}"
    if [ $(type -t "$1") ]; then
        if [ ${#} -le 2 ]; then
            EXPECTED=0
            ARGS=$2
        else
            ARGS=(${@:2:${#}-2})
        fi
        RESULT=$($1 "$ARGS")
        RESULT_EXIT_CODE=$?
        if [[ "$RESULT_EXIT_CODE" -eq "$EXPECTED" ]]; then
            (( PASSED++ ))
            printf .
        else
            CALLER=($(caller))
            LINE_NO=${CALLER[0]}
            FILENAME=$(echo ${CALLER[1]} | rev | cut -d'/' -f1 | rev)
            FAILED+=("\t$FILENAME: ($CALLING:$LINE_NO) \"$1\" returned $RESULT_EXIT_CODE, expected $EXPECTED")
            printf F
        fi
    else
        if [ ${#} -eq 1 ]; then
            EXPECTED=0
        fi
        # Assume it's a plain equality check
        # in this case we will only have two args: Expected and Result
        if [ "$1" -eq "$EXPECTED" ] 2>/dev/null|| [ "$1" = "$EXPECTED" ] 2>/dev/null; then
            (( PASSED++ ))
            printf .
        else
            # Where did the test fail?
            CALLER=($(caller))
            LINE_NO=${CALLER[0]}
            FILENAME=$(echo ${CALLER[1]} | rev | cut -d'/' -f1 | rev)
            FAILED+=("\t$FILENAME: ($CALLING:$LINE_NO) \"$1\" is not equal to \"$EXPECTED\"")
            printf F
        fi
    fi
}

function contains() {
    [[ $1 != *$2* ]] && exit 1 || :
}

function test-end() {
    # create a report
    END=$(darwin-now)
    local tests_time="$(printf "%010d" "$(( ${END/%N/000000000} - ${START/%N/000000000} ))")"
    echo -e "\ncompleted tests in ${tests_time:0:${#tests_time}-9}.${tests_time:${#tests_time}-9:3}s"
    FAILED_TESTS=${#FAILED[@]}
    echo -e "\nRan ${TESTS_RAN} tests - ${FAILED_TESTS}/${TESTS_RAN} failed, ${PASSED}/${TESTS_RAN} passed"

    # Print trace of failed tests
    if [ ${FAILED_TESTS} -gt 0 ]; then
		echo -e "Failed tests:\n"
        for ERROR in "${FAILED[@]}"; do
            echo -e "$ERROR"
        done
		exit 1
    else
        echo "All tests in \"$SUITE_NAME\" suite passed =D"
		exit 0
    fi
}

trap test-end EXIT
