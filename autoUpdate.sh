#!/bin/bash

#DEFAULT SETTINGS
conf_file="config.cfg"
if [ -r "$conf_file" ]; then
    source "$conf_file"
    echo -e "\"$conf_file\" read correctly"
else
    echo -e "\e[1mWARNING:\e[0m \"$conf_file\" could not open. Program mode set to default."
    auto=0
fi

#Update-upgrade
function update(){
    echo 20022539 | sudo -S apt-get update
    sudo apt-get upgrade -y

    if [ $? -eq 0 ]; then
	sudo apt-get autoclean
	sudo apt-get clean
	sudo apt-get autoremove
	echo -e "Updates installed successfully.\n"
    else
	echo -e "\e[1mWARNING:\e[0m Updates failed to install.\n"
	exit 255
    fi
}

#HELP AND INFO
function help(){
    #el flag -e interpreta los '\'
    #\e indicates ini-end of the style
    #Xm where X is the attribute of the style (0-normal, 1-bold, 2-Dim, 3-Italic, 4-Underline, 5-Blink, 7-Invert, 8-Invisible)
    echo -e "\n\e[1mHELP\e[0m\n\
Usage: ./autoUpdate.sh [-option]\n\
[-option]: can be --help/h to pop this text or -auto to able or disable automode\n\
The code is fully commented so that you can personalize what ever you want.\n\
If you want more information visit my github repository \"https://github.com/aleexnager/...\"."
}

function info(){
    echo -e "\n\e[1mINFO\e[0m\n\
The program has 2 modes.\n\
1. Manual/Default mode: in order to use the program you must execute it by yourself with \e[1m./autoUpdate.sh\e[0m in the terminal.\n\
2. Automatic mode: in this mode the program will work by its own, it will execute once a day.\n"
}

#ARGUMENT TREATMENT
for arg in "$@"; do
    if [ "$arg" == "-h" ] || [ "@arg" == "--help" ]; then
	help
	info
        exit 255
    elif [ "$arg" == "-auto" ]; then #Automated version
	info
	if [ $auto -eq 0 ]; then
	    echo "You are actually in manual mode. Do you want to change to automatic mode? [yes/no]"
            read answer #stdin
	    if [ "$answer" = "no" ]; then
                echo -e "You will stay with the manual version. Use \e[1m./autoUpdate.sh\e[0m to update your machine\n"
                exit 255
            elif [ "$answer" = "yes" ]; then
                echo -e "You have changed to the automatic version. Your machine will update daily.\n"
                auto=1
	        echo auto="$auto" > "$conf_file" #write in config_file
	        exit 255
            else
                echo -e "Unknown command option, use --help/-h to ask for help and info about the program\n"
                exit 255
	    fi
	elif [ $auto -eq 1 ]; then
	    echo "You are actually in automatic mode. Do you want to change to manual mode? [yes/no]"
	    read answer
	    if [ "$answer" = "no" ]; then
                echo -e "You will stay with the automatic version. Your machine will update daily\n"
                exit 255
            elif [ "$answer" = "yes" ]; then
                echo -e "You have changed to the manual version. Use \e[1m./autoUpdate.sh\e[0m to update your machine.\n"
               auto=0
	        echo auto="$auto" > "$conf_file"
	        exit 255
            else
                echo -e "Unknown command option, use --help/-h to ask for help and info about the program\n"
                exit 255
	    fi
	else
	    echo -e "\e[1mWARNING:\e[0m the value of the variable \"auto\" is not recognizable"
	fi
    else
        echo -e "Unknown command option, use --help/-h to ask for help and info about the program\n"
        exit 255
    fi
done


if [ $auto -eq 0 ]; then
    update
    exit 0
fi

if [ $auto -eq 1 ]; then
    today=$(date +"%Y-%m-%d")
    if [ "$today" = "$prevDate" ]; then
	echo "You are up to date. :)"
	#control = 1 > config_file
	exit 0
    else
	update
	#prevDate = today > config_file
	exit 0
    fi
fi
exit 0
