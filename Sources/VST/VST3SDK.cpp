//
//  VST3SDK.cpp
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnon-virtual-dtor"
#pragma clang diagnostic ignored "-Wnewline-eof"
#pragma clang diagnostic ignored "-Wdeprecated-register"
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
#pragma clang diagnostic ignored "-Wunsequenced"
#pragma clang diagnostic ignored "-Wint-to-void-pointer-cast"
#pragma clang diagnostic ignored "-Wunused-function"
#pragma clang diagnostic ignored "-Wswitch"
#pragma clang diagnostic ignored "-Wempty-body"
#pragma clang diagnostic ignored "-Wpointer-bool-conversion"
#pragma clang diagnostic ignored "-Wpragma-pack"

// Base
#include "base/source/baseiids.cpp"
#include "base/source/fbuffer.cpp"
#include "base/source/fdebug.cpp"
#include "base/source/fdynlib.cpp"
#include "base/thread/source/flock.cpp"
#include "base/source/fobject.cpp"
#include "base/source/fstreamer.cpp"
#include "base/source/fstring.cpp"
#include "base/source/timer.cpp"
#include "base/source/updatehandler.cpp"
#include "pluginterfaces/base/conststringtable.cpp"
#include "pluginterfaces/base/funknown.cpp"
#include "pluginterfaces/base/coreiids.cpp"

// Others
#include "pluginterfaces/base/ustring.cpp"
#include "public.sdk/source/common/pluginview.cpp"
#include "public.sdk/source/main/macmain.cpp"
#include "public.sdk/source/main/pluginfactoryvst3.cpp"
#include "public.sdk/source/vst/vstaudioeffect.cpp"
#include "public.sdk/source/vst/vstbus.cpp"
#include "public.sdk/source/vst/vstcomponent.cpp"
#include "public.sdk/source/vst/vstcomponentbase.cpp"
#include "public.sdk/source/vst/vsteditcontroller.cpp"
#include "public.sdk/source/vst/vstinitiids.cpp"
#include "public.sdk/source/vst/vstparameters.cpp"

#pragma clang diagnostic pop
