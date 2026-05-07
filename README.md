# GRUB2 Fixes

A simple script in Bash to fix a few things for GRUB2.

##  What fixes?

This script adds and changes some options to the GRUB2 configuration and rebuilds it automatically.

### Screen resolution

Sometimes GRUB2 don't detects automatically the screen resolution, so everytime the system gets wiped out, this options has to be added and changed into the GRUB2 file configuration.

This script adds and changes the following in this part.

| Option | Description |
| --- | --- |
| GRUB_TERMINAL_OUTPUT="gfxterm" | Changes the option from **console** to **gfxterm** |
| GRUB_GFXMODE=auto | Adds this option to detect automatically screen resolution |

### os-prober

If there are other OS in another hard drive, GRUB2 automatically detects it and adds it into the menu, but selecting them sometimes doesn't work, so this script adds the option to disable it, so makes the menu more cleaner.

This script adds and changes the following in this part.

| Option | Description |
| --- | --- |
| GRUB_DISABLE_OS_PROBER=true | Disables os-prober completely |

##  Usage

To run the Bash script, simply run the following command.

> [!CAUTION]
> This script must run with **sudo**, check the script before doing anything.
> **I'm not responsible if your PC doesn't boot never again** 😥😥😖😖

```bash
sh fix.sh
```

## License

This repository uses the [GPLv3](https://choosealicense.com/licenses/gpl-3.0/) license.