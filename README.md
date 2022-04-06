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

To install `ddm` you can create a submodule in your current dotfile repository
and symlink the `ddm` executable into place.

```sh
cd existing/dotfile/repo 
git submodule add https://github.com/displeased/ddm .ddm
ln -sr .ddm/ddm ddm
git add .gitmodules ddm .ddm/
git commit -m "added ddm to my repo :)"
```

This series of commands:
- Creates a new submodule for `ddm` under `.ddm/`
- Links the executable for `ddm` to the git repositories tld
- Commits the changes to git

Alternatively, if you don't want to use gitmodules feel free to simply copy the
`ddm` binary from this git repo and commit it to your dotfile repo.

```sh
git clone https://github.com/displeased/ddm
cp ddm/ddm existing/dotfile/repo 
cd existing/dotfile/repo
git add ddm
git commit -m "Added ddm to my repo :)"
```

### Executing Program

`ddm` has two subcommands: install and uninstall.

```sh
# installs the dotfiles
ddm install

# uninstalls the dotfiles
ddm uninstall
```

For more information about how `ddm` handles installs, please refer to
[STANDARD.md](STANDARD.md); or, check out `ddm`'s help message with:

```sh
ddm --help
```

## Authors

@displeased

## License

This project is licensed under the GPL-3.0 License - see LICENSE for details

## Contributions

When contributing to this repository, please first discuss the change you wish
to make via issue. 

### Pull Request Process

1. Ensure that running `shellcheck` on the program results in no errors and an
   insignificant amount of warnings.
2. Update the README.md with any changed to the interfaces with `inst.sh` and
   `meta` files
3. Once your pull request has been reviewed by the owner of this repository, it
   will be merged.
