# Security Policies and Procedures

The Termux team takes all security vulnerabilities seriously and we encourage external parties and users to report them. We are also a strong believer of security-through-transparency and we publicly disclose all vulnerabilities that our own team finds or are reported by others as per responsible disclosure timelines.

# Reporting a Bug or Security Vulnerability

The Termux team and community take all security vulnerabilities seriously. We will acknowledge the report, if valid, within 3 business days.

Security issues with one of termux's packages, or with termux's infrastructure, should be reported in termux/termux-packages, while security issues in the apps should be reported in [termux/termux-app](https://github.com/termux/termux-app).

## Reporting Security Bugs via GitHub Security Advisory (Preferred)

The preferred way to report security vulnerabilities is through [GitHub Security Advisories](https://github.com/advisories). This allows us to collaborate on a fix while maintaining confidentiality of the report.

To report a vulnerability ([see also the docs](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability)):

1. Visit the [Security tab](https://github.com/termux/termux-packages/security)
2. Click Report a vulnerability and follow the provided steps.

## Reporting via Email

Send an email, preferably gpg encrypted, to the maintainers that seem to be responsible for the affected component, as per git history. You can find our public gpg keys in the [termux-keyring package](https://github.com/termux/termux-packages/tree/master/packages/termux-keyring). Please include all relevant details directly in the email, and send to multiple maintainers. We will aim at getting back within 3 business days, and provide updates on the progress and may request additional details.

## Issues in packages and forks

If you have found a security issue in a package, for example openssh, and the issue can be reproduced in non-termux installations as well, then the issue should be reported to the upstream developers.

If you are using a fork of termux, then we would appreciate if you could first verify that issue is reproducible in the termux version we provide as well. This can also help verify that issue does not stem from config changes.

# Disclosure Policy

When the security team receives a security bug report, it will be assigned to a developer. This person will coordinate the fix and release process, involving the following steps:

* Confirm the problem and determine affected environments.
* Prepare fixes. The fixes will be pushed as soon as possible to the repositories.

Roughly 30 days after the fixes have been made available the issue will be disclosed on github and [https://termux.dev](https://termux.dev/en/posts/index.html).

# Comments on this Policy

If you have suggestions on how this process or document could be improved please submit a pull request!
