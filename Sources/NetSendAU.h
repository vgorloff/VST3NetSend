//
//  NetSendAU.h
//  VST3NetSend
//
//  Created by Vlad Gorloff on 07.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#ifndef __VST3NetSend__NetSendAU__
#define __VST3NetSend__NetSendAU__

#include <AudioUnit/AudioUnit.h>
#include "public.sdk/source/vst/vstaudioeffect.h"
#include "AUOutputBL.h"
#include "NetSendController.h"

typedef unsigned long     NetSendAUStatusBits;

GV_NAMESPACE_BEGIN

class NetSendAU
{

public:

    NetSendAU ();
    virtual ~NetSendAU ();

    void SetupProcessing (ProcessSetup& setup);
    void SetActive (TBool state);
    void SetNumChannels(UInt32 numChannels);
    void Render(ProcessData& data);
    void setPortNum(UInt32 port);
    void setServiceName(const char* name);
    void setPassword(const char* pwd);
    void setTransmissionFormatIndex(UInt32 format);
    void setDisconnect(UInt32 flag);
    long getStatus();

    NetSendAU& operator =(const NetSendAU&) = delete;
    NetSendAU (const NetSendAU&)            = delete;
    NetSendAU& operator =(NetSendAU&&)      = delete;
    NetSendAU (NetSendAU&&)                 = delete;

private:

    static OSStatus NetSendRenderer(void* ref, AudioUnitRenderActionFlags* ioActionFlags, const AudioTimeStamp* inTimeStamp, UInt32 inBusNumber, UInt32 frames, AudioBufferList* ioData);

    static OSStatus VST3Renderer(void* ref, AudioUnitRenderActionFlags* ioActionFlags, const AudioTimeStamp* inTimeStamp, UInt32 inBusNumber, UInt32 frames, AudioBufferList* ioData);

    void setupStreamFormat(float sampleRate, UInt32 blockSize, UInt32 numChannels);
    void setupRenderCallback();

private:

    enum ComponentStatus
    {
        kUnknown       = 0,
        kInitialized   = (1u << 0),
        kActive        = (1u << 1),
        kErrorsPresent = (1u << 2)
    };

    struct RenderInfo
    {
        ProcessData data;
    };

private:

    AudioUnit                   mAU;
    AudioTimeStamp              mTimeStamp;
    NetSendAUStatusBits         mStatus;
    std::unique_ptr<AUOutputBL> mBufferList;
    RenderInfo                  mRenderInfo;

    double                      mSampleRate;
    int32                       mMaxSamplesPerBlock;
    int32                       mNumChannels;
};

GV_NAMESPACE_END

#endif /* defined(__VST3NetSend__NetSendAU__) */
