//
//  NetSendProcessorState.cpp
//  VST3NetSend
//
//  Created by Vlad Gorloff on 07.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//


GV_NAMESPACE_BEGIN

using namespace Steinberg::Vst;

const uint64 NetSendProcessorState::currentParamStateVersion = 0;

NetSendProcessorState::NetSendProcessorState()
{
    bypass = 0;
    status = 0;
    dataFormat = 0;
    port = 52800;
    memset(bonjourName, 0, 128);
    memset(password, 0, 128);
    const char* defaultName = "VST3NetSend";
    memcpy(bonjourName, defaultName, sizeof (char8) * strlen(defaultName));
}

NetSendProcessorState::~NetSendProcessorState()
{
    
}

tresult NetSendProcessorState::setState (IBStream* stream)
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

    if (!s.readInt8(dataFormat))
        return kResultFalse;

    if (!s.readInt64(port))
        return kResultFalse;

    char8* buff = nullptr;
    
    buff = s.readStr8();
    if (buff == nullptr) {
        return kResultFalse;
    } else {
        memset(bonjourName, 0, 128);
        memcpy(bonjourName, buff, sizeof (char8) * strlen(buff));
        delete buff;
    }

    buff = s.readStr8();
    if (buff == nullptr) {
        return kResultFalse;
    } else {
        memset(password, 0, 128);
        memcpy(password, buff, sizeof (char8) * strlen(buff));
        delete buff;
    }

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

tresult NetSendProcessorState::getState (IBStream* stream)
{
    IBStreamer s(stream, kLittleEndian);

    // version 0
    if (!s.writeInt64u(currentParamStateVersion))
        return kResultFalse;

    if (!s.writeInt8(bypass))
        return kResultFalse;

    if (!s.writeInt8(status))
        return kResultFalse;

    if (!s.writeInt8(dataFormat))
        return kResultFalse;

    if (!s.writeInt64(port))
        return kResultFalse;

    if (!s.writeStr8(bonjourName))
        return kResultFalse;

    if (!s.writeStr8(password))
        return kResultFalse;


    // version 1

    // version 2

    // version 3

    return kResultTrue;
}


GV_NAMESPACE_END