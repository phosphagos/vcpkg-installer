# `vcpkg-installer`

This is a simple script for simplifying installation and configuration of [vcpkg](https://vcpkg.io/en/index.html).

This script is only written for and tested at Linux distributions. Windows is not supported.

To install vcpkg and utility scripts, be sure that curl, zip, unzip, tar, and git has been installed with your native package manager, then run `bash install.sh`.

Currently, except for `vcpkg`, `vcpkg-init` and `vcpkg-update` will be automatically installed as utility scripts. It will automatically update the installed vcpkg by running `vcpkg-update` script, and the `vcpkg-init` script will automatically copy the `vcpkg.json` config file to your current directory, which is an empty template config of initial vcpkg project. You can modify `vcpkg.json` before install (or `$VCPKG_ROOT/../etc/vcpkg.json` after install), to costomize the initial configuration.