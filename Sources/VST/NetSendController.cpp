//
//  NetSendController.cpp
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#include "NetSendController.h"
#include "NetSendParameters.h"
#include <assert.h>

GV_NAMESPACE_BEGIN

NetSendController::NetSendController()
: EditController()
, mView(nullptr) {
}

NetSendController::~NetSendController() {
   mView = nullptr;
}

tresult PLUGIN_API NetSendController::initialize (FUnknown* context) {
   tresult result = EditController::initialize(context);
   if (result != kResultTrue) {
      return result;
   }
   
   parameters.addParameter(STR16("Bypass"), 0, 1, 0, ParameterInfo::kCanAutomate | ParameterInfo::kIsBypass, NetSendParameters::kGVBypassParameter);
   parameters.addParameter(STR16("Disconnect"), 0, 1, 0, ParameterInfo::kCanAutomate, NetSendParameters::kGVConnectionFlagParameter);
   
   return kResultTrue;
}

IPlugView * PLUGIN_API NetSendController::createView (FIDString name) {
   if (ConstString(name) == ViewType::kEditor) {
      mView = new NetSendView(this);
      assert(mView != nullptr);
      return mView;
   }
   return 0;
}

tresult PLUGIN_API NetSendController::setComponentState (IBStream* state) {
   NetSendProcessorState gps;
   tresult result = gps.setState(state);
   if (result == kResultTrue) {
      mParams = gps;
      setParamNormalized(kGVConnectionFlagParameter, gps.connectionFlag);
      if (mView != nullptr) {
         mView->handleStateChanges(gps);
      }
   }
   return result;
}

tresult PLUGIN_API NetSendController::setParamNormalized (ParamID tag, ParamValue value) {
   tresult result = EditController::setParamNormalized(tag, value);
   if (mView != nullptr) {
      mView->notifyParameterChanges(tag);
   }
   return result;
}


void NetSendController::editorAttached (EditorView* editor) {
   assert(mView != nullptr);
   mView->notifyParameterChanges(kGVConnectionFlagParameter);
   mView->handleStateChanges(mParams);
}

void NetSendController::editorRemoved (EditorView* editor) {
   
}

void NetSendController::editorDestroyed (EditorView* editor) {
   mView = nullptr;
}

tresult PLUGIN_API NetSendController::notify (IMessage* message) {

   if (message == nullptr) {
      return kInvalidArgument;
   }
   
   if (mView == nullptr) {
      return kNotInitialized;
   }
   
   if (!strcmp(message->getMessageID(), kGVStatusMsgId)) {
      int64 value = 0;
      if (message->getAttributes()->getInt(kGVStatusMsgId, value) == kResultOk) {
         mView->setConnectionStatus(value);
         return kResultOk;
      }
   }
   
   return EditController::notify(message);
}

GV_NAMESPACE_END
