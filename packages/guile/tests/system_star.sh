if [ "$(guile -c '(system* "echo" "Hello" "world")')" != "Hello world" ]; then
	echo 'ERROR: system* not working'
fi
