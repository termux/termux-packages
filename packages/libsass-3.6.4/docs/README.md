## LibSass documentation

LibSass is just a library. To run the code locally (i.e. to compile your
stylesheets), you need an implementer. SassC is an implementer written in C.
There are a number of other implementations of LibSass - for example NodeJS.
We encourage you to write your own port - the whole point of LibSass is that
we want to bring Sass to many other languages!

## LibSass road-map

Since ruby-sass was retired in 2019 in favor of dart-sass, we slowly move
toward full compatibility with the latest Sass specifications, although
features like the module `@use` system may take a bit longer to add.

### Implementing LibSass

If you're interested in implementing LibSass in your own project see the
[API Documentation](api-doc.md) which now includes implementing your own
[Sass functions](api-function.md). You may wish to [look at other
implementations](implementations.md) for your language of choice.

### Contributing to LibSass

|   Issue Tracker   |            Issue Triage          |     Community Guidelines    |
|-------------------|----------------------------------|-----------------------------|
| We're always needing help, so check out our issue tracker, help some people out, and read our article on [Contributing](contributing.md)! It's got all the details on what to do! | To help understand the process of triaging bugs, have a look at our [Issue-Triage](triage.md) document. | Oh, and don't forget we always follow [Sass Community Guidelines](https://sass-lang.com/community-guidelines). Be nice and everyone else will be nice too! |

### Building LibSass

Please refer to the steps on [Building LibSass](build.md)

### Developing LibSass

Please refer to [Developing LibSass](developing.md)
