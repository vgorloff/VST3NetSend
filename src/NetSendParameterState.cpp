//
//  NetSendParameterState.cpp
//  VST3NetSend
//
//  Created by Vlad Gorloff on 07.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//


GV_NAMESPACE_BEGIN

using namespace Steinberg::Vst;

const uint64 NetSendParameterState::currentParamStateVersion = 0;

NetSendParameterState::NetSendParameterState()
{
    bypass = 0;
    status = 0;
}

NetSendParameterState::~NetSendParameterState()
{
    
}

tresult NetSendParameterState::setState (IBStream* stream)
{
    IBStreamer s(stream, kLittleEndian);
    uint64     version = 0;

    // version 0
    if (!s.readInt64u(version))
        return kResultFalse;

    if (!s.readInt8(bypass))
        return kResultFalse;

    if (!s.readInt8(status))
        return kResultFalse;

    if (version >= 1)
    {
        // do something
    }
    if (version >= 2)
    {
        // do something
    }
    if (version >= 3)
    {
        // do something
    }
    return kResultTrue;
}

tresult NetSendParameterState::getState (IBStream* stream)
{
    IBStreamer s(stream, kLittleEndian);

    // version 0
    if (!s.writeInt64u(currentParamStateVersion))
        return kResultFalse;

    if (!s.writeInt8(bypass))
        return kResultFalse;


    if (!s.writeInt8(status))
        return kResultFalse;


    // version 1

    // version 2

    // version 3

    return kResultTrue;
}


GV_NAMESPACE_END