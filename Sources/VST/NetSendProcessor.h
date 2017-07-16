//
//  NetSendProcessor.h
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#ifndef __VST3NetSend__Processor__
#define __VST3NetSend__Processor__

#include "base/source/timer.h"
#include "public.sdk/source/vst/vstaudioeffect.h"
#include "NetSendController.h"
#include <AudioUnit/AudioUnit.h>

#ifdef __OBJC__
@class NetSendAU;
#else
typedef struct objc_object NetSendAU;
#endif

GV_NAMESPACE_BEGIN

using namespace Steinberg;
using namespace Steinberg::Vst;

static const FUID NetSendProcessorUID(0x60ed7185, 0x786a4eb7, 0xb8007a46, 0x4cc95357);

class NetSendProcessor : public AudioEffect, public ITimerCallback {
   
public:
   NetSendProcessor();
   virtual ~NetSendProcessor();
   
   // IPluginBase methods
   tresult PLUGIN_API initialize (FUnknown* context);
   tresult PLUGIN_API terminate ();
   
   // IAudioProcessor
   tresult PLUGIN_API setBusArrangements (SpeakerArrangement* inputs, int32 numIns, SpeakerArrangement* outputs, int32 numOuts);
   tresult PLUGIN_API process (ProcessData& data);
   tresult PLUGIN_API setupProcessing (ProcessSetup& setup);
   
   // IComponent
   tresult PLUGIN_API setActive (TBool state);
   tresult PLUGIN_API setState (IBStream* state);
   tresult PLUGIN_API getState (IBStream* state);
   
   // ITimerCallback
   virtual void onTimer (Timer* timer);
   
   // IConnectionPoint
   virtual tresult PLUGIN_API notify (IMessage* message);
   
   static FUnknown* createInstance (void*) {
      return (IAudioProcessor*)new NetSendProcessor();
   }
   
   NetSendProcessor& operator=(const NetSendProcessor&) = delete;
   NetSendProcessor(const NetSendProcessor&) = delete;
   NetSendProcessor& operator=(NetSendProcessor&&) = delete;
   NetSendProcessor(NetSendProcessor&&) = delete;
   
private:
   void updateParameters(IParameterChanges* changes);
   void processBypass(ProcessData& data);
   
private:
   NetSendProcessorState       mParams;
   Timer* mTimer;
   NetSendAU* mNetSendAU;
   AudioBufferList* mBufferList;
};

GV_NAMESPACE_END

#endif /* defined(__VST3NetSend__Processor__) */
