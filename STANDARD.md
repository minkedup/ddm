# The Standard 

## Introduction

The core unit that `ddm` works with is called a **configuration pack**,
abbreviated `conf-pack`. In short, configuration packs contains metadata for how
to install configuration files, coupled with configuration files themselves.
Each configuration pack should target one application, but the standard is
flexible enough to accommodate non-standard use cases.

Configuration packs reside within **pack directories**. The next section
explains how configuration packs should be laid out within a pack directory,
with the following section describing how configuration packs should be setup. 

## The Pack Directory 

`ddm` always works within a pack directory when processing configuration packs.
Each application should have a configuration pack named after it in the pack
directory by convention.

When `ddm` is first run, it treats the directory it is run in as a pack
directory, iterating through every directory and processing it as a
configuration pack. 

### .ddmignore file

To allow users to have directories that are not treated as configuration packs
in their pack directory, `ddm` supports ignoring files based on pattern
matching. Users familiar with the `.gitignore` file syntax should find
`.ddmignore` files familiar but more restrictive.

Each pack directory may optionally contain a `.ddmignore` file. `.ddmignore`
files should consist of a newline separated list of patterns to exclude when
looking for configuration packs. Each pattern will be matched against every
directory that `ddm` encounters: if the pattern matches starting from the
beginning of the directory name, `ddm` will skip that directory.

Behind the scenes, `ddm` inserts a `^` before each file that it checks against,
then uses `grep -E` to perform a regex using the pattern. Thus, savvy users may
wish to use more advanced regex patterns when writing a `.ddmignore` file.

**Example**

For example, we'll consider a pack directory in which a user has created a
configuration pack named `bin` which they would like to be excluded from `ddm`.

```
dotfiles
├── .ddmignore
├── bar
├── bin
└── foo
```

```sh
# an example exclude statement
$ cat .ddmignore

bin/
```

Please note that `.ddmignore` files don't support spaces.

## Configuration Packs

### Configuration Files

Each configuration pack must include a sub directory named `conf` that contains
the configuration files that are going to be installed for that configuration
pack. More information about how `ddm` installs these configuration files can be
found under the [install properties](#install-properties) section.

### Install Checking 

Each configuration pack may include an `isnt.sh` script. This script will return
`0` to signal that the configuration files should be installed; otherwise, the
script will return any non-zero return code to indicate that the configuration
files should not be installed. This script will be called by `ddm` when it
evaluates a configuration for installation. 

In the event that a configuration pack does not include an `inst.sh` script, the
configuration files will be installed dependent on whether or not the command
exists. The command name to check against is derived from the name of the
configuration pack directory.
 
**NOTE - the** `inst.sh` **script must be executable!**

### Install Properties

Each configuration pack may include a `meta` file; this file will contain a
variety of key-value pairs used by `ddm` to setup installation properties. A
reference is included at the end of this section with each key and its default
value, as well as a short description of how that variable effects `ddm`'s
behavior.

The `meta` file can be treated like a normal `sh` script, and should have access
to any environment variable that an `sh` script would normally have access to.
In addition to normal environment variables, the `meta` file will also be passed
custom variables from `ddm`. A reference listing of what the value of these
variables mean can also be found at the end of this section.

**NOTE - the** `meta` **script must be executable!**

#### Properties
```
install_dir
    description: the directory to install the conf files to
    default: $HOME/.config/<application_name>
install_method
    desription: selects the method of installation
    default: symlink
    variants: symlink || copy
```

#### Variables

**⛔Coming Soon ⛔**

### Submodules

Each configuration pack may include a directory named `sub`; If this directory
is present, after the containing configuration pack has finished its
installation, `ddm` will treat the `sub` directory as its own pack directory.

Submodules are not processed with any special considerations: a 'parent'
configuration pack being installed does not guarantee that a 'child'
configuration pack is installed. Each 'child' configuration pack inside will
still need to define if it is going to be installed (i.e. with an `inst.sh`
file). For more information about installation checking, check out the
[installation checking section](#install-checking).

Submodules, other than offering a logical grouping of configuration packs,
guarantee installation ordering. Child configuration packs are guaranteed to be
installed after their parent configuration pack is installed. However, the
ordering of the installation of the submodules is not guaranteed.

### Example Configuration Pack

Listed below is an example of a configuration for an application named `meow`
that has decided to forgo the default installation properties in favor of a
custom `meta` and `inst.sh` file.

```
meow
├── conf
│  └── meow.conf
├── inst.sh
└── meta
```

```sh
$ cat inst.sh

if [ "$USER" = "coolguy" ]; then
    return 0
else
    return 1
fi
```

The meow configurations will only be installed if the user that runs `ddm` has
the username `coolguy`.

```sh
$ cat meta

root_dir="$HOME/.meow"
```

Instead of being installed in the default location (`$HOME/.config/meow`), the
meow application's configuration files will instead be installed in the home
directory under the name "`.meow`". Assuming that the current user is named
`coolguy`, the full path expansion would be `/home/coolguy/.meow`.
