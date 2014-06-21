//
//  NetSendAU.cpp
//  VST3NetSend
//
//  Created by Vlad Gorloff on 07.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

GV_NAMESPACE_BEGIN

#define CheckConditionAndLogError(condition, message) if (condition == false) { assert(condition); GVLogError(message); }
#define CheckConditionAndReturnOnError(condition) if (condition == false) { mStatus = kErrorsPresent; return; }

#define CheckStatusAndLogError(status, message) CheckConditionAndLogError(status == noErr, message)
#define CheckStatusAndReturnOnError(status) CheckConditionAndReturnOnError(status == noErr)

#define VerifyStatusBitAndReturnOnError(bit) assert(mStatus & bit); if ((mStatus & bit) == false) {return; }

#define WarnSetProperty "Unable to set AUNetSend property"
#define WarnGetProperty "Unable to get AUNetSend property"

NetSendAU::NetSendAU ()
    : mAU(nullptr)
    , mStatus(kUnknown)
{
    OSStatus                  status;
    AudioComponent            component;

    AudioComponentDescription desc;
    desc.componentType         = kAudioUnitType_Effect;
    desc.componentSubType      = kAudioUnitSubType_NetSend;
    desc.componentManufacturer = kAudioUnitManufacturer_Apple;
    desc.componentFlags        = 0;
    desc.componentFlagsMask    = 0;

    component                  = AudioComponentFindNext(NULL, &desc);
    CheckConditionAndLogError(component != nullptr, "Unable to find AUNetSend component");
    CheckConditionAndReturnOnError(component != nullptr);

    status = AudioComponentInstanceNew(component, &mAU);
    CheckStatusAndLogError(status, "Unable to create AUNetSend instance");
    CheckStatusAndReturnOnError(status);

    mStatus                = kInitialized;

    mTimeStamp.mFlags      = kAudioTimeStampSampleTimeValid;
    mTimeStamp.mSampleTime = 0;

    mMaxSamplesPerBlock    = 512;
    mSampleRate            = 44100;
    mNumChannels           = 2;

    CAStreamBasicDescription streamFormat;
    streamFormat.SetAUCanonical(mNumChannels, false);
    streamFormat.mSampleRate = mSampleRate;
    mBufferList.reset(new AUOutputBL(streamFormat, mMaxSamplesPerBlock));

    // Default parameters
    setTransmissionFormatIndex(kAUNetSendPresetFormat_PCMFloat32);
    setPortNum(52800);
    setServiceName(GV_PLUGIN_NAME);
    setPassword("");

    setupStreamFormat(streamFormat.mSampleRate, mMaxSamplesPerBlock, mNumChannels);
    setupRenderCallback();
}

NetSendAU::~NetSendAU ()
{
    OSStatus status;

    SetActive(0);
    status = AudioComponentInstanceDispose(mAU);
    CheckStatusAndLogError(status, "Unable to dispose AUNetSend instance");

    mStatus = kUnknown;
}

void NetSendAU::setPortNum (UInt32 port)
{
    VerifyStatusBitAndReturnOnError(kInitialized);
    OSStatus status = AudioUnitSetProperty(mAU, kAUNetSendProperty_PortNum, kAudioUnitScope_Global, 0, &port, sizeof(port));
    CheckStatusAndLogError(status, WarnSetProperty "PortNum");
    CheckStatusAndReturnOnError(status);
}

void NetSendAU::setServiceName (const char* name)
{
    VerifyStatusBitAndReturnOnError(kInitialized);
    CFStringRef serviceName = CFStringCreateWithCString(kCFAllocatorDefault, name, kCFStringEncodingASCII);
    assert(serviceName != nullptr);
    OSStatus    status      = AudioUnitSetProperty(mAU, kAUNetSendProperty_ServiceName, kAudioUnitScope_Global, 0, &serviceName, sizeof(CFStringRef));
    CheckStatusAndLogError(status, WarnSetProperty "ServiceName");
    CheckStatusAndReturnOnError(status);
}

