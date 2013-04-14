VST3NetSend
===========

VST3 version of Mac OS X system-supplied AUNetSend audio plugin.   
Detailed description could be found on [product home page](http://www.wavelabs.com.ua).

[![VST3NetSend User Interface][i1]][a1]

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

Usage:
---

[Download binary](https://bitbucket.org/vgorloff/vst3netsend/downloads) and copy it to "/Library/Audio/Plug-Ins/VST3" folder.  
Launch Cubase/Nuendo® and add instance to insert slot: ***Tools -> WaveLabs VST3NetSend***.

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

Now you are ready to build.


* Plugin listed in VST3 host but does not doing anything.

[i1]: https://lh3.googleusercontent.com/-2xZW76umLhk/UWqcIuiObNI/AAAAAAAAAjw/KhTPd595M_c/s800/VST3NetSend_02.png (VST3NetSend User Interface)
[a1]: https://lh3.googleusercontent.com/-2xZW76umLhk/UWqcIuiObNI/AAAAAAAAAjw/KhTPd595M_c/s800/VST3NetSend_02.png (VST3NetSend User Interface)


