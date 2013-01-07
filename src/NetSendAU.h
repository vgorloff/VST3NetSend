//
//  NetSendAU.h
//  VST3NetSend
//
//  Created by Vlad Gorloff on 07.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#ifndef __VST3NetSend__NetSendAU__
#define __VST3NetSend__NetSendAU__

GV_NAMESPACE_BEGIN

class NetSendAU {

public:
    enum ComponentStatus
    {
        kUnknown = -1,
        kInitialized,
        kActive,
        kErrorsPresent
    };

    struct RenderInfo
    {
        ProcessData data;
    };

public:
    NetSendAU();
    virtual ~NetSendAU();

    NetSendAU& operator=(const NetSendAU&) = delete;
    NetSendAU(const NetSendAU&) = delete;
    NetSendAU& operator=(NetSendAU&&) = delete;
    NetSendAU(NetSendAU&&) = delete;

    void SetupProcessing (ProcessSetup& setup);
    void SetActive (TBool state);
    void SetNumChannels(UInt32 numChannels);
    void Render(ProcessData& data);

private:

    static OSStatus NetSendRenderer( void* ref, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 frames, AudioBufferList *ioData );

    static OSStatus VST3Renderer( void* ref, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 frames, AudioBufferList *ioData );
    
    void setupDefaultParameters();
    void setupStreamFormat(float sampleRate, UInt32 blockSize, UInt32 numChannels);
    void setupRenderCallback();
    
private:
    
    AudioUnit               mAU;
    AudioTimeStamp mTimeStamp;
    ComponentStatus mStatus;
    std::unique_ptr<AUOutputBL> mBufferList;
    RenderInfo mRenderInfo;

    double mSampleRate;
    int32 mMaxSamplesPerBlock;
    int32 mNumChannels;
};

GV_NAMESPACE_END

#endif /* defined(__VST3NetSend__NetSendAU__) */