void NetSendAU::setPassword (const char* pwd)
{
    VerifyStatusBitAndReturnOnError(kInitialized);
    CFStringRef password = CFStringCreateWithCString(kCFAllocatorDefault, pwd, kCFStringEncodingASCII); // Empty password
    assert(password != nullptr);
    OSStatus    status   = AudioUnitSetProperty(mAU, kAUNetSendProperty_Password, kAudioUnitScope_Global, 0, &password, sizeof(CFStringRef));
    CheckStatusAndLogError(status, WarnSetProperty "Password");
    CheckStatusAndReturnOnError(status);
}

void NetSendAU::setTransmissionFormatIndex (UInt32 format)
{
    VerifyStatusBitAndReturnOnError(kInitialized);

    CheckConditionAndLogError(format >= 0 && format < kAUNetSendNumPresetFormats, "Incorrect TransmissionFormatIndex");
    CheckConditionAndReturnOnError(format >= 0 && format < kAUNetSendNumPresetFormats);

    OSStatus status = AudioUnitSetProperty(mAU, kAUNetSendProperty_TransmissionFormatIndex, kAudioUnitScope_Global, 0, &format, sizeof(format));
    CheckStatusAndLogError(status, WarnSetProperty "TransmissionFormatIndex");
    CheckStatusAndReturnOnError(status);
}

void NetSendAU::setDisconnect (UInt32 flag)
{
    VerifyStatusBitAndReturnOnError(kInitialized);
    OSStatus status = AudioUnitSetProperty(mAU, kAUNetSendProperty_Disconnect, kAudioUnitScope_Global, 0, &flag, sizeof(flag));
    CheckStatusAndLogError(status, WarnSetProperty "Disconnect");
    CheckStatusAndReturnOnError(status);
}

long NetSendAU::getStatus ()
{
    Float32 result = -1;
    assert(mStatus & kInitialized);
    if ((mStatus & kInitialized) == false) {
        return result;
    }

    OSStatus err = AudioUnitGetParameter(mAU, kAUNetSendParam_Status, kAudioUnitScope_Global, 0, &result);
    CheckConditionAndLogError(err == noErr, "Unable to get connection status");
    return result;
}

void NetSendAU::SetupProcessing (ProcessSetup& setup)
{
    VerifyStatusBitAndReturnOnError(kInitialized);
    mSampleRate         = setup.sampleRate;
    mMaxSamplesPerBlock = setup.maxSamplesPerBlock;
    setupStreamFormat(mSampleRate, mMaxSamplesPerBlock, mNumChannels);
}

void NetSendAU::SetNumChannels (UInt32 numChannels)
{
    VerifyStatusBitAndReturnOnError(kInitialized);
    mNumChannels = numChannels;
    setupStreamFormat(mSampleRate, mMaxSamplesPerBlock, mNumChannels);
}

void NetSendAU::SetActive (TBool state)
{
    VerifyStatusBitAndReturnOnError(kInitialized);

    OSStatus status;

    if (state) // Became Active
    {
        if (mStatus & kActive) {
            return; // Already active
        }
        status = AudioUnitInitialize(mAU);
        CheckStatusAndLogError(status, "Unable to initialize AUNetSend instance");
        CheckStatusAndReturnOnError(status);
        mStatus |= kActive;
    }
    else // Became inactive
    {
        if ((mStatus & kActive) == false) {
            return; // Already inactive
        }
        status = AudioUnitUninitialize(mAU);
        CheckStatusAndLogError(status, "Unable to uninitialize AUNetSend instance");
        CheckStatusAndReturnOnError(status);
        mStatus &= ~kActive;
    }
}

