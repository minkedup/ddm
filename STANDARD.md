# The Standard 

## Introduction

The standard heavily relies on the user's familiarity with text files and text
editing. To summarize the standard, metadata files are placed in a directory
with the target application's name; these metadata files contain settings that
pertaining to installation, and are evaluated as shell scripts to allow
flexibility in configuration.

## Directory Layout

Each application should have a directory named after it in the top level
directory of the user's dotfiles. This convention can be ignored, and should
only be followed in the case that you would like `ddm` to automatically
determine whether or not the configuration files are ready for installation.

### .ddmignore file

To allow users to have directories that are not dedicated to configuration files
in their dotfiles directory, `ddm` supports ignoring files based on pattern
matching. Users familiar with basic `.gitignore` file syntax should find
`.ddmignore` files familiar.

`.ddmignore` files should consist of a line-separated list of patterns to
exclude when looking for application configurations. Each pattern will be
matched against every directory that `ddm` encounters: if the pattern matches
starting from the beginning of the directory name, `ddm` will skip that
directory.

Behind the scenes, `ddm` inserts a `^` before each file name to check, then uses
`grep -E` to perform a regex using the pattern. Thus, savvy users may wish to use
more advanced regex patterns when writing a `.ddmignore` file. 

For example, we'll consider a directory of application configurations where the
user has created a directory named `bin` which they would like to be excluded
from `ddm`.

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

Please note that like all other facets of `ddm`, the `.ddmignore` parsing
doesn't support spaces because it uses a space separated string in the
background when doing comparisons. 

## Install Go-Ahead 

Each application may include an `isnt.sh` script. This script will return 0 to
signal that the application's configuration files should be installed;
otherwise, the script will return any non-zero return code (i.e. a failure
code). This script will be called by `ddm` when it evaluates a configuration for
installation. 

In the event that an application does not include an `inst.sh` script, the
application will be installed dependent on whether or not the application exists
using the standard `command -v $(application_name)`.

## Install Configuration

Each application may include a `meta` file; this file will contain a variety of
key-value pairs used by `ddm` to evaluate installation properties. A reference
is included at the end of this section with each key and its default value, as
well as a short description of how that variable will change `ddm`'s behavior. 

The `meta` file can be treated like a normal `sh` script, and should have access
to any environment variable that an `sh` script would normally have access to.
In addition to these environment variables, the `meta` file will also be passed
custom variables from `ddm`. A reference listing of what the value of these
variables mean can also be found at the end of this section.

**NOTE - the** `meta` **script must be executable!**

### Installation Properties
```
install_dir
    description: the directory to install the conf files to
    default: $HOME/.config/<application_name>
```

### Installation Variables

**⛔Coming Soon ⛔**

## Example Configurations 

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
