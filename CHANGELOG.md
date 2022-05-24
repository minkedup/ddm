# Changelog
All notable changes to this project will be documented in this file. See [conventional commits](https://www.conventionalcommits.org/) for commit guidelines.

- - -
## 0.6.0 - 2022-05-24
#### Documentation
- revised STANDARD documentation for submodules - (3f6fc9a) - Mickey Polito
#### Features
- added user script search and execution - (ea1c4e5) - Mickey Polito
#### Miscellaneous Chores
- bumped version in binary - (27db4c9) - Mickey Polito
#### Refactoring
- changed submodule processing to switch - (a0d9036) - Mickey Polito

- - -

## 0.5.0 - 2022-05-23
#### Documentation
- updated docs and utility to match functionality - (f3dcc92) - Mickey Polito
#### Features
- added configuration pack tree listing - (7b30684) - Mickey Polito
#### Miscellaneous Chores
- updated version in ddm binary - (f135bb4) - Mickey Polito
#### Refactoring
- started work on tree feature - (df1409b) - Mickey Polito
- changed LS to be more generalized for feat - (e6c40ae) - Mickey Polito

- - -

## 0.4.3 - 2022-05-17
#### Bug Fixes
- changed usage of rmdir to be posix compliant - (c230d62) - Mickey Polito
- added posix compatibility to cp command usage - (e4c0c7a) - Mickey Polito
- fixed path pre-check regression - (492e9a8) - Mickey Polito
#### Documentation
- corrected comments in overwrite checking - (bacc543) - Mickey Polito
#### Miscellaneous Chores
- removed empty changelog release information - (f6c1421) - Mickey Polito
- bumped version information in binary - (ddec59f) - Mickey Polito
#### Tests
- updated tests for changes in functions - (169716f) - Mickey Polito

- - -

## 0.4.2 - 2022-05-14
#### Bug Fixes
- attempted to simplify adopt functionality - (2a42111) - Mickey Polito
- updated uninstall subcommand with new functions - (7c35823) - Mickey Polito
- removed path construction from logged fns - (ef4c69b) - Mickey Polito
- added additional docs to is_ignored - (78f4daa) - Mickey Polito
- fixed ambiguity in install go ahead function - (c7d58b0) - Mickey Polito
- added error handling for file_to_array - (131e4c3) - Mickey Polito
- added better error handling to directory creation - (76443a9) - Mickey Polito
- fixed error handling for copy function - (675e51b) - Mickey Polito
- added shellcheck ignore directive for desired behavior - (d837cf2) - Mickey Polito
- fixed log_node to have meaningful return - (c5be1a9) - Mickey Polito
- updated file logging to account for symlinks - (d3afa11) - Mickey Polito
- fixed regression introduced by in_array optimization - (cb5bec7) - Mickey Polito
- simplified globbing function name - (ce8a38a) - Mickey Polito
- optimized file globbing by removing for loop - (d6bcf53) - Mickey Polito
#### Documentation
- improved inline docs on adopt function - (821c4b2) - Mickey Polito
- adjusted spacing in docstring for submodules - (4aa680b) - Mickey Polito
- fixed documentation on file resolution function - (4a20804) - Mickey Polito
- corrected the docstring of glob function - (2521da3) - Mickey Polito
#### Refactoring
- refactored string and output functions - (59b00de) - Mickey Polito

- - -

## 0.3.2 - 2022-04-14
#### Bug Fixes
- fixed bug introduced by globbing change - (beb31aa) - Mickey Polito
- streamlined application globbing with util func - (950cd8b) - Mickey Polito
#### Refactoring
- moved conf file checking into validity check - (413380b) - Mickey Polito

- - -

## 0.3.0 - 2022-04-12
#### Bug Fixes
- added ignore flags on variables - (1cbfe62) - Mickey Polito
#### Documentation
- added testing instructions to README - (a17aac1) - Mickey Polito
#### Features
- added test for shellcheck passing - (196d5b0) - Mickey Polito
- - -

## 0.1.0 - 2022-04-11
#### Bug Fixes
- renamed CREATED_LINKS_* to CREATED_FILES_* - (75c90f9) - Mickey Polito
- bug in recursive counting logic - (d4edff6) - Mickey Polito
- fixed passing parent arguments to child processes - (098f34d) - Mickey Polito
- fixed bug with relative correction algorithm - (4782ba7) - Mickey Polito
- changed ignore behavior to info not warn - (a8aa848) - Mickey Polito
- changed shebang for portability - (0d6007f) - Mickey Polito
- fix potential bug in empty directory deletion - (9066bed) - Mickey Polito
- started work on more accurate conflict detection - (d38810d) - Mickey Polito
- fixed bug with relative symlinking - (4599bb2) - Mickey Polito
- continued modularization and docstring cleanup - (191db60) - Mickey Polito
- improved modularization of code and docstrings - (333bb47) - Mickey Polito
- corrected issue with configuration file finding - (e9f1a7d) - Mickey Polito
- file-globbing issue identification - (639f51b) - Mickey Polito
- removed generate subcommand - (7516d96) - Mickey Polito
- removed a non-applicable cli options - (6472b65) - Mickey Polito
#### Documentation
- added new installation property to docs - (e7aee7e) - Mickey Polito
- added submodule documentation to STANDARD - (f19e114) - Mickey Polito
- corrected language in STANDARD - (f6a51cf) - Mickey Polito
- added new section in STANDARD for conf files - (6cc0a05) - Mickey Polito
- revised STANDARD wording and phrasing - (0fa6839) - Mickey Polito
- updated documentation for ddmignore - (69882f0) - Mickey Polito
- changed the docstring of uninstall - (e5d4902) - Mickey Polito
- radically revamped docstrings - (c84a372) - Mickey Polito
- moved standard into separate file - (877bb1d) - Mickey Polito
- revised language in README (again) - (10c389e) - Mickey Polito
- removed backstory from README - (4e89e23) - Mickey Polito
- simplified language in README - (9020d70) - Mickey Polito
- improved and unified function documentation - (f14421b) - Mickey Polito
- reworded README to focus scope - (667dafa) - Mickey Polito
#### Features
- implemented alternative installation methods - (26b31d6) - Mickey Polito
- introduced cp equivalent of symlink function - (fee65ca) - Mickey Polito
- added string lowercase helper function - (5cec6cf) - Mickey Polito
- added implementation of submodules - (cdcb22f) - Mickey Polito
- added helper function for string repetition - (1281739) - Mickey Polito
- added abstraction over cache logging - (14d445d) - Mickey Polito
- completed ddmignore feature - (da03cd7) - Mickey Polito
- added ignore file loading into memory - (7e8b2d1) - Mickey Polito
- completed installation redundancy checking - (e3d54c4) - Mickey Polito
- added array helper functions - (97ddae4) - Mickey Polito
- added non-dotfile processing - (0cd590b) - Mickey Polito
- added proto-output messages - (6db8671) - Mickey Polito
#### Miscellaneous Chores
- added gitignore for swap files - (bbd0d72) - Mickey Polito
- - -

Changelog generated by [cocogitto](https://github.com/cocogitto/cocogitto).
