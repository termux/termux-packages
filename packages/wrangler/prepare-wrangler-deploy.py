#!/usr/bin/env python3
"""Assemble a self-contained Wrangler package for native Termux."""
from __future__ import annotations

import argparse
import json
import os
import re
import shutil
from pathlib import Path

WORKERD_ANCHOR = "function generateBinPath() {\n  const { pkg, subpath } = pkgAndSubpathForCurrentPlatform();"
WORKERD_ANDROID = """function generateBinPath() {
  // Upstream workerd does not register Android in its npm
  // platform table. The package launcher points this at the exact Android
  // workerd binary built from source alongside Wrangler.
  if (process.platform === "android" && process.env.WORKERD_BINARY_PATH) {
    return { binPath: process.env.WORKERD_BINARY_PATH };
  }
  const { pkg, subpath } = pkgAndSubpathForCurrentPlatform();"""


def executable_copy(source: Path, destination: Path) -> None:
    source = source.resolve(strict=True)
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, destination)
    destination.chmod(0o755)


def normalize_wrangler_self_link(root: Path) -> None:
    link = root / "node_modules" / ".pnpm" / "node_modules" / "wrangler"
    if not link.is_symlink():
        return
    target = link.resolve(strict=True)
    if target == root.resolve():
        return
    package_json = target / "package.json"
    try:
        package = json.loads(package_json.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise RuntimeError(f"Unexpected external Wrangler self-link target: {target}") from exc
    if package.get("name") != "wrangler":
        raise RuntimeError(f"Unexpected external Wrangler self-link target: {target}")
    link.unlink()
    # From node_modules/.pnpm/node_modules back to the deployment root.
    os.symlink("../../..", link, target_is_directory=True)


TERMUX_RUNTIME_PREFIX = Path("@TERMUX_PREFIX@")
TERMUX_WRANGLER_HOME = TERMUX_RUNTIME_PREFIX / "lib" / "wrangler"
FORBIDDEN_NATIVE_PACKAGE_PREFIXES = (
    # The unscoped JS wrappers are portable; these scoped packages are the
    # npm-distributed platform payloads that this project replaces from source.
    "@cloudflare/workerd-",
    "@esbuild/",
    "@img/sharp-",
)


def deployment_root_variants(root: Path) -> set[str]:
    resolved = str(root.resolve())
    variants = {resolved, resolved.replace("\\", "/")}
    match = re.match(r"^/mnt/([A-Za-z])/(.*)$", resolved)
    if match:
        drive, rest = match.groups()
        windows = drive.upper() + ":\\" + rest.replace("/", "\\")
        variants.update({windows, windows.replace("\\", "/")})
    return {value for value in variants if value}


def normalize_pnpm_bin_shims(root: Path) -> None:
    """Remove Windows shims and rewrite pnpm's absolute deploy-root NODE_PATHs."""
    replacements = deployment_root_variants(root)
    destination = str(TERMUX_WRANGLER_HOME)
    for bin_dir in root.rglob(".bin"):
        if not bin_dir.is_dir():
            continue
        for shim in bin_dir.iterdir():
            if shim.is_symlink() or not shim.is_file():
                continue
            if shim.suffix.lower() in {".cmd", ".ps1"}:
                shim.unlink()
                continue
            try:
                text = shim.read_text(encoding="utf-8")
            except UnicodeDecodeError:
                continue
            updated = text
            for source in sorted(replacements, key=len, reverse=True):
                updated = updated.replace(source, destination)
            if any(source in updated for source in replacements):
                raise RuntimeError(f"pnpm shim still contains its staging deployment path: {shim}")
            if updated != text:
                shim.write_text(updated, encoding="utf-8", newline="\n")


def normalize_termux_shebangs(root: Path) -> None:
    """Rewrite conventional Linux shebangs to paths that exist in Termux."""
    replacements = {
        b"#!/bin/sh": b"#!@TERMUX_PREFIX@/bin/sh",
        b"#!/usr/bin/env sh": b"#!@TERMUX_PREFIX@/bin/sh",
        b"#!/usr/bin/env node": b"#!@TERMUX_PREFIX@/bin/node",
        b"#! /usr/bin/env node": b"#!@TERMUX_PREFIX@/bin/node",
        b"#!/usr/bin/env bash": b"#!@TERMUX_PREFIX@/bin/bash",
    }
    for path in root.rglob("*"):
        if path.is_symlink() or not path.is_file():
            continue
        try:
            data = path.read_bytes()
        except OSError:
            continue
        newline = data.find(b"\n")
        if newline < 0:
            continue
        first_line = data[:newline].rstrip(b"\r")
        replacement = replacements.get(first_line)
        if replacement is not None:
            path.write_bytes(replacement + b"\n" + data[newline + 1 :])


def remove_foreign_native_payloads(root: Path) -> None:
    """Drop foreign PE/Mach-O helpers and reject accidental host ELF payloads."""
    macho_magics = {
        b"\xfe\xed\xfa\xce",
        b"\xce\xfa\xed\xfe",
        b"\xfe\xed\xfa\xcf",
        b"\xcf\xfa\xed\xfe",
        b"\xca\xfe\xba\xbe",
        b"\xbe\xba\xfe\xca",
    }
    for path in root.rglob("*"):
        if path.is_symlink() or not path.is_file():
            continue
        try:
            with path.open("rb") as handle:
                magic = handle.read(4)
        except OSError:
            continue
        if magic.startswith(b"MZ") or magic in macho_magics:
            print(f"Removing foreign native payload: {path.relative_to(root)}")
            path.unlink()
            continue
        if magic.startswith(b"\x7fELF"):
            raise RuntimeError(f"Deployment contains an unexpected host ELF binary: {path}")


def reject_platform_native_packages(root: Path) -> None:
    """Reject npm-distributed native payload packages; native bits are source-built here."""
    for path in root.rglob("package.json"):
        try:
            name = json.loads(path.read_text(encoding="utf-8")).get("name", "")
        except (json.JSONDecodeError, UnicodeDecodeError):
            continue
        if any(name.startswith(prefix) for prefix in FORBIDDEN_NATIVE_PACKAGE_PREFIXES):
            raise RuntimeError(f"Platform-native dependency leaked into Wrangler deployment: {name}")


def verify_self_contained(root: Path) -> None:
    resolved_root = root.resolve()
    for path in root.rglob("*"):
        if not path.is_symlink():
            continue
        try:
            target = path.resolve(strict=True)
            target.relative_to(resolved_root)
        except (FileNotFoundError, ValueError) as exc:
            raise RuntimeError(f"Deployment contains an external or broken symlink: {path}") from exc

        # pnpm uses relative symlinks on Linux, but a deployment produced on
        # Windows may expose equivalent directory junctions as absolute links
        # through WSL. They are self-contained before relocation but would point
        # back to the original staging tree after copytree(..., symlinks=True).
        # Canonicalize every validated internal link to a relative target first.
        relative_target = os.path.relpath(target, start=path.parent)
        raw_target = os.readlink(path)
        if raw_target != relative_target:
            target_is_directory = target.is_dir()
            path.unlink()
            os.symlink(relative_target, path, target_is_directory=target_is_directory)

def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--deploy", required=True, type=Path)
    parser.add_argument("--prefix", required=True, type=Path)
    parser.add_argument("--workerd-binary", required=True, type=Path)
    parser.add_argument("--esbuild-binary", required=True, type=Path)
    parser.add_argument("--wrangler-version", required=True)
    args = parser.parse_args()

    deploy = args.deploy.resolve(strict=True)
    normalize_wrangler_self_link(deploy)
    normalize_pnpm_bin_shims(deploy)
    normalize_termux_shebangs(deploy)
    remove_foreign_native_payloads(deploy)
    verify_self_contained(deploy)

    package = json.loads((deploy / "package.json").read_text(encoding="utf-8"))
    if package.get("name") != "wrangler" or package.get("version") != args.wrangler_version:
        raise RuntimeError(
            f"Unexpected deployment identity: {package.get('name')}@{package.get('version')}"
        )
    if not (deploy / "bin" / "wrangler.js").is_file():
        raise RuntimeError("Wrangler deployment is missing bin/wrangler.js")
    if not (deploy / "bin" / "cf-wrangler.js").is_file():
        raise RuntimeError("Wrangler deployment is missing bin/cf-wrangler.js")
    reject_platform_native_packages(deploy)

    prefix_path = args.prefix
    app = prefix_path / "lib" / "wrangler"
    if app.exists() or app.is_symlink():
        if app.is_symlink() or app.is_file():
            app.unlink()
        else:
            shutil.rmtree(app)
    app.parent.mkdir(parents=True, exist_ok=True)
    shutil.copytree(deploy, app, symlinks=True)

    workerd_main = (app / "node_modules" / "workerd" / "lib" / "main.js").resolve(strict=True)
    try:
        workerd_main.relative_to(app.resolve())
    except ValueError as exc:
        raise RuntimeError("workerd runtime resolved outside Wrangler deployment") from exc
    workerd_text = workerd_main.read_text(encoding="utf-8")
    if WORKERD_ANCHOR not in workerd_text:
        raise RuntimeError("Unexpected workerd runtime layout; Android patch anchor missing")
    workerd_main.write_text(
        workerd_text.replace(WORKERD_ANCHOR, WORKERD_ANDROID, 1),
        encoding="utf-8",
        newline="\n",
    )

    native = app / "native"
    executable_copy(args.workerd_binary, native / "workerd")
    executable_copy(args.esbuild_binary, native / "esbuild")

    bin_dir = prefix_path / "bin"
    bin_dir.mkdir(parents=True, exist_ok=True)

    def write_launcher(name: str, entrypoint: str) -> None:
        if not (app / "bin" / entrypoint).is_file():
            raise RuntimeError(f"Wrangler entrypoint missing: {entrypoint}")
        launcher = bin_dir / name
        lines = [
            "#!@TERMUX_PREFIX@/bin/sh",
            "set -eu",
            "PREFIX=${PREFIX:-@TERMUX_PREFIX@}",
            'export WRANGLER_HOME="$PREFIX/lib/wrangler"',
            'export WORKERD_BINARY_PATH="$WRANGLER_HOME/native/workerd"',
            'export MINIFLARE_WORKERD_PATH="$WORKERD_BINARY_PATH"',
            'export ESBUILD_BINARY_PATH="$WRANGLER_HOME/native/esbuild"',
            f'exec "$PREFIX/bin/node" "$WRANGLER_HOME/bin/{entrypoint}" "$@"',
            "",
        ]
        launcher.write_text("\n".join(lines), encoding="utf-8", newline="\n")
        launcher.chmod(0o755)

    write_launcher("wrangler", "wrangler.js")
    wrangler2 = bin_dir / "wrangler2"
    if wrangler2.exists() or wrangler2.is_symlink():
        wrangler2.unlink()
    os.symlink("wrangler", wrangler2)
    write_launcher("cf-wrangler", "cf-wrangler.js")

    print(f"Installed Wrangler {args.wrangler_version} into {app}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
