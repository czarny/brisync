# Brisync
Synchronize your external display brightness with built-in display.

# How it works
Application reads current brightness of your built-in display and passes it to external displays via DDC interface.

You can adjust brightness by a menu in the system status bar or hotkeys:
- brightness down: ⇧ + ⌃ + F1,
- brightness up: ⇧ + ⌃ + F2.

Adjusting brightness in the menu changes internal brightness factor for this display so future brightness updates match your preferences.

# How to install
```{bash}
brew cask install brisync
```
##### or
Download the latest app binary zip file from [here](https://github.com/czarny/Brisync/releases/download/v1.2.0/Brisync.zip). Extract it and copy to your /Applications directory.

##### Tested displays
* DELL U2415
* DELL U2412M
* DELL U2515H
* DELL U2717D
* DELL U3818DW
* LG IPS235
* LG UltraFine 4K 
  - _Need to restart application when plugging in and out monitors_
* IIYAMA PL2779Q
* ASUS AS239
* Fujitsu P27T-7
* Eizo FlexScan EV2436W
