# developer-onboarding

This repository tracks the tools and configuration commonly used across Set repositories.

## Quick Start
* [Install Homebrew](https://brew.sh)
* Relative to the root of this repository: `brew bundle`.
* Configure Docker for Mac [resources](https://docs.docker.com/docker-for-mac/#resources):
  * At least 4GB of Memory. 
  * All CPUs.
  * At least 64GB of disk.

## Notes

### macOS
This repository currently assumes developers are using macOS. All tools are cross-platform, so this assumption can evolve if necessitated. 

### Brewfile lock
As [documented](https://github.com/Homebrew/homebrew-bundle#note) `Brewfile.lock.json`, does not install specific versions of software, as that functionality is not supported by homebrew.
This lock file serves primarily as automatically-generated documentation of "last known working" versions.
