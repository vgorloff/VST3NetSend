VST3NetSend
===========

VST3 version of Mac OS X system-supplied AUNetSend audio plugin.

Purpose and Auditory:
---

***AUNetSend*** - is an audio plugin that streams audio data over a network. Used in conjunction with the AUNetReceive generator audio unit.  
***VST3NetSend*** - is a VST3 version of plugin which provide similar functionality as AUNetSend.  
It could be used with Cubase/Nuendo® (by Steinberg®) as it at the moment does not support AU standard.  
  
This might be useful for Musicians, Audio engineers.  
***Typical use cases***: Audio data interchange between audio Applications; Streaming audio data between computers in Local Area Network.

Features:
---

1. Supports any sample rate and audio buffer size.
2. CPU safe.

Limitations:
---

1. In current version plugin does not provide any user interface (standard plugin UI is used).
2. Plugin does not save/restore presets.
3. Port number, Bonjour service name and Stream format currently hardcoded to default values.
4. Project still in alpha version, but it is quite stable .)

System requirements:
---

* Mac OS X 10.7 and above.
* 64-bit VST3 host application (DAW).
* Gigabit LAN connection between computers.

Using:
---

Download binary and copy it to "/Library/Audio/Plug-Ins/VST3" folder.  
Launch Cubase/Nuendo® and add instance to insert slot: ***Tools -> M2M VST3NetSend***.

Troubleshooting:
---

[Bonjour Browser](http://www.tildesoft.com) application can be used to inspect all AUNetSend providers.  
Plugin should be listed as "_apple-ausend.tcp." provider.

Information for developers:
---

To build plugin the following tools, libs and SDKs needed:  
  
* [Xcode](https://itunes.apple.com/en/app/xcode/id497799835?mt=12)
* [Core Audio SDK](go to https://developer.apple.com/downloads) (search for CoreAudio)
* [VST3 SDK](http://www.steinberg.net/en/company/developer.html)

In Xcode go to _**Preferences -> Locations -> Source Trees**_ and set the following settings:  

* GV\_COREAUDIO\_SDK - path to Core Audio SDK (i.e. /Volumes/Data/SDK/CoreAudio)
* GV\_VST\_SDK - path to VST3 SDK (i.e. /Volumes/Data/SDK/VST3)

Now you are ready to build. Have a fun!

