VST3NetSend
===========

VST3 version of Mac OS X system-supplied AUNetSend audio plugin.

*AUNetSend* - is an audio plugin that streams audio data over a network. Used in conjunction with the AUNetReceive generator audio unit. *VST3NetSend* - is a VST3 version of plugin which provide similar functionality as AUNetSend. It could be used with Cubase/Nuendo® (by Steinberg®).


[![VST3NetSend User Interface][i1]][a1]

Usage:
---

[Download binary](https://github.com/vgorloff/VST3NetSend/releases/latest) and copy it to "/Library/Audio/Plug-Ins/VST3" folder.  
Launch Cubase/Nuendo®. Add instance to insert slot: ***Tools -> WaveLabs VST3NetSend***.

Features:
---

* Supports any sample rate and audio buffer size.
* Supports multiple inputs/outputs: 1x1 ... 8x8 (except 3x3).
* CPU safe.
* Fully utilize features of original AUNetSend audio plugin.

System requirements:
---

* Mac OS X 10.7 and above.
* 64-bit VST3 host application (DAW).
* Gigabit LAN connection between computers.

Troubleshooting:
---

[Bonjour Browser](http://www.tildesoft.com) application can be used to inspect all AUNetSend providers.  
Plugin should be listed as "_apple-ausend.tcp." provider.

How to build:
---

To build plugin the following tools, libs and SDKs needed:  
  
* [Xcode](https://itunes.apple.com/en/app/xcode/id497799835?mt=12)
* [Core Audio SDK](https://developer.apple.com/downloads) (search for CoreAudio, then download package from Feb 16, 2012)
* [VST3 SDK](http://www.steinberg.net/en/company/developer.html)

In Xcode go to _**Preferences -> Locations -> Source Trees**_ and set the following settings:  

* `GV_COREAUDIO_SDK` - path to Core Audio SDK (i.e. /Volumes/Data/SDK/CoreAudio)
* `GV_VST_SDK` - path to VST3 SDK (i.e. /Volumes/Data/SDK/VST3)

Now you are ready to build the project.

[i1]: https://raw.githubusercontent.com/vgorloff/VST3NetSend/develop/VST3NetSend.png (VST3NetSend User Interface)
[a1]: https://raw.githubusercontent.com/vgorloff/VST3NetSend/develop/VST3NetSend.png (VST3NetSend User Interface)


