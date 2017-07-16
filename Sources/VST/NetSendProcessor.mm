//
//  Processor.cpp
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#import "NetSendParameters.h"
#import "NetSendProcessor.h"
#import "pluginterfaces/base/ustring.h"
#import "pluginterfaces/vst/ivstparameterchanges.h"
#import <AppKit/AppKit.h>
#import <VST3NetSendKit/VST3NetSendKit-Swift.h>

GV_NAMESPACE_BEGIN

NetSendProcessor::NetSendProcessor ()
: AudioEffect()
, mNetSendAU([[NetSendAU alloc] init])
, mTimer(nullptr)
, mBufferList(nullptr)
{
   setControllerClass(NetSendControllerUID);
}

NetSendProcessor::~NetSendProcessor ()
{
   if (mTimer != nullptr) {
      mTimer->release();
      mTimer = nullptr;
   }
   if (mBufferList != nullptr) {
      delete [] (Byte *)mBufferList;
   }
}

#pragma mark VST3 SDK methods

tresult PLUGIN_API NetSendProcessor::initialize (FUnknown* context) {
   tresult result = AudioEffect::initialize(context);
   if (result == kResultTrue)
   {
      addAudioInput(STR16("Audio In"), SpeakerArr::kStereo);
      addAudioOutput(STR16("Audio Out"), SpeakerArr::kStereo);
   }
   assert(result == kResultTrue);
   return result;
}

tresult PLUGIN_API NetSendProcessor::terminate () {
   tresult result = AudioEffect::terminate();
   assert(result == kResultOk);
   return result;
}

tresult PLUGIN_API NetSendProcessor::setActive (TBool state) {
   SpeakerArrangement arr;
   if (getBusArrangement(kOutput, 0, arr) != kResultTrue) {
      return kResultFalse;
   }
   
   int32 numChannels = SpeakerArr::getChannelCount(arr);
   if (numChannels == 0) {
      return kResultFalse;
   }
   
   [mNetSendAU setActive: state];
   
   if (state) {   // Became Active
      if (mTimer == nullptr) {
         mTimer = Timer::create(this, 500); // 500ms 2Hz
         onTimer(mTimer);                   // Forsing callback method call.
      }
   }
   else {   // Became inactive
      if (mTimer != nullptr) {
         mTimer->release();
         mTimer = nullptr;
      }
   }
   
   return AudioEffect::setActive(state);
}

tresult PLUGIN_API NetSendProcessor::setState (IBStream* state) {
   NetSendProcessorState gps;
   tresult result = gps.setState(state);
   if (result == kResultTrue) {
      mParams = gps;
      [mNetSendAU setTransmissionFormatIndex: (UInt32)mParams.dataFormat];
      [mNetSendAU setPortNumber: (UInt32)mParams.port];
      NSString *serviceName = [NSString stringWithUTF8String:mParams.bonjourName];
      [mNetSendAU setServiceName:serviceName];
      NSString *password = [NSString stringWithUTF8String:mParams.password];
      [mNetSendAU setPassword:password];
      [mNetSendAU setDisconnect:mParams.connectionFlag];
   }
   return result;
}

tresult PLUGIN_API NetSendProcessor::getState (IBStream* state)
{
   return mParams.getState(state);
}

tresult PLUGIN_API NetSendProcessor::notify (IMessage* message)
{
   if (message == nullptr) {
      return kInvalidArgument;
   }
   
   if (!strcmp(message->getMessageID(), kGVDataFormatMsgId)) {
      int64 value = 0;
      if (message->getAttributes()->getInt(kGVDataFormatMsgId, value) == kResultOk) {
         mParams.dataFormat = value;
         [mNetSendAU setTransmissionFormatIndex: (UInt32)mParams.dataFormat];
         return kResultOk;
      }
   }
   
   if (!strcmp(message->getMessageID(), kGVPortMsgId)) {
      int64 value = 0;
      if (message->getAttributes()->getInt(kGVPortMsgId, value) == kResultOk) {
         mParams.port = value;
         [mNetSendAU setPortNumber: (UInt32)mParams.port];
         return kResultOk;
      }
   }
   
   if (!strcmp(message->getMessageID(), kGVBonjourNameMsgId)) {
      String128 string;
      UString   s(string, tStrBufferSize(String128));
      if (message->getAttributes()->getString(kGVBonjourNameMsgId, string, tStrBufferSize(String128)) == kResultOk) {
         memset(mParams.bonjourName, 0, 128);
         s.toAscii(const_cast<char*>(mParams.bonjourName), 128);
         NSString *serviceName = [NSString stringWithUTF8String:mParams.bonjourName];
         [mNetSendAU setServiceName:serviceName];
         return kResultOk;
      }
   }
   
   if (!strcmp(message->getMessageID(), kGVPasswordMsgId)) {
      String128 string;
      UString   s(string, tStrBufferSize(String128));
      if (message->getAttributes()->getString(kGVPasswordMsgId, string, tStrBufferSize(String128)) == kResultOk) {
         memset(mParams.password, 0, 128);
         s.toAscii(const_cast<char*>(mParams.password), 128);
         NSString *password = [NSString stringWithUTF8String:mParams.password];
         [mNetSendAU setPassword:password];
         return kResultOk;
      }
   }
   
   return AudioEffect::notify(message);
}

tresult PLUGIN_API NetSendProcessor::setupProcessing(ProcessSetup& setup) {
   NetSendProcessSetup *nsSetup = [[NetSendProcessSetup alloc] initWithSampleRate:setup.sampleRate
                                                             maxSamplesPerBlock:setup.maxSamplesPerBlock];
   [mNetSendAU setupProcessing:nsSetup];
   return AudioEffect::setupProcessing(setup);
}

