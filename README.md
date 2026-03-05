@thunder-coding's personal tree optimized for weird shit

Things to expect:
- A lot of weird optimizations that may not be worth it to others
- A tree with broken builds unless you know how to use it

Things not to expect:
- Documentation of any sort. The code is the documentation. Good luck with that. Since I expect no one else to use this, I don't care about making it readable. If you want to use it, you'll have to figure it out yourself.
- Any sort of support. If you have questions, you can try your luck asking me, but I don't owe you an answer.
- Although the below documentation exists, don't expect it to be up to date in any way whatsoever
- Linear git history. This branch will be rebased against master, whenever I please. If you wanna deal with your copy, good luck, know some Git-Fu, and be prepared to deal with merge conflicts. I don't care about your copy, so I won't care about merge conflicts.


## Current features

### Full in-memory builds

Every build happens in memory (including the source files).
This is currently achieved through using tmpfs. Just swapover your `./scripts/run-doker.sh` with `./scripts/personal/run-docker.sh`

Care has been taken to ensure that this is reproducible with the plain `./scripts/run-doker.sh`.

You can also go ahead and even setup Docker such that your images and containers are in tmpfs. But that'd require a lot of memory on your system. You can find how to do that here: https://thunders.website/posts/2026-01-10-docker-on-tmpfs/


### Local apt repository

Should use local apt repository for faster builds. Just make sure that your local copy of the entire apt repository is available in `~/termux-apt-repo`. Reduces build times by a lot depending on your network speed since this is essentially zero latency
