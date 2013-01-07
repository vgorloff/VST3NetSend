//
//  NetSendAU.cpp
//  VST3NetSend
//
//  Created by Vlad Gorloff on 07.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//



GV_NAMESPACE_BEGIN

#define CheckConditionAndLogError(condition, message) if(condition == false) { assert (condition); GVLogError(message); }
#define CheckConditionAndReturnOnError(condition) if(condition == false) { mStatus = kErrorsPresent; return; }

#define CheckStatusAndLogError(status, message) CheckConditionAndLogError(status == noErr, message)
#define CheckStatusAndReturnOnError(status) CheckConditionAndReturnOnError (status == noErr) 

#define WarnSetProperty "Unable to set AUNetSend property"
#define WarnGetProperty "Unable to get AUNetSend property"


NetSendAU::NetSendAU()
: mAU(nullptr)
, mStatus(kUnknown)
{
    OSStatus status;
    AudioComponent component;

    AudioComponentDescription desc;
    desc.componentType = kAudioUnitType_Effect;
    desc.componentSubType = kAudioUnitSubType_NetSend;
    desc.componentManufacturer = kAudioUnitManufacturer_Apple;
    desc.componentFlags = 0;
    desc.componentFlagsMask = 0;

    component = AudioComponentFindNext(NULL, &desc);
    CheckConditionAndLogError(component != nullptr, "Unable to find AUNetSend component");
    CheckConditionAndReturnOnError(component != nullptr);
    
    status = AudioComponentInstanceNew(component, &mAU);
    CheckStatusAndLogError(status, "Unable to create AUNetSend instance");
    CheckStatusAndReturnOnError(status);

    mStatus = kInitialized;

    mTimeStamp.mFlags = kAudioTimeStampSampleTimeValid;
	mTimeStamp.mSampleTime = 0;

    mMaxSamplesPerBlock = 512;
    mSampleRate = 44100;
    mNumChannels = 2;

    CAStreamBasicDescription streamFormat;
    streamFormat.SetAUCanonical(mNumChannels, false);
    streamFormat.mSampleRate = mSampleRate;
    mBufferList.reset(new AUOutputBL(streamFormat, mMaxSamplesPerBlock));
    
    setupDefaultParameters();
    setupStreamFormat(streamFormat.mSampleRate, mMaxSamplesPerBlock, mNumChannels);
    setupRenderCallback();

}

NetSendAU::~NetSendAU()
{
    OSStatus status;

    status = AudioComponentInstanceDispose(mAU);
    CheckStatusAndLogError(status, "Unable to dispose AUNetSend instance");

    mStatus = kUnknown;
}

void NetSendAU::setupDefaultParameters()
{
    assert(mStatus == kInitialized);
    if (mStatus != kInitialized) {
        return;
    }

	OSStatus status;
    
	UInt32 format = kAUNetSendPresetFormat_PCMFloat32;
	status = AudioUnitSetProperty( mAU, kAUNetSendProperty_TransmissionFormatIndex, kAudioUnitScope_Global, 0, &format, sizeof(format));
    CheckStatusAndLogError(status, WarnSetProperty "TransmissionFormatIndex");
    CheckStatusAndReturnOnError(status);

    UInt32 port = 52800;
    status = AudioUnitSetProperty(mAU, kAUNetSendProperty_PortNum, kAudioUnitScope_Global, 0, &port, sizeof(port));
    CheckStatusAndLogError(status, WarnSetProperty "PortNum");
    CheckStatusAndReturnOnError(status);

    CFStringRef serviceName = CFStringCreateWithCString(kCFAllocatorDefault, GV_PLUGIN_NAME, kCFStringEncodingASCII);
    assert(serviceName != nullptr);
    status = AudioUnitSetProperty(mAU, kAUNetSendProperty_ServiceName, kAudioUnitScope_Global, 0, &serviceName, sizeof(CFStringRef));
    CheckStatusAndLogError(status, WarnSetProperty "ServiceName");
    CheckStatusAndReturnOnError(status);

    CFStringRef password = CFStringCreateWithCString(kCFAllocatorDefault, "", kCFStringEncodingASCII); // Empty password
    assert(password != nullptr);
    status = AudioUnitSetProperty(mAU, kAUNetSendProperty_Password, kAudioUnitScope_Global, 0, &password, sizeof(CFStringRef));
    CheckStatusAndLogError(status, WarnSetProperty "Password");
    CheckStatusAndReturnOnError(status);
}

void NetSendAU::SetupProcessing (ProcessSetup& setup)
{
    assert(mStatus == kInitialized);
    if (mStatus != kInitialized) {
        return;
    }

    mSampleRate = setup.sampleRate;
    mMaxSamplesPerBlock = setup.maxSamplesPerBlock;
    setupStreamFormat(mSampleRate, mMaxSamplesPerBlock, mNumChannels);
}