tresult PLUGIN_API NetSendProcessor::setBusArrangements(SpeakerArrangement* inputs, int32 numIns,
                                                        SpeakerArrangement* outputs, int32 numOuts) {
   
   if ( !(numIns == 1 && numOuts == 1) ) {  // checking one input and one output bus
      return kResultFalse;
   }
   
   if ( !(inputs[0] == outputs[0]) ) { // checking that buses must have the same number of channels
      return kResultFalse;
   }
   
   int32 numChannels = SpeakerArr::getChannelCount(inputs[0]);
   // Original AU support 1x1 and up to 8x8 channels, but not support 3x3 (auval -64 -v aufx nsnd appl)
   if (numChannels > 0 && numChannels <= 8 && numChannels != 3) {
      [mNetSendAU setNumberOfChannels:numChannels];
      if (mBufferList != nullptr) {
         delete [] (Byte *)mBufferList;
      }
      mBufferList = reinterpret_cast<AudioBufferList*>(new Byte[offsetof(AudioBufferList, mBuffers) + (numChannels * sizeof(AudioBuffer))]);
      return AudioEffect::setBusArrangements(inputs, numIns, outputs, numOuts);
   }
   
   return kResultFalse;
}

tresult PLUGIN_API NetSendProcessor::process (ProcessData& data) {
   
   // Parameter changes
   IParameterChanges* paramChanges = data.inputParameterChanges;
   if (paramChanges) {
      updateParameters(paramChanges);
   }
   
   if (data.numInputs == 0 || data.numOutputs == 0) {
      return kResultOk; // nothing to do
   }
   
   // (simplification) we suppose in this example that we have the same input channel count than the output
   int32      numChannels  = data.inputs[0].numChannels;
   int32      sampleFrames = data.numSamples;
   
   Sample32** in           = data.inputs[0].channelBuffers32;
   Sample32** out          = data.outputs[0].channelBuffers32;
   
   //---check if silence---------------
   // normally we have to check each channel (simplification)
   if (data.inputs[0].silenceFlags != 0)
   {
      data.outputs[0].silenceFlags = data.inputs[0].silenceFlags; // mark output silence too
      
      // the Plug-in has to be sure that if it sets the flags silence that the output buffer are clear
      for (int32 i = 0; i < numChannels; i++)
      {
         if (in[i] != out[i]) // dont need to be cleared if the buffers are the same (in this case input buffer are already cleared by the host)
         {
            memset(out[i], 0, sampleFrames * sizeof (Sample32));
         }
      }
      return kResultOk; // nothing to do at this point
   }
   // data.outputs[0].silenceFlags = 0; // mark our outputs has not silent
   data.outputs[0].silenceFlags = data.inputs[0].silenceFlags; // transfer silence flags
   
   if (mParams.bypass == 1) {
      processBypass(data);
   } else {
      processBypass(data); // Bypassing, because our plugin does not do anything with signal
      mBufferList->mNumberBuffers = numChannels;
      AudioBuffer *buf = &mBufferList->mBuffers[0];
      for (int32 i = 0; i < numChannels; i++, ++buf) {
         buf->mNumberChannels = 1;
         buf->mDataByteSize = sampleFrames * sizeof (Sample32);
         buf->mData = in[i];
      }
      [mNetSendAU renderWithNumberOfFrames:sampleFrames bufferList:mBufferList];
   }
   
   return kResultTrue;
}

#pragma mark Helper methods

void NetSendProcessor::updateParameters (IParameterChanges* paramChanges) {
   
   int32 numParamsChanged = paramChanges->getParameterCount();
   // for each parameter which are some changes in this audio block:
   for (int32 i = 0; i < numParamsChanged; i++) {
      IParamValueQueue* paramQueue = paramChanges->getParameterData(i);
      if (!paramQueue)
         continue;
      
      int32             offsetSamples;
      ParamValue        value;
      int32             numPoints = paramQueue->getPointCount();
      switch (paramQueue->getParameterId())
      {
         case kGVBypassParameter:
            if (paramQueue->getPoint(numPoints - 1, offsetSamples, value) == kResultTrue) {
               mParams.bypass = (value > 0.5f) ? 1 : 0;
            }
            break;
            
         case kGVConnectionFlagParameter:
            if (paramQueue->getPoint(numPoints - 1, offsetSamples, value) == kResultTrue) {
               mParams.connectionFlag = (value > 0.5f) ? 1 : 0;
               [mNetSendAU setDisconnect:mParams.connectionFlag];
            }
            break;
      }
   }
}

void NetSendProcessor::processBypass (ProcessData& data) {
   
   Sample32** in           = data.inputs[0].channelBuffers32;
   Sample32** out          = data.outputs[0].channelBuffers32;
   int32      sampleFrames = data.numSamples;
   int32      numChannels  = data.inputs[0].numChannels;
   
   for (int32 i = 0; i < numChannels; i++) {
      // dont need to be copied if the buffers are the same
      if (in[i] != out[i]) {
         memcpy(out[i], in[i], sampleFrames * sizeof (float));
      }
   }
}

// Thread: Main
void NetSendProcessor::onTimer (Timer* timer) {
   
   OPtr<IMessage> message = allocateMessage();
   if (message) {
      long status = [mNetSendAU getStatus];
      message->setMessageID(kGVStatusMsgId);
      message->getAttributes()->setInt(kGVStatusMsgId, status);
      sendMessage(message);
   }
}

GV_NAMESPACE_END
