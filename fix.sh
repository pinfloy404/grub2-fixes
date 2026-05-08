#!/bin/bash

#   Argument variables, all True by default
terminal_output=1
gfxmode=1
os_prober=1

#   Checks if there are arguments
if [[ $# -ne 0 ]]; then
    #   All variables go to False
    terminal_output=0
    gfxmode=0
    os_prober=0

    #   List of arguments
    ARGS=$(getopt -o tgo --long terminal-output,gfxmode,os-prober -- "$@")

    #   Argument parsing
    eval set -- "$ARGS"

    while [ : ]; do
        case "$1" in
            -t | --terminal-output)
                echo "terminal output changed"
                terminal_output=1
                shift
                ;;
            
            -g | --gfxmode)
                echo "gfxmode added"
                gfxmode=1
                shift
                ;;

            -o | --os-prober)
                echo "os-prober disabled"
                os_prober=1
                shift
                ;;

            --)
                shift;
                break
                ;;
        esac
    done
fi

#   GRUB2 location
grub="/etc/default/grub"

#   Options to change GRUB2 terminal output
terminal_output_console="GRUB_TERMINAL_OUTPUT=\"console\""
terminal_output_gfxterm="GRUB_TERMINAL_OUTPUT=\"gfxterm\""

#   Option to detect automatically screen resolution
gfx_auto="GRUB_GFXMODE=auto"

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

#   Checks if terminal output variable is True
if (( terminal_output )); then
    #   Changes GRUB2 terminal output from console to gfxterm if not modified
    if  grep -q $terminal_output_gfxterm $grub; then
        echo "gfxterm is already added"
    else
        sed -i "s/$terminal_output_console/$terminal_output_gfxterm/" $temp_file
    fi
fi

#   Checks if gfxmode varibale is True
if (( gfxmode )); then
    #   Adds gfxmode if not exists
    if grep -q $gfx_auto $grub; then
        echo "gfxmode is already added"
    else
        echo $gfx_auto >> $temp_file
    fi
fi

#   Checks if os-prober variable is True
if (( os_prober )); then
    #   Disables os-prober if it's not already disabled
    if grep -q $disable_os_prober $grub; then
        echo "os-prober is already disabled"
    else
        echo $disable_os_prober >> $temp_file
    fi
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