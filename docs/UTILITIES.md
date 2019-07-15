# Additional Utilities List

The following utility scripts are available:

- [build-all.sh](../build-all.sh):
  used for building all packages in the correct order (using buildorder.py).

- [clean.sh](../clean.sh):
  used for cleaning build environment.

- [scripts/check-built-packages.py](../scripts/check-built-packages.py):
  used for comparing git (local) and apt (remote) package versions.

- [scripts/check-pie.sh](../scripts/check-pie.sh):
  used for verifying that all binaries are using PIE, which is required for
  Android 5+.

- [scripts/check-versions.sh](../scripts/check-versions.sh):
  used for checking for package updates.

- [scripts/list-packages.sh](../scripts/list-packages.sh):
  used for listing all packages with a one-line summary.

- [scripts/package_uploader.sh](../scripts/package_uploader.sh):
  used for uploading packages to Bintray.
