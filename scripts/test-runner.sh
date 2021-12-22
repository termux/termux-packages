#!/data/data/com.termux/files/usr/bin/bash

if [ $# != 1 ]; then
	echo "Specify package to run tests for as only argument"
	exit 1
fi

PACKAGE=$1
TEST_DIR=packages/$PACKAGE/tests

if [ ! -d $TEST_DIR ]; then
	echo "ERROR: No tests folder for package $PACKAGE"
	exit 1
fi

NUM_TESTS=0
NUM_FAILURES=0

for TEST_SCRIPT in $TEST_DIR/*; do
	test -t 1 && printf "\033[32m"
	echo "Running test ${TEST_SCRIPT}..."
	(( NUM_TESTS += 1 ))
	test -t 1 && printf "\033[31m"
	(
		assert_equals() {
			FIRST=$1
			SECOND=$2
			if [ "$FIRST" != "$SECOND" ]; then
				echo "assertion failed - expected '$FIRST', got '$SECOND'"
				exit 1
			fi
		}
		set -e -u
		. $TEST_SCRIPT
	)
	if [ $? != 0 ]; then
		(( NUM_FAILURES += 1 ))
	fi
	test -t 1 && printf "\033[0m"
done

echo "$NUM_TESTS tests run - $NUM_FAILURES failure(s)"
