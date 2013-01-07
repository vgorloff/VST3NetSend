//
//  NetSendView.h
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#ifndef __VST3NetSend__NetSendView__
#define __VST3NetSend__NetSendView__

GV_NAMESPACE_BEGIN

using namespace Steinberg;
using namespace Steinberg::Vst;

class NetSendView : public EditorView
{
public:

    explicit NetSendView(EditController* controller, ViewRect* size = 0);
    virtual ~NetSendView();

    // VST3 SDK methods
    virtual tresult PLUGIN_API isPlatformTypeSupported (Steinberg::FIDString type);
    virtual tresult PLUGIN_API attached (void* parent, Steinberg::FIDString type);
    virtual tresult PLUGIN_API removed ();
    virtual tresult PLUGIN_API canResize ();

    NetSendView& operator=(const NetSendView&) = delete;
    NetSendView(const NetSendView&) = delete;
    NetSendView& operator=(NetSendView&&) = delete;
    NetSendView(NetSendView&&) = delete;

};

GV_NAMESPACE_END

#endif /* defined(__VST3NetSend__NetSendView__) */
