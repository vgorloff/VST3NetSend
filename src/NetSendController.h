//
//  VST3Controller.h
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#ifndef __VST3NetSend__VST3Controller__
#define __VST3NetSend__VST3Controller__

GV_NAMESPACE_BEGIN

using namespace Steinberg;
using namespace Steinberg::Vst;

static const FUID           NetSendControllerUID(0x050cf160, 0x362e4416, 0xb215cd57, 0x8dc5d5d8);

class NetSendController : public EditController {

public:
    NetSendController();
    virtual ~NetSendController();

    // VST3 SDK methods
    tresult PLUGIN_API            initialize (FUnknown* context);
//    tresult PLUGIN_API            setComponentState (IBStream* state);
//    virtual tresult PLUGIN_API    setParamNormalized (ParamID tag, ParamValue value);
    virtual IPlugView* PLUGIN_API createView (FIDString name);

    static FUnknown* createInstance (void*) {
        return (IEditController*)new NetSendController();
    }

    NetSendController& operator=(const NetSendController&) = delete;
    NetSendController(const NetSendController&) = delete;
    NetSendController& operator=(NetSendController&&) = delete;
    NetSendController(NetSendController&&) = delete;
    
};

GV_NAMESPACE_END

typedef GV::NetSendController GVNetSendVST3Controller;

#endif /* defined(__VST3NetSend__VST3Controller__) */
