# rlb-node-app-debug-env

## Description
The package available here is a node based application that serves a site using an express server. The currently looping video can be changed by sending a UDP command on port 5000 ("red" or "green" UDP message).

![alt text](screenshots/app-site.png)

A UDP command can be send using any 3rd party application capabe of sending UDP command or the user may also send a UDP command by accssing the control page via a web browser at a similar address http://player-ip-address:3000/control

![alt text](screenshots/control-page.png)

This package also provide a simplified Dev environment and workflow to configure a player and setup a node based Dev environment that allows to use npm scripts automation to 
- copy the src folder (including the autorun.brs) to the dist folder, 
- build the bundle.js using webpack parameters from webpack config file, 
- upload the dist folder to the player SD card (using bsc CLI tool),
- use Telnet to restart the autorun/BS Application 
    
The automation described above can be acheived using the below npm script command:
```bash
npm run sync-all-build-upload-restart
```


## Player Setup

To setup the player, update the player OS with the latest version available on the website, copy the content of the dist folder to a blank SD card and insert the SD card (player should be OFF when inserting the SD card) in the player then plug the power connector to the player.

After a few reboots the player should display its IP address. Please use a Telnet client application to establish a Telnet session with the player (port 23)

In the Telnet session you should see a command that you can copy and paste in the VS Code project terminal to setup the player for the debugging environment:

![alt text](screenshots/telnet-setup-string.png)




## More info to be added later...

