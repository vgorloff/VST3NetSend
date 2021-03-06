//
//  VST3Factory.cpp
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#include "public.sdk/source/main/pluginfactory.h"
#include "NetSendProcessor.h"

#define GV_PLUGIN_NAME  "MCA VST3NetSend"
#define GV_VENDOR       "MCA Audio"
#define GV_EMAIL        "mailto:microcodingapps@icloud.com"
#define GV_URL          "https://www.microcodingapps.com"

BEGIN_FACTORY_DEF (GV_VENDOR, GV_URL, GV_EMAIL)

DEF_CLASS2 (INLINE_UID_FROM_FUID(GV::NetSendProcessorUID),
            PClassInfo::kManyInstances,
            kVstAudioEffectClass,
            GV_PLUGIN_NAME,
            Steinberg::Vst::kDistributable,
            Steinberg::Vst::PlugType::kFxNetwork,
            APP_PROJECT_VERSION "x" APP_BUNDLE_VERSION, // Plug-in version (to be changed)
            kVstVersionString,
            GV::NetSendProcessor::createInstance)

DEF_CLASS2 (INLINE_UID_FROM_FUID(GV::NetSendControllerUID),
            PClassInfo::kManyInstances,
            kVstComponentControllerClass,
            GV_PLUGIN_NAME "Controller",    // controller name (could be the same than component name)
            0,                              // not used here
            "",                             // not used here
            APP_PROJECT_VERSION "x" APP_BUNDLE_VERSION, // Plug-in version (to be changed)
            kVstVersionString,
            GV::NetSendController::createInstance)


END_FACTORY

bool InitModule () {
   return true;
}
bool DeinitModule () {
   return true;
}
