## Example for `data_context`

```C:data.c
#include <stdio.h>
#include "sass/context.h"

int main( int argc, const char* argv[] )
{

  // LibSass will take control of data you pass in
  // Therefore we need to make a copy of static data
  char* text = sass_copy_c_string("a{b:c;}");
  // Normally you'll load data into a buffer from i.e. the disk.
  // Use `sass_alloc_memory` to get a buffer to pass to LibSass
  // then fill it with data you load from disk or somewhere else.

  // create the data context and get all related structs
  struct Sass_Data_Context* data_ctx = sass_make_data_context(text);
  struct Sass_Context* ctx = sass_data_context_get_context(data_ctx);
  struct Sass_Options* ctx_opt = sass_context_get_options(ctx);

  // configure some options ...
  sass_option_set_precision(ctx_opt, 10);

  // context is set up, call the compile step now
  int status = sass_compile_data_context(data_ctx);

  // print the result or the error to the stdout
  if (status == 0) puts(sass_context_get_output_string(ctx));
  else puts(sass_context_get_error_message(ctx));

  // release allocated memory
  sass_delete_data_context(data_ctx);

  // exit status
  return status;

}
```

### Compile data.c

```bash
gcc -c data.c -o data.o
gcc -o sample data.o -lsass
echo "foo { margin: 21px * 2; }" > foo.scss
./sample foo.scss => "foo { margin: 42px }"
```

## Example for `file_context`

```C:file.c
#include <stdio.h>
#include "sass/context.h"

int main( int argc, const char* argv[] )
{

  // get the input file from first argument or use default
  const char* input = argc > 1 ? argv[1] : "styles.scss";

  // create the file context and get all related structs
  struct Sass_File_Context* file_ctx = sass_make_file_context(input);
  struct Sass_Context* ctx = sass_file_context_get_context(file_ctx);
  struct Sass_Options* ctx_opt = sass_context_get_options(ctx);

  // configure some options ...
  sass_option_set_precision(ctx_opt, 10);

  // context is set up, call the compile step now
  int status = sass_compile_file_context(file_ctx);

  // print the result or the error to the stdout
  if (status == 0) puts(sass_context_get_output_string(ctx));
  else puts(sass_context_get_error_message(ctx));

  // release allocated memory
  sass_delete_file_context(file_ctx);

  // exit status
  return status;

}
```

### Compile file.c

```bash
gcc -c file.c -o file.o
gcc -o sample file.o -lsass
echo "foo { margin: 21px * 2; }" > foo.scss
./sample foo.scss => "foo { margin: 42px }"
```

