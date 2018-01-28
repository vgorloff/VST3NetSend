VST3NetSend
===========

VST3 version of Mac OS X system-supplied AUNetSend audio plugin.

*AUNetSend* - is an audio plugin that streams audio data over a network. Used in conjunction with the AUNetReceive generator audio unit.  
*VST3NetSend* - is a VST3 version of the plugin which provide similar functionality as AUNetSend. It could be used with Cubase/Nuendo® (by Steinberg®).


![VST3NetSend User Interface](https://raw.githubusercontent.com/vgorloff/VST3NetSend/master/Media/VST3NetSend.png)

Usage:
-----

[Download binary](https://github.com/vgorloff/VST3NetSend/releases/latest) and copy it to "~/Library/Audio/Plug-Ins/VST3" or "/Library/Audio/Plug-Ins/VST3" folder.  
Launch Cubase/Nuendo®. Add instance to insert slot: ***Tools -> WaveLabs VST3NetSend***.

Features:
--------

* Supports any sample rate and audio buffer size.
* Supports multiple inputs/outputs: 1x1 ... 8x8 (except 3x3).
* CPU safe.
* Fully utilize features of original AUNetSend audio plugin.

System requirements:
-------------------

* macOS 10.11 and above.
* 64-bit VST3 host application (DAW).
* Gigabit LAN connection between computers.

Troubleshooting:
---------------

[Bonjour Browser](http://www.tildesoft.com) application can be used to inspect all AUNetSend providers.  
Plugin should be listed as "_apple-ausend.tcp." provider.

On new systems (macOS 10.11 and above) AUNetRecieve may not connect to VST3NetSend via Bonjour discovery (seems IPv6 issue in AUNetRecieve).
To solve this problem enter IP-address manually.

![Troubleshooting AUNetRecieve. Step 1.](https://raw.githubusercontent.com/vgorloff/VST3NetSend/master/Media/Troubleshooting_AUNetRecieve_01.png)
![Troubleshooting AUNetRecieve. Step 2.](https://raw.githubusercontent.com/vgorloff/VST3NetSend/master/Media/Troubleshooting_AUNetRecieve_02.png)

How to build:
------------

To build plugin the following tools, libs and SDKs needed:  
  
* [Xcode 9](https://developer.apple.com/xcode/)
* [VST3 SDK 3.6.8](http://www.steinberg.net/en/company/developer.html)

Put downloaded `VST SDK` into folder `Vendor/Steinberg/vst3sdk`. Or create file `Configuration/Developer.xcconfig` with the following contents:

    GV_VST_SDK = /Path/To/Custom/Location/VSTSDKv3.6.8/VST3_SDK

Now you are ready to build the project.