#!/bin/bash

#   GRUB2 location
grub="/etc/default/grub"

#   Argument variables, all True by default
terminal_output_arg=1
gfx_arg=1
os_prober_arg=1

#   Checks if there are arguments
if [[ $# -ne 0 ]]; then
    #   All variables go to False
    terminal_output_arg=0
    gfx_arg=0
    os_prober_arg=0

    #   List of arguments
    ARGS=$(getopt -o c:tgo --long configuration-file:,terminal-output,gfxmode,os-prober -- "$@" 2>/dev/null)

    #   Checks for invalid arguments
    if [[ $? -ne 0 ]]; then
        echo -e "invalid argument $@"
        exit 1
    fi

    #   Argument parsing
    eval set -- "$ARGS"

    #   Argument processing
    while true; do
        #   Argument selector
        case $1 in
            #   Configuration file argument
            -c | --configuration-file)
                grub=$2
                shift 2
                ;;

            #   Terminal output argument
            -t | --terminal-output)
                terminal_output_arg=1
                shift
                ;;
            
            #   Screen resolution argument
            -g | --gfxmode)
                gfx_arg=1
                shift
                ;;

            #   os-prober argument
            -o | --os-prober)
                os_prober_arg=1
                shift
                ;;

            #   End
            --)
                shift
                break
                ;;
        esac
    done
else
    #   Ask user if it's ok to continue with all arguments enabled
    read -p "All options are enabled! Do you wanna continue? [Y/n]: " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
fi

#   Checks if GRUB2 file is at location
if ! find $grub > /dev/null; then
    exit 1
fi

#   Options to change GRUB2 terminal output
terminal_output_console="GRUB_TERMINAL_OUTPUT=\"console\""
terminal_output_gfxterm="GRUB_TERMINAL_OUTPUT=\"gfxterm\""

#   Option to detect automatically screen resolution
gfxmode="GRUB_GFXMODE=auto"

#   Option to disable os-prober
disable_os_prober="GRUB_DISABLE_OS_PROBER=true"

#   Creates temporal file
temp_file=$(mktemp)

#   Copies GRUB2 file data to temporal file
cat $grub > $temp_file

#   Checks if terminal output variable is True
if (( terminal_output_arg )); then
    #   Changes GRUB2 terminal output from console to gfxterm if not modified
    if  grep -q $terminal_output_gfxterm $grub; then
        echo "terminal output is already changed"
    else
        sed -i "s/$terminal_output_console/$terminal_output_gfxterm/" $temp_file
    fi
fi

#   Checks if GFXMODE argument varibale is True
if (( gfx_arg )); then
    #   Adds gfxmode if not exists
    if grep -q $gfxmode $grub; then
        echo "gfxmode is already added"
    else
        echo $gfxmode >> $temp_file
    fi
fi

#   Checks if os-prober variable is True
if (( os_prober_arg )); then
    #   Disables os-prober if it's not already disabled
    if grep -q $disable_os_prober $grub; then
        echo "os-prober is already disabled"
    else
        echo $disable_os_prober >> $temp_file
    fi
fi

#   Shows the final result with line separations between
echo && cat $temp_file && echo

#   Ask user if it's ok to continue, if not, deletes temporal file and exits
read -p "Do you wanna rebuild GRUB2 with this configuration? [Y/n]: " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || { rm $temp_file; exit 1; }

#   Overwrites GRUB2 file data
cat $temp_file > $grub

#   Deletes temporal file and prints line separation
rm $temp_file && echo

#   Rebuild grub configuration
grub2-mkconfig -o /boot/grub2/grub.cfg