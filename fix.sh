#!/bin/bash

#   GRUB2 location
grub="/etc/default/grub"

#   Options to change GRUB2 terminal output
terminal_output_console="GRUB_TERMINAL_OUTPUT=\"console\""
terminal_output_gfxterm="GRUB_TERMINAL_OUTPUT=\"gfxterm\""

#   Option to detect automatically screen resolution
gfxmode="GRUB_GFXMODE=auto"

#   Option to disable os-prober
disable_os_prober="GRUB_DISABLE_OS_PROBER=true"

#   Checks if GRUB2 file is at location
if find $grub; then
    echo "grub file located :)"
else
    echo "no grub file in $grub"
    exit 1
fi

#   Creates temporal file
temp_file=$(mktemp)

#   Copies GRUB2 file data to temporal file
cat $grub > $temp_file

#   Change GRUB2 terminal output from console to gfxterm if not modified
if grep -q $terminal_output_gfxterm $grub; then
    echo "gfxterm is already added"
else
    sed -i "s/$terminal_output_console/$terminal_output_gfxterm/" $temp_file
fi

#   Add gfxmode if not exists
if grep -q $gfxmode $grub; then
    echo "gfxmode is already added"
else
    echo $gfxmode >> $temp_file
fi

#   Disables os-prober if it's not already disabled
if grep -q $disable_os_prober $grub; then
    echo "os-prober is already disabled"
else
    echo $disable_os_prober >> $temp_file
fi

#   Shows the final result
cat $temp_file

#   Ask user if it's ok to continue, if not, deletes temporal file and exits
read -p "Do you wanna rebuild GRUB2 with this configuration? [Y/n]: " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || rm $temp_file && exit 1

#   Overwrites GRUB2 file data
cat $temp_file > $grub

#   Deletes temporal file
rm $temp_file

#   Rebuild grub configuration
grub2-mkconfig -o /boot/grub2/grub.cfg