void NetSendAU::setupStreamFormat (float sampleRate, UInt32 blockSize, UInt32 numChannels)
{
    VerifyStatusBitAndReturnOnError(kInitialized);

    UInt32                      propertySize = sizeof(AudioStreamBasicDescription);
    OSStatus                    status = noErr;

    AudioStreamBasicDescription asbd = {0};
    status = AudioUnitGetProperty(mAU, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &asbd, &propertySize);
    CheckStatusAndLogError(status, WarnGetProperty "StreamFormat");
    CheckStatusAndReturnOnError(status);

    CAStreamBasicDescription streamFormat(asbd);
    bool                     isInterleaved = streamFormat.IsInterleaved();
    CheckConditionAndLogError(isInterleaved == false, "Format with interleaved channels not supported");
    CheckConditionAndReturnOnError(isInterleaved == false);

    streamFormat.mSampleRate = sampleRate;
    streamFormat.ChangeNumberChannels(numChannels, false);
    asbd                     = (AudioStreamBasicDescription)streamFormat;
    propertySize             = sizeof(AudioStreamBasicDescription);
    status                   = AudioUnitSetProperty(mAU, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &asbd, propertySize);
    CheckStatusAndLogError(status, WarnSetProperty "StreamFormat");
    CheckStatusAndReturnOnError(status);

    status = AudioUnitSetProperty(mAU, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &asbd, propertySize);
    CheckStatusAndLogError(status, WarnSetProperty "StreamFormat");
    CheckStatusAndReturnOnError(status);

    // Setting up buffers
    CAStreamBasicDescription existingFormat = mBufferList->GetFormat();
    if (existingFormat != streamFormat) {
        mBufferList.reset(new AUOutputBL(streamFormat, blockSize));
    }
    mBufferList->Allocate(blockSize);
    mBufferList->Prepare();
}

void NetSendAU::setupRenderCallback ()
{
    VerifyStatusBitAndReturnOnError(kInitialized);

    AURenderCallbackStruct callback;
    OSStatus               status;

    callback.inputProc       = NetSendRenderer;
    callback.inputProcRefCon = &mRenderInfo;

    status                   = AudioUnitSetProperty(mAU, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &callback, sizeof(callback) );
    CheckStatusAndLogError(status, WarnSetProperty "SetRenderCallback");
}

void NetSendAU::Render (ProcessData& data)
{
    VerifyStatusBitAndReturnOnError(kActive);

    AudioUnitRenderActionFlags actionFlags;
    OSStatus                   status;

    mRenderInfo.data        = data;
    actionFlags             = 0;
    mBufferList->Prepare(data.numSamples);
    status                  = AudioUnitRender(mAU, &actionFlags, &mTimeStamp, 0, data.numSamples, mBufferList->ABL());
    assert(status == noErr);
    mTimeStamp.mSampleTime += data.numSamples;
}

OSStatus NetSendAU::NetSendRenderer (void* ref, AudioUnitRenderActionFlags* ioActionFlags, const AudioTimeStamp* inTimeStamp, UInt32 inBusNumber, UInt32 frames, AudioBufferList* ioData)
{
    NetSendAU::RenderInfo* info            = (NetSendAU::RenderInfo*)ref;
    ProcessData            data            = info->data;
    AudioBusBuffers        mainInputBuffer = data.inputs[0];
    int32                  numChannels     = mainInputBuffer.numChannels;
    Sample32**             chData          = mainInputBuffer.channelBuffers32;

    assert(numChannels == ioData->mNumberBuffers);
    if (numChannels != ioData->mNumberBuffers) {
        return kAudioUnitErr_FormatNotSupported;
    }

    for (int i = 0; i < numChannels; i++)
    {
        assert(ioData->mBuffers[i].mNumberChannels == 1); // Only non-interleaved formats supported.
        if (ioData->mBuffers[i].mNumberChannels != 1) {
            return kAudioUnitErr_FormatNotSupported;
        }
        memcpy(ioData->mBuffers[i].mData, chData[i], ioData->mBuffers[i].mDataByteSize);
    }

    return noErr;
}

GV_NAMESPACE_END
