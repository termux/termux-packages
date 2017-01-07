# https://github.com/termux/termux-app/issues/232
set -e -u

RESULT=$(echo -n 123456 | tail -c 3)
if [ "$RESULT" != 456 ]; then
	echo "Test failed - expectd 456, got $RESULT"
	exit 1
fi
