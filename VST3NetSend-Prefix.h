//
// Prefix header for all source files of the 'VST3NetSend' target in the 'VST3NetSend' project
//

#ifdef __OBJC__

    #import <Cocoa/Cocoa.h>

    #import "CommonDefinitions.h"
    #import "GVIntegerFormatter.h"
    #import "GVConnectionFlagTransformer.h"
    #import "GVConnectionStatusTransformer.h"
    #import "GVNetSendModel.h"
    #import "GVNetSendViewController.h"
    #import "GVNetSendViewProxy.h"
    #import "GVSolidBackgroundView.h"

#endif


#ifdef __cplusplus

    #include <AudioUnit/AudioUnit.h>
    #include <AudioToolbox/AudioToolbox.h>

    // Core Audio SDK
    #include "CAStreamBasicDescription.h"
    #include "AUOutputBL.h"

    #include <cassert>
    #include <vector>
    #include <string>

    // VST3 SDK
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnon-virtual-dtor"
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
    #include "pluginterfaces/base/ustring.h"
    #include "pluginterfaces/vst/vsttypes.h"
    #include "public.sdk/source/main/pluginfactoryvst3.h"
    #include "base/source/fstreamer.h"
    #include "public.sdk/source/vst/vsteditcontroller.h"
    #include "public.sdk/source/vst/vstaudioeffect.h"
    #include "pluginterfaces/vst/ivstparameterchanges.h"
    #include "pluginterfaces/base/ibstream.h"
    #include "base/source/timer.h"
#pragma clang diagnostic pop

    #include "CommonDefinitions.h"
    #include "Utilities.h"
    #include "NetSendProcessorState.h"
    #include "NetSendView.h"
    #include "NetSendController.h"
    #include "NetSendAU.h"
    #include "NetSendProcessor.h"

#endif