void NetSendAU::SetNumChannels(UInt32 numChannels)
{
    assert(mStatus == kInitialized);
    if (mStatus != kInitialized) {
        return;
    }
    
    mNumChannels = numChannels;
    setupStreamFormat(mSampleRate, mMaxSamplesPerBlock, mNumChannels);
}

void NetSendAU::SetActive (TBool state)
{
    assert(mStatus == kInitialized || mStatus == kActive);
    if (! (mStatus == kInitialized || mStatus == kActive)) {
        return;
    }

    OSStatus status;
    
    if (state) // Became Active
    {
        if (mStatus == kActive) {
            return;
        }
        status = AudioUnitInitialize(mAU);
        CheckStatusAndLogError(status, "Unable to initialize AUNetSend instance");
        CheckStatusAndReturnOnError(status);
        mStatus = kActive;
    }
    else // Became inactive
    {
        if (mStatus == kInitialized) {
            return;
        }
        status = AudioUnitUninitialize(mAU);
        CheckStatusAndLogError(status, "Unable to uninitialize AUNetSend instance");
        CheckStatusAndReturnOnError(status);
        mStatus = kInitialized;
    }
}

void NetSendAU::setupStreamFormat(float sampleRate, UInt32 blockSize, UInt32 numChannels)
{
    assert(mStatus == kInitialized);
    if (mStatus != kInitialized) {
        return;
    }

    CAStreamBasicDescription streamFormat;
	UInt32 propertySize ;
	OSStatus status ;

	propertySize = sizeof(CAStreamBasicDescription) ;
	memset(&streamFormat, 0, propertySize ) ;
	status = AudioUnitGetProperty(mAU, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &streamFormat, &propertySize);
    CheckStatusAndLogError(status, WarnGetProperty "StreamFormat");
    CheckStatusAndReturnOnError(status);

    bool isInterleaved = streamFormat.IsInterleaved();
    CheckConditionAndLogError(isInterleaved == false, "Format with interleaved channels not supported");
    CheckConditionAndReturnOnError(isInterleaved == false);

	streamFormat.mSampleRate = sampleRate;
    streamFormat.ChangeNumberChannels(numChannels, isInterleaved);
	status = AudioUnitSetProperty(mAU, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Global, 0, &streamFormat, propertySize) ;
    CheckStatusAndLogError(status, WarnSetProperty "StreamFormat");
    CheckStatusAndReturnOnError(status);

//	status = AudioUnitSetProperty( mAU, kAUNetSendProperty_TransmissionFormat, kAudioUnitScope_Global, 0, &streamFormat, propertySize);
//    CheckStatusAndLogError(status, WarnSetProperty "TransmissionFormat");
//    if (status != noErr) {
//        mStatus = kErrorsPresent;
//        return;
//    }

    // Setting up buffers
    CAStreamBasicDescription existingFormat = mBufferList->GetFormat();
    if (existingFormat != streamFormat) {
        mBufferList.reset(new AUOutputBL(streamFormat, blockSize));
    }
    mBufferList->Allocate(blockSize);
    mBufferList->Prepare();
}


void NetSendAU::setupRenderCallback()
{
    assert(mStatus == kInitialized);
    if (mStatus != kInitialized) {
        return;
    }
    
    AURenderCallbackStruct callback;
	OSStatus status ;

	callback.inputProc = NetSendRenderer;
	callback.inputProcRefCon = &mRenderInfo;

	status = AudioUnitSetProperty( mAU, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &callback, sizeof( callback ) ) ;
	CheckStatusAndLogError(status, WarnSetProperty "SetRenderCallback");
}

void NetSendAU::Render(ProcessData& data)
{
    assert(mStatus == kActive);
    if (mStatus != kActive) {
        return;
    }

    AudioUnitRenderActionFlags actionFlags ;
	OSStatus status ;

    mRenderInfo.data = data;
    actionFlags = 0;
    mBufferList->Prepare(data.numSamples);
    status = AudioUnitRender( mAU, &actionFlags, &mTimeStamp, 0, data.numSamples, mBufferList->ABL());
    assert(status == noErr);
    mTimeStamp.mSampleTime += data.numSamples;
}

OSStatus NetSendAU::NetSendRenderer( void* ref, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 frames, AudioBufferList *ioData )
{
    NetSendAU::RenderInfo* info = (NetSendAU::RenderInfo*)ref;
    ProcessData data = info->data;
    AudioBusBuffers mainInputBuffer = data.inputs[0];
    int32      numChannels  = mainInputBuffer.numChannels;
    Sample32** chData = mainInputBuffer.channelBuffers32;
    
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