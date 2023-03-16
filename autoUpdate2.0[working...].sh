#!/bin/bash

#DEFAULT SETTINGS
conf_file="config.cfg"
if [ -r "$conf_file" ]; then #check if configuration file is readeble
    source "$conf_file"
else
    echo -e "\e[1mWARNING:\e[0m \"$conf_file\" could not open. Program mode set to default." 1>&2
    auto=0
    prevDate=2002-02-20
fi

today=$(date +"%Y-%m-%d")

#---------------FUNCTIONS---------------
#config.cfg
function config(){ #write conf_file
    echo $password | sudo -S bash -c "echo 'password="$password"' > "$conf_file"" #sudo permits are needed for /ect/init.d
    sudo -S bash -c "echo 'prevDate="$1"' >> "$conf_file""
    sudo -S bash -c "echo 'auto="$auto"' >> "$conf_file""
    sudo -S bash -c "echo 'mute="$mute"' >> "$conf_file"" 
}

#update-upgrade
function update(){
    #mute every message except WARNING
    if [ $mute -eq 2 ]; then
	echo $password | sudo -S apt-get update > /dev/null
	sudo apt-get upgrade -y > /dev/null

	if [ $? -eq 0 ]; then
	    sudo apt-get autoclean > /dev/null
	    sudo apt-get clean > /dev/null
	    sudo apt-get autoremove > /dev/null
	    exit 0
	else
	    echo -e "\e[1mWARNING:\e[0m Updates failed to install.\n" 1>&2
	    exit 255
	fi
    #mute every message except WARNING and completation messages
    elif [ $mute -eq 1 ]; then
	echo $password | sudo -S apt-get update > /dev/null
	sudo apt-get upgrade -y > /dev/null

	if [ $? -eq 0 ]; then
	    sudo apt-get autoclean > /dev/null
	    sudo apt-get clean > /dev/null
	    sudo apt-get autoremove > /dev/null
	    echo -e "\nUpdates installed successfully.\n"
	    exit 0
	else
	    echo -e "\e[1mWARNING:\e[0m Updates failed to install.\n" 1>&2
	    exit 255
	fi
    #mute no message
    else
	echo $password | sudo -S apt-get update
	sudo apt-get upgrade -y

	if [ $? -eq 0 ]; then
	    sudo apt-get autoclean
	    sudo apt-get clean
	    sudo apt-get autoremove
	    echo -e "\nUpdates installed successfully.\n"
	    exit 0
	else
	    echo -e "\e[1mWARNING:\e[0m Updates failed to install.\n" 1>&2
	    exit 255
	fi	    
    fi
}

#help && info
function help(){
    #-e flag with echo interpretates '\'
    #\e indicates ini-end of the style
    #Xm where X is the attribute of the style (0-normal, 1-bold, 2-Dim, 3-Italic, 4-Underline, 5-Blink, 7-Invert, 8-Invisible)
    echo -e "\n\e[1mHELP\e[0m"
    echo "Usage: $0 [-option1] [-option2]"
    echo "[-option1]:"
    echo " -h, --help  Show this help message."
    echo " -a, --auto  Change between auto and manual mode."
    echo "[-option1] [-option2]:"
    echo " -m, --mute    X    Change the amount of messages the program will provide. X represents one of the options from 0-2 (all,some,non)."
}

function auto(){
    echo -e "\e[4m[-a/--auto] The program has 2 modes:\e[0m"
    echo -e "1. Manual mode: to use the program you must be in the same folder and execute it with \e[1m$0\e[0m. Other option is with an alias stated in .bashrc. This mode is not recommended for /etc/init.d folder."
    echo "2. Automatic/Default mode: the program will execute by its own, it will execute once a day as long as you have it and config.cfg in /etc/init.d folder. If you have automatic in .bashrc the system will update everytime a bash terminal is opened."
}

function mute(){
    echo -e "\n\e[4m[-m/-mute] The message options are:\e[0m"
    echo "[-m 0/--mute 0] All messages will be enabled and will apear on screen" 
    echo "[-m 1/--mute 1] Only completation messages will be enabled"
    echo "[-m 2/--mute 2] No messages will be enabled"
    echo -e "\nCurrent state: $0 --mute \e[1m$mute\e[0m\n" 
}

function info(){
    echo -e "\n\e[1mINFO\e[0m"
    auto
    mute
    echo -e "\e[1mIf you want more information visit my github repository \"https://github.com/aleexnager/Linux-autoUpdate\".\e[0m\n"
}

function usage_err(){
    echo -e "Unknown command option, use --help/-h to ask for help and info about the program\n" 1>&2
    exit 255 
}

#---------------ARGUMENT TREATMENT--------------- 
for arg in "$@"; do
    if [ "$arg" == "-h" ] || [ "$arg" == "--help" ]; then #help && info
	help
	echo -e "\nDo you need more information?[yes/no]"
        read answer #stdin
	if [ "$answer" == "yes" ]; then
	    info
	    exit 0
	else
	    exit 0
	fi
    elif [ "$arg" == "-a" ] || [ "$arg" == "-auto" ]; then #modes
	info
	if [ $auto -eq 0 ]; then
	    echo "You are actually in manual mode. Do you want to change to automatic mode? [yes/no]"
            read answer
	    if [ "$answer" = "no" ]; then
                echo -e "You will stay with the manual version. Use \e[1m$0\e[0m to update your machine\n"
                exit 0
            elif [ "$answer" = "yes" ]; then
                echo -e "You have changed to the automatic version. Your machine will update daily.\n"
                auto=1
		$(config $prevDate)
	        exit 0
            else
	        usage_err
	    fi #auto=0
	elif [ $auto -eq 1 ]; then
	    echo "You are actually in automatic mode. Do you want to change to manual mode? [yes/no]"
	    read answer
	    if [ "$answer" = "no" ]; then
                echo -e "You will stay with the automatic version. Your machine will update daily\n"
                exit 0
            elif [ "$answer" = "yes" ]; then
                echo -e "You have changed to the manual version. Use \e[1m$0\e[0m to update your machine.\n"
                auto=0
		$(config $prevDate)
	        exit 0
            else
	        usage_err
	    fi #auto=1
	fi #auto
    elif [ "$arg" == "-m" ] || [ "$arg" == "--mute" ] && [ $# -eq 1 ]; then
	mute
	exit 0
    elif [ "$arg" == "-m" ] || [ "$arg" == "--mute" ] && [ $# -eq 2 ]; then
	case $2 in
	    0)
		echo -e "All process messages are enabled\n"
		mute=0
		$(config $prevDate)
		exit 0
	    ;;
    	    1)
		echo -e "Only completed process messages are enabled\n"
	    	mute=1
		$(config $prevDate)
		exit 0
	    ;;
	    2)
		echo -e "All process messages are disabled\n"
		mute=2
		$(config $prevDate)
		exit 0
	    ;;
	    *)
		usage_err
	    ;;
	esac
    else
	usage_err
    fi #args
done

#---------------MAIN---------------
if [ $auto -eq 1 ]; then #auto=1 (auto mode)
    if [ "$today" = "$prevDate" ]; then
	if [ $mute -ne 2 ]; then echo "You are up to date. :)" 
	fi
	$(config $today)
	exit 0
    else
	if [ $mute -eq 0 ]; then
	    echo -e "Your machine has not been updated since: $prevDate \n"
	fi
	$(config $today)
	update
    fi
else #auto=0 (manual mode)
    $(config $prevDate)
    update
fi

exit 0
