# autoUpdate.sh
autoUpdate.sh is a bash script in charge of automate your updates in a GNU/Linux based enviroment.

## Usage
In order to run the script you must first download both the autoUpdate.sh and config.cfg files. Once that is done you must change the default password in config.cfg set to 0000. Change this for your current system password, otherwise when the program tries to <sudo -S apt-get update>, an error will pop. There is no needing in changing the script itself but you can modify it if you want to.  
There is a short help section already programmed inside the script. You can access this information using: 
```
$ ./autoUpdate.sh --help.
```
