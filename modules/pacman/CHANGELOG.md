##2014-05-25 - Release 0.9.3

- pacman::aur add 15 minutes timeout as some aur packages take long time to
  build.
- mintor fixes
- added basic travis-ci configuration (WIP)

##2014-05-22 - Release 0.9.0
###Summary

This is first public release. This release is feature complete and is compatible
with most pacman configurations. The focus from 0.9.0 to 1.0.0 is on
optimization and bugfixing.

####Features

- pacman.conf configuration support
- pacman.conf repostitoru support
- mirrorlist management / auto-update (ipv4 / ipv6, http / https-only)
- rankmirrors support
- AUR support (via yaourt)
