# autoUpdate.sh
autoUpdate.sh is a bash script in charge of automate your updates in Unix and Unix-like systems.

## Usage
Once you have downloaded autoUpdate.sh and config.cfg files, you must change the default password in config.cfg set to 0000. Change this for your current system password, otherwise when the program tries to `sudo -S apt-get update`, an error will pop. Make sure that the script has the `executable 'x'` permission with:
```
$ chmod +x ./autoUpdate.sh
```
There is a short help section already programmed inside the script. You can access this information using: 
```
$ ./autoUpdate.sh --help
```
With your password already set, it is highly recommended to first try the script and verify that everything its working. Execute it for first time with:
```
$ ./autoUpdate.sh
```
If everything works properly, you can now choose between the 4 different options to fully automate your updates. Each option works slightly different.
### 1. /etc/init.d folder [WORKING ON IT]
<!-- 
buscar: carpeta autostart linux
sale: El directorio /etc/xdg/autostart contiene aplicaciones que se inician para todos los usuarios del equipo. Si queremos que una aplicación se inicie sólo para un usuario en particular, deberemos ubicar el lanzador (el archivo con extensión . desktop) en el directorio ~/. config/autostart.
http://somebooks.es/ejecutar-un-programa-automaticamente-al-iniciar-sesion-en-ubuntu-20-04-lts/ 
https://geekflare.com/es/how-to-auto-start-services-on-boot-in-linux/
http://somebooks.es/como-ver-y-administrar-todos-los-programas-que-se-ejecutan-al-iniciar-una-sesion-de-ubuntu-20-04-lts/#:~:text=El%20directorio%20%2Fetc%2Fxdg%2Fautostart%20contiene%20aplicaciones%20que%20se,config%2Fautostart.
-->
The program will execute when your machine starts. You will need to move both the script and config.cfg to a `.conf` file like `/etc/init.d`. From the file where you have the script write;
```
$ update-rc.d autoUpdate.sh defaults && sudo cp autoUpdate.sh config.cfg /etc/init.d
```
### 2. .bashrc file
The program will execute everytime you open a bash terminal. You can have both the script and the config.cfg file where ever you want but always together. Inside the `.bashrc` file you can just write;
```
cd path/to/script/ && ./autoUpdate.sh && cd $OLDPWD
```
If you move the script and the config.cfg to the same folder as .bashrc you can simply write; `./autoUpdate.sh` at the end of the .bashrc file.
### 3. alias in the .bashrc file
The program will execute when ever you call it. You can have both the script and the config.cfg file where ever you want but always together. Inside the `.bashrc` file you can just write;
```
alias update="cd path/to/script/ && ./autoUpdate.sh && cd - > /dev/null"
```
If you move the script and the config.cfg to the same folder as .bashrc you can simply write; 
```
alias update="./autoUpdate.sh"
```
at the end of the .bashrc file.
### 4. Combination [RECOMMENDED]
You can combine some of this methods in order to get various effects. For example, you can combine methods 2 and 3 so that the program will execute everytime you open a bash terminal AND when ever you call it. Just add both options to the .bashrc file.  
Of course you can also implement different alias for the different options the program has. Just add the correct flag next to the executable the same way you would do it normally from the command promp.

## FAQ
- In order to see if you had give the correct permissions to the script use `$ ls -l` in the same folder as the script. It should look somewhat like this: 
  - Before -> **-rwxr--r--** 1 user user 3875 Feb 20 20:27 autoUpdate.sh.
  - After &nbsp;  -> **-rwxr-xr-x** 1 user user 3875 Feb 20 20:27 autoUpdate.sh.
- In order to find any hidden file like .bashrc use `$ ls -a`.
- .bashrc is usually located at the home directory. You can get there quickly from anywhere with `$ cd ~`
- There is no need in changing the script itself but you can modify it if you want to.  
