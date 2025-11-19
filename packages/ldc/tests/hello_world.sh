ldc2 --version
ldmd2 --version
dub --version

echo 'void main() { import std.stdio; writefln("Hello world, %d bits", size_t.sizeof * 8); }' > hello.d
ldc2 hello.d
./hello
rm hello.{d,o} hello
