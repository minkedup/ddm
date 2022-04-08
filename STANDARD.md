# The Standard 

## Introduction

This core unit that `ddm` works with is called a configuration pack, abbreviated
as `conf-pack` for short. A configuration pack contains metadata for how to
install configuration files, coupled with configuration files. Each
configuration pack should target one application, but the standard is flexible
enough to accommodate non-standard configurations.

The following sections describe how a configuration pack's directory should be
laid out, as well as how `ddm` will process this layout.

## The Pack Directory 

`ddm` works within a pack directory when processing installations. Each
application should have a configuration pack named after it in the pack
directory by convention.

When `ddm` is first run, it treats the current directory as a pack directory,
iterating through every directory in the current directory and processing it as
a configuration pack. Users may have folders that they wish to exclude from
being processed as a configuration pack. `ddm` supports the ignoring folders
with a `.ddmignore` file.

### .ddmignore file

To allow users to have directories that are not configuration packs in their
pack directory, `ddm` supports ignoring files based on pattern matching. Users
familiar with basic `.gitignore` file syntax should find `.ddmignore` files
familiar.

`.ddmignore` files should consist of a newline separated list of patterns to
exclude when looking for configuration packs. Each pattern will be matched
against every directory that `ddm` encounters: if the pattern matches starting
from the beginning of the directory name, `ddm` will skip that directory.

Behind the scenes, `ddm` inserts a `^` before each file name to check, then uses
`grep -E` to perform a regex using the pattern. Thus, savvy users may wish to use
more advanced regex patterns when writing a `.ddmignore` file.

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
the configuration files for the application that the configuration package is
targeting. More information about how `ddm` installs these configuration files
can be found under the [installation properties](#installation-properties)
section.

### Install Checking 

Each configuration pack may include an `isnt.sh` script. This script will
return true (0) to signal that the configuration files should be installed;
otherwise, the script will return any non-zero return code to indicate that the
configuration files should not be installed. This script will be called by `ddm`
when it evaluates a configuration for installation. 

In the event that an configuration pack does not include an `inst.sh` script,
the configuration files will be installed dependent on whether or not the
application exists using the standard `command -v $(application_name)` (the
`$application_name` being derived from the name of the directory of the
configuration pack).

**NOTE - the** `inst.sh` **script must be executable!**

### Install Properties

Each configuration pack may include a `meta` file; this file will contain a
variety of key-value pairs used by `ddm` to setup installation properties. A
reference is included at the end of this section with each key and its default
value, as well as a short description of how that variable effects `ddm`'s
install behavior. 

The `meta` file can be treated like a normal `sh` script, and should have access
to any environment variable that an `sh` script would normally have access to.
In addition to the normal environment variables, the `meta` file will also be
passed custom variables from `ddm`. A reference listing of what the value of
these variables mean can also be found at the end of this section.

**NOTE - the** `meta` **script must be executable!**

#### Installation Properties
```
install_dir
    description: the directory to install the conf files to
    default: $HOME/.config/<application_name>
    value: string
```

#### Installation Variables

**⛔Coming Soon ⛔**

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
