#!/bin/bash
node --max-old-space-size=16192 /home/builder/.nvm/versions/node/v20.20.0/bin/gemini "$@"
