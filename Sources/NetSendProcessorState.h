//
//  NetSendProcessorState.h
//  VST3NetSend
//
//  Created by Vlad Gorloff on 07.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#ifndef __VST3NetSend__NetSendProcessorState__
#define __VST3NetSend__NetSendProcessorState__

#include "base/source/fstreamer.h"

GV_NAMESPACE_BEGIN

using namespace Steinberg;

class NetSendProcessorState {

public:
    explicit NetSendProcessorState();
    virtual ~NetSendProcessorState();

    static const uint64 currentParamStateVersion;

    int8                bypass;
    int8                connectionFlag;
    int8                dataFormat;
    int64               port;
    char8 bonjourName[128];
    char8 password[128];

    tresult setState (IBStream* stream);
    tresult getState (IBStream* stream);

//    NetSendProcessorState& operator=(const NetSendProcessorState&) = delete;
    NetSendProcessorState(const NetSendProcessorState&) = delete;
//    NetSendProcessorState& operator=(NetSendProcessorState&&) = delete;
//    NetSendProcessorState(NetSendProcessorState&&) = delete;
};

GV_NAMESPACE_END

#endif /* defined(__VST3NetSend__NetSendProcessorState__) */
