# Dumb Dotfile Manager 

Yet another dotfile (`.file`) manager created by someone with too much free
time.

## Design Considerations

In the past I had used `stow` to manage my dotfiles and was fairly satisfied
with that program. It would handily symlink everything for me, and all I needed
to do was give it a folder with my configurations in it. But this option began
to butt-up against my needs all to quickly. While `stow` is certainly a capable
program, I ran into several issues when using it:

- File Conflicts
    - Handling existing conflicts was a nightmare (I had to write my own bash
      script to avoid them)
- Dependencies
    - `stow` can be built easily on nearly any machine, props to the developers.
      However, I often use machines where the only dependencies that I can rely
      on are `git` and `bash`/`sh`. I want to use a program that can work in the
      as many environments as possible.

So, why did I end up building my own system instead of using one of the already
existing systems? Well, I decided to make my own system for one primary reason:

- Familiarity
    - I am already familiar with using `bash` scripts to subvert the strange
      abnormalities of `stow`, so I thought that I would go ahead and write
      everything in POSIX `sh` to create a fully integrated system. 

## The Standard 

- Each application-specific configuration will have its own directory with the
  same name as the application for which the configurations exist.
- Each application may include an `isnt.sh` script; this script will return 0
  to signal that the application configuration files should be installed,
  otherwise the script will return anything else.
    - In the event that an application does not include an `inst.sh` script,
      the application will be installed dependent on whether or not the
      application exists (using the built-in `command`).
- Each application may include an `meta` file; this file will contain a variety
  of key-value pairs used by the dotfile manager to evaluate installation
  properties. Each key-value pair will take the format `key=value`, making sure
  that "string" values are quoted.
    - In the event that an application forgoes an `meta` file, the
      application will be installed under the default directory
      `$HOME/.config/$application_name`.
    - Each `meta` file is provided a set of variables listed below as
      reference when writing a `meta` file. Every passed-in variable is
      evaluated as-if they were a `bash`/`sh` variable. Consequentially, the
      `meta` file has access to all `bash`/`sh` variables (like `$HOME`,
      `$USER`, etc...).
    - Each key value pair is listed below with the format `key - value type` as
      reference when writing a `meta` file.
        - `install_dir - string`
            - The root directory to install the files in `conf` under.

### Example Application

Listed below is an example of a configuration for an application named `kitty`
that has decided to forgo the default evaluation of applications in favor of a
custom `meta` and `inst.sh` file.

```
kitty
├── conf
│  └── kitty.conf
├── inst.sh
└── meta
```

**inst.sh**
```sh
if [ $USER = "coolguy" ]; then
    return 0
else
    return 1
fi
```

*The kitty configurations will only be installed if the current user installing
is is* `coolguy`.

**meta**
```sh
root_dir="$HOME/.kitty"
```

*Instead of being installed in the default (*`$HOME/.config/kitty`*), the kitty
application configuration files will instead be installed in the home directory
under the name* "`.kitty`".
