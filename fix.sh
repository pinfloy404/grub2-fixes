#!/bin/bash

#   Grub location
grub="/etc/default/grub"

#   Options to fix screen resolution
terminal_output_console="GRUB_TERMINAL_OUTPUT=\"console\""
terminal_output_gfxterm="GRUB_TERMINAL_OUTPUT=\"gfxterm\""

gfxmode="GRUB_GFXMODE=auto"

#   Option to disable OS Prober
disable_os_prober="GRUB_DISABLE_OS_PROBER=true"

#   Check if GRUB file is at location
if find $grub; then
    echo "grub file located :)"
else
    echo "no grub file in $grub"
    exit 1
fi

#   Change Grub terminal output from console to gfxterm if not modified
if grep -q $terminal_output_gfxterm $grub; then
    echo "gfxterm is already added"
else
    sed -i "s/$terminal_output_console/$terminal_output_gfxterm/" $grub
fi

#   Add gfxmode if not exists
if grep -q $gfxmode $grub; then
    echo "gfxmode is already added"
else
    echo $gfxmode >> $grub
fi

#   Disables OS prober if not exists
if grep -q $disable_os_prober $grub; then
    echo "os-prober is already disabled"
else
    echo $disable_os_prober >> $grub
fi

#   Shows the final result
cat $grub

#   Ask user if it's ok
read -p "Rebuild Grub? Y/n: " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

#   Rebuild grub configuration
grub2-mkconfig -o /boot/grub2/grub.cfg