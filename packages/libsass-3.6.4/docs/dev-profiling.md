# Profiling LibSass

## Linux perf and pprof

On Linux, you can record the profile with `perf` and inspect it with `pprof`.

### Install required tools

Pre-requisites:

1. Linux `perf`, commonly found in the `linux-tools-generic` package.
2. [go], for installing `pprof`.
3. [bazel], for installing `perf_to_profile`.

[go]: https://golang.org
[bazel]: https://bazel.build

First, install `pprof` with:

```bash
go get -u github.com/google/pprof
```

Then, build and install `perf_to_profile`:

```bash
git clone https://github.com/google/perf_data_converter
cd perf_data_converter
bazel build -c opt src:perf_to_profile
sudo cp bazel-bin/src/perf_to_profile /usr/local/bin/
```

Finally, in your libsass repository, clone and build `sassc`:

```bash
git clone https://github.com/sass/sassc.git
make sassc
```

### Record perf data

```bash
sudo perf record sassc/bin/sassc input.scss > /dev/null && sudo chown $USER:$USER perf.data
```

This will create a `perf.data` file that you can vizualize with `pprof`.

### Inspect perf data

A web server with various visualization options:

```bash
pprof -http=localhost:3232 sassc/bin/sassc perf.data
```

Simple text output:

```bash
pprof -text sassc/bin/sassc perf.data
```

Example output:

```
      flat  flat%   sum%        cum   cum%
  24651348  6.97%  6.97%   24651348  6.97%  [[kernel.kallsyms]]
  20746241  5.87% 12.84%   20746241  5.87%  Sass::SharedPtr::decRefCount
  18401663  5.20% 18.04%   20420896  5.78%  __libc_malloc
  15205959  4.30% 22.34%   15205959  4.30%  [libc-2.27.so]
  12974307  3.67% 26.01%   14070189  3.98%  _int_malloc
  10958857  3.10% 29.11%   10958857  3.10%  Sass::SharedPtr::incRefCount
   9837672  2.78% 31.89%   18433250  5.21%  cfree
```
