name: Package updates

on:
  schedule:
    - cron: "0 */6 * * *"
  workflow_dispatch:
    inputs:
      packages:
        description: "A space-seperated list of packages to update. Defaults to all packages"
        default: "@all"
        required: false

jobs:
  update-packages:
    if: github.repository == 'termux/termux-packages'
    runs-on: ubuntu-latest
    steps:
      - name: Clone repository
        uses: actions/checkout@v3
        with:
          fetch-depth: 0
          token: ${{ secrets.GH_API_KEY }}
      - name: Process package updates
        env:
          GITHUB_TOKEN: ${{ secrets.GH_API_KEY }}
          BUILD_PACKAGES: "true"
          GIT_COMMIT_PACKAGES: "true"
          GIT_PUSH_PACKAGES: "true"
        run: |
          git config --global user.name "Termux Github Actions"
          git config --global user.email "contact@termux.org"

          if [ "${{ github.event_name }}" == "workflow_dispatch" ]; then
            ./scripts/bin/update-packages ${{ github.event.inputs.packages }}
          else
            ./scripts/bin/update-packages "@all"
          fi
