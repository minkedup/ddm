# ddm - dumb dotfile manager 

Another dotfile manager created by someone with too much free time.

## Description

`ddm` takes configuration files and symlinks them into the correct user
specified place. Additional information about how ddm handles installations can
be found in [STANDARD.md](./STANDARD.md) file.

## Getting Started

### Dependencies 

The only dependency `ddm` requires is a POSIX compliant shell.

### Installing

The simplest was to install `ddm` is to copy the shell script into your dotfiles
directory.

```sh
# clone the repository
$ git clone https://github.com/displeased/ddm

# copy the binary file to your dotfiles directory
$ cp ddm/ddm existing/dotfile/repo 
```

### Using

`ddm` has two subcommands: install and uninstall.

```sh
# installs the dotfiles
ddm install

# uninstalls the dotfiles
ddm uninstall
```

For more information about how `ddm` handles installs, please refer to
[STANDARD.md](STANDARD.md).

## Developing

While `ddm` only relies on a POSIX shell during runtime, development and testing
require more dependencies.

- `bash`
- [bats](https://github.com/bats-core/bats-core)

Tests can be run by executing bats in the root level ddm repository: 

```sh
# run test suite 
$ bats test
```

For more information about how `bats` works, checkout out the [bats
documentation](https://bats-core.readthedocs.io/).

## Contributions

When contributing to this repository, please first discuss the change you wish
to make via a GitHub issue.

### Pull Request Process

1. Running the unit tests results in all tests being passed
2. Update the STANDARD with any changes to the standard
3. Create a pull request with your change and link it with the issue that you're
   working on
4. Once your pull request has been reviewed by the owner of this repository, it
   will be merged.

## License

This project is licensed under the GPL-3.0 License - see [LICENSE](./LICENSE) for
more details.
