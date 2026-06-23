# ACP — Add Commit Push

A minimal CLI tool for the most common Git workflow: `acp "message"` replaces `git add . && git commit -m "message" && git push`.

## Features

- **Pure C**, single file dependency (Git)
- **Instant** — compiles in <1 second, runs in milliseconds
- **Safe** — validates input, warns about secrets, protects critical branches
- **Full-featured** — tag management, show mode, security scanning

## Usage

```bash
acp "fix login bug"              # add, commit, push all in one
acp -s "update readme"           # preview git commands first
acp --tag "v1.0.0"               # create tag locally
acp --tag-push "v1.0.0"          # push tag to remote
acp --check                      # scan for .env, API keys, large files
acp --remote "https://github..." # save custom remote for this repo
```

## Requirements

- Git (for actual git operations)
- POSIX libc (Bionic in Termux)

## Note

This tool is especially useful on Termux on Android where typing long
commands on a phone keyboard is tedious.
The single-command workflow cuts repetition significantly.
