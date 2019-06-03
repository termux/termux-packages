---
name: Bug report
about: Create a report to help us improve

---

<!-- Important note: Refusing to provide needed information may result in issue closing. -->

**Problem description**
A clear and concise description of what the problem is. You may post screenshots in addition to description.

**Steps to reproduce**
Steps to reproduce the behavior. Please post all necessary commands that are needed to reproduce the issue.

**Expected behavior**
A clear and concise description of what you expected to happen.

**Additional information**
Post output of command `termux-info`.

Depending on problem, additional information may be requested:

1. Android warning/error log: `logcat -d "*:W"`.
2. Output of strace: `strace -fv -s 2048 -o strace.log {program name}`.
3. If program write it's own log files, you may need to attach them.
