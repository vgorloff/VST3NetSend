# VST3NetSend

VST3 version of macOS system-supplied AUNetSend audio plugin.

- _AUNetSend_ - is an audio plugin that streams audio data over a network. Used in conjunction with the AUNetReceive generator audio unit.
- _VST3NetSend_ - is a VST3 version of the plugin which provide similar functionality as AUNetSend. It could be used with Cubase/Nuendo® (by Steinberg®).

![VST3NetSend User Interface](https://raw.githubusercontent.com/vgorloff/VST3NetSend/master/Media/VST3NetSend.png)

## Usage

1. [Download binary](https://github.com/vgorloff/VST3NetSend/releases/latest). Copy it to "~/Library/Audio/Plug-Ins/VST3" or "/Library/Audio/Plug-Ins/VST3" folder.
2. Launch Cubase/Nuendo®. Add instance to insert slot: **_Network -> MCA VST3NetSend_**.
3. Launch AudioUnit host (e.g.Apple Logic) and insert **_AUNetReceive_** plug-in. Select _VST3NetSend_ instance and connect to it.

## Features

- Supports any sample rate and audio buffer size.
- Supports multiple inputs/outputs: 1x1 ... 8x8 (except 3x3).
- CPU safe.
- Fully utilize features of original _AUNetSend_ audio plugin.

## System requirements

- macOS 10.14 and above.
- 64-bit VST3 host application (DAW).
- Gigabit LAN connection between computers.

## Troubleshooting

[Bonjour Browser](http://www.tildesoft.com) application can be used to inspect all AUNetSend providers.
Plugin should be listed as "\_apple-ausend.tcp." provider.

On new systems (macOS 10.13 and above) AUNetReceive may not connect to VST3NetSend via Bonjour discovery (seems IPv6 issue in AUNetReceive).
To solve this problem enter IP-address manually.

![Troubleshooting AUNetReceive. Step 1.](https://raw.githubusercontent.com/vgorloff/VST3NetSend/master/Media/Troubleshooting_AUNetRecieve_01.png)
![Troubleshooting AUNetReceive. Step 2.](https://raw.githubusercontent.com/vgorloff/VST3NetSend/master/Media/Troubleshooting_AUNetRecieve_02.png)

## How to build

To build plugin the following tools, libs and SDKs needed:

- [Xcode 12.4](https://developer.apple.com/xcode/)
- [VST3 SDK 3.7.1](http://www.steinberg.net/en/company/developer.html)

1. Download VST3 SDK.
1. Make a symbolic link to downloaded VST3 SDK like shown below:

    ```sh
    # Create root folder for VST SDKs (if not exists)
    sudo mkdir -p /usr/local/vst

    # Make symbolic link
    sudo ln -vsi /Path/To/Custom/Location/VSTSDKv3.7.1 /usr/local/vst/VSTSDKv3.7.1
    ```

3. Open Xcode project and build it. **Note:** Xcode build _Debug_ version by default. You may want to use "Product -> Build For -> Profiling" in order to have optimized version.

Once build completed, plugin can be found at `~/Library/Audio/Plug-Ins/VST3/Development/VST3NetSend.vst3`.
