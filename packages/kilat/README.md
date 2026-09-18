# Termux Package Submission

## Cara Submit ke Termux Packages

1. Fork https://github.com/termux/termux-packages

2. Copy folder `packages/kilat/` ke fork kamu

3. Build package:
```bash
./build-package.sh -I kilat
```

4. Test install:
```bash
pkg install ./kilat_*.deb
```

5. Submit PR ke termux-packages

## File yang diperlukan

```
packages/kilat/
└── build.sh
```

## Persyaratan

- Go harus terinstall di Termux (`pkg install golang`)
- Binary harus static (CGO_ENABLED=0)
- License harus ada di repo
