//
//  NetSendView.h
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#ifndef __VST3NetSend__NetSendView__
#define __VST3NetSend__NetSendView__

#include "public.sdk/source/vst/vsteditcontroller.h"
#include "NetSendProcessorState.h"

#ifdef __OBJC__
@class NetSendViewController;
#else
typedef struct objc_object NetSendViewController;
#endif

GV_NAMESPACE_BEGIN

using namespace Steinberg;
using namespace Steinberg::Vst;

class NetSendView : public EditorView
{
public:
   
   explicit NetSendView(EditController* controller, ViewRect* size = 0);
   virtual ~NetSendView();
   
   // IPlugView methods
   virtual tresult PLUGIN_API isPlatformTypeSupported (Steinberg::FIDString type);
   virtual tresult PLUGIN_API attached (void* parent, Steinberg::FIDString type);
   virtual tresult PLUGIN_API removed ();
   
   // Custom
   void notifyParameterChanges(unsigned int index);
   void handleStateChanges(const NetSendProcessorState& state);
   void setConnectionStatus(int64 status);
   
   NetSendView& operator=(const NetSendView&) = delete;
   NetSendView(const NetSendView&) = delete;
   NetSendView& operator=(NetSendView&&) = delete;
   NetSendView(NetSendView&&) = delete;
   
private:
   NetSendViewController* mViewController;
   void handleViewModelChanges(int sourceID);
   
};

GV_NAMESPACE_END

#endif /* defined(__VST3NetSend__NetSendView__) */
