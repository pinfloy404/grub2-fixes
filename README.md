# GRUB2 Fixes

![bash](https://img.shields.io/badge/Bash_Shell-Chartreuse?logo=gnubash&logoColor=white)
![grub](https://img.shields.io/badge/GRUB-2.12-mintcream)
![gpl](https://img.shields.io/badge/License-GPLv3-crimson)

A simple script in Bash to fix a few things for GRUB2.

## Overview

This script adds and changes some options to the GRUB2 configuration and rebuilds it automatically.

> [!WARNING]
> This script was tested for ***Fedora 43*** ***Fedora 44*** and  with ***GRUB 2.12***.

### Screen resolution

Sometimes GRUB2 don't detects automatically the screen resolution, so everytime the system gets wiped out, this options has to be added and changed into the GRUB2 file configuration.

This script adds and changes these parts.

| Option | Description |
| --- | --- |
| GRUB_TERMINAL_OUTPUT="gfxterm" | Changes the option from **console** to **gfxterm** |
| GRUB_GFXMODE=auto | Adds this option to detect automatically screen resolution |

### os-prober

If there are other OS in another hard drive, GRUB2 automatically detects it and adds it into the menu, but selecting them sometimes doesn't work, so this script adds the option to disable it, so makes the menu more cleaner.

This script adds and changes this part.

| Option | Description |
| --- | --- |
| GRUB_DISABLE_OS_PROBER=true | Disables os-prober completely |

## Usage

To run the Bash script, simply run the following command.

> [!CAUTION]
> This script must run with **sudo**, check the script before doing anything.
>
> **I'm not responsible if your PC doesn't boot never again** 😥😥😖😖

```bash
sh fix.sh
```

### Options

You can use the script with this command structure.

```bash
sh fix.sh [options...] [value]
```

Here is the list of options you can use, for more detail, you can read the [Overview](#overview) section.

#### List of options

| Simple | Complete | Description |
| --- | --- | --- |
| `-c` | `--configuration-file` | Input a custom path for GRUB2 configuration file |
| `-t` | `--terminal-output` | Changes *GRUB_TERMINAL_OUTPUT* option from **console** to **gfxterm** |
| `-g` | `--gfxmode` | Adds the *GRUB_GFXMODE* option with **auto** value |
| `-o` | `--os-prober` | Adds the *GRUB_DISABLE_OS_PROBER* option with **true** value |

## License

This repository uses the [GPLv3](https://choosealicense.com/licenses/gpl-3.0/) license.
