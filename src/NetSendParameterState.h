//
//  NetSendParameterState.h
//  VST3NetSend
//
//  Created by Vlad Gorloff on 07.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#ifndef __VST3NetSend__NetSendParameterState__
#define __VST3NetSend__NetSendParameterState__

GV_NAMESPACE_BEGIN

using namespace Steinberg;
using namespace Steinberg::Vst;

class NetSendParameterState {

public:
    explicit NetSendParameterState();
    virtual ~NetSendParameterState();

    static const uint64 currentParamStateVersion;

    int8                bypass;
    int8                status;

    tresult setState (IBStream* stream);
    tresult getState (IBStream* stream);

    NetSendParameterState& operator=(const NetSendParameterState&) = delete;
    NetSendParameterState(const NetSendParameterState&) = delete;
    NetSendParameterState& operator=(NetSendParameterState&&) = delete;
    NetSendParameterState(NetSendParameterState&&) = delete;
};

GV_NAMESPACE_END

#endif /* defined(__VST3NetSend__NetSendParameterState__) */
