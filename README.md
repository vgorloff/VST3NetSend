VST3NetSend
===========

VST3 version of Mac OS X system-supplied AUNetSend audio plugin.

Purpose and Auditory:
---

***AUNetSend*** - is an audio plugin that streams audio data over a network. Used in conjunction with the AUNetReceive generator audio unit. ***VST3NetSend*** - is a VST3 version of plugin which provide similar functionality as AUNetSend. It could be used with Cubase/Nuendo® (by Steinberg®) as it at the moment does not support AU standard.  
  
This might be useful for Musicians, Audio engineers. *Typical use cases*: Audio data interchange between audio Applications; Streaming audio data between computers in Local Area Network.

Features:
---

1. Supports any sample rate and audio buffer size. Supports multiple inputs/outputs: 1x1 ... 8x8 (except 3x3).
2. CPU safe.
3. Fully utilize features of original AUNetSend audio plugin.

System requirements:
---

* Mac OS X 10.7 and above.
* 64-bit VST3 host application (DAW).
* Gigabit LAN connection between computers.

Future plans:
---

* Skin support
* Streaming to several clients simultaneously
* Multichannel support (>2 channels if possible)
* VST2 64-bit version (maybe)

Usage:
---

[Download binary](https://bitbucket.org/vgorloff/vst3netsend/downloads) and copy it to "/Library/Audio/Plug-Ins/VST3" folder.  
Launch Cubase/Nuendo® and add instance to insert slot: ***Tools -> WaveLabs VST3NetSend***.

Troubleshooting:
---

[Bonjour Browser](http://www.tildesoft.com) application can be used to inspect all AUNetSend providers.  
Plugin should be listed as "_apple-ausend.tcp." provider.

Information for developers:
---

To build plugin the following tools, libs and SDKs needed:  
  
* [Xcode](https://itunes.apple.com/en/app/xcode/id497799835?mt=12)
* [Core Audio SDK](https://developer.apple.com/downloads) (search for CoreAudio, then download package from Feb 16, 2012)
* [VST3 SDK](http://www.steinberg.net/en/company/developer.html)

In Xcode go to _**Preferences -> Locations -> Source Trees**_ and set the following settings:  

* `GV_COREAUDIO_SDK` - path to Core Audio SDK (i.e. /Volumes/Data/SDK/CoreAudio)
* `GV_VST_SDK` - path to VST3 SDK (i.e. /Volumes/Data/SDK/VST3)

Now you are ready to build.

History:
---

v1.0.2 - RC1 (current).

* All features from original AUNetSend audio plugin now supported.
* GUI added. MVC wired using Cocoa bindings.
* Added connection status fetching timer.

v1.0.1 - Beta version.

* Plugin without UI.
* Hardcoded parameters.

v1.0.0 - Alpha version.

* Plugin listed in VST3 host but does not doing anything.


