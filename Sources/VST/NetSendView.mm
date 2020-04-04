//
//  NetSendView.mm
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#import "NetSendController.h"
#import "NetSendParameters.h"
#import "NetSendView.h"
#import "pluginterfaces/base/ustring.h"
#import <AppKit/AppKit.h>
#import <CoreAudio/CoreAudio.h>
#import <VST3NetSendKit/VST3NetSendKit-Swift.h>

NSRect NSRectFromVSTViewRect(Steinberg::ViewRect rect) {
   NSRect result = NSMakeRect(rect.left, rect.top, rect.getWidth(), rect.getHeight());
   return result;
}

Steinberg::ViewRect VSTViewRectFromNSRect(NSRect rect) {
   Steinberg::ViewRect result = Steinberg::ViewRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
   return result;
}

GV_NAMESPACE_BEGIN

NetSendView::NetSendView (EditController* controller, ViewRect* rectSize)
: EditorView(controller, rectSize) {

   mView = [[NetSendUI alloc] init];
   mView.needsLayout = true;
   [mView layoutSubtreeIfNeeded];
   NSSize size = mView.fittingSize;
   Steinberg::ViewRect rect = Steinberg::ViewRect(getRect().left, getRect().top, size.width, size.height);
   setRect(rect);
}

NetSendView::~NetSendView () {
   mView = nil;
}

tresult PLUGIN_API NetSendView::attached (void* ptr, Steinberg::FIDString type) {
   if (isPlatformTypeSupported(type) != Steinberg::kResultTrue) {
      return Steinberg::kResultFalse;
   }

   NSView *superview = (__bridge NSView*)ptr;
   [superview addSubview:mView]; // view initialised lazy
   NSRect frame = NSRectFromVSTViewRect(getRect());
   [mView setFrame:frame];

   mView.modelChangeHandler = ^(enum NetSendParameter sourceID) {
      this->handleViewModelChanges(int(sourceID));
   };

   tresult result = CPluginView::attached(ptr, type);
   assert(result == kResultOk);
   return result;
}

tresult PLUGIN_API NetSendView::removed () {
   mView.modelChangeHandler = nil;
   [mView removeFromSuperviewWithoutNeedingDisplay];
   Steinberg::tresult result = CPluginView::removed();
   assert(result == kResultOk);
   return result;
}

tresult PLUGIN_API NetSendView::isPlatformTypeSupported (Steinberg::FIDString type) {
   if (strcmp(type, Steinberg::kPlatformTypeNSView) == 0) {
      return Steinberg::kResultTrue;
   }
   
   return Steinberg::kInvalidArgument;
}

void NetSendView::notifyParameterChanges (unsigned int index) {
   switch (index) {
      case kGVConnectionFlagParameter: {
         ParamValue normValue = getController()->getParamNormalized(index);
         mView.connectionFlag = normValue;
         break;
      }
   }
}

void NetSendView::setConnectionStatus(int64 stat) {
   mView.status = stat;
}

void NetSendView::handleStateChanges (const NetSendProcessorState& state) {

   NSNumber* dataFormat  = [NSNumber numberWithInt:state.dataFormat];
   NSNumber* port        = [NSNumber numberWithLong:state.port];
   NSString* bonjourName = [NSString stringWithUTF8String:state.bonjourName];
   NSString* password    = [NSString stringWithUTF8String:state.password];
   
   if ([dataFormat compare:mView.viewModel.dataFormat] != NSOrderedSame) {
      mView.viewModel.dataFormat = dataFormat;
   }
   if ([port compare:mView.viewModel.port] != NSOrderedSame) {
      mView.viewModel.port = port;
   }
   if ([bonjourName compare:mView.viewModel.bonjourName] != NSOrderedSame) {
      mView.viewModel.bonjourName = bonjourName;
   }
   mView.password = password;
}

void NetSendView::handleViewModelChanges(int sourceID) {
   NetSendParameter source = (NetSendParameter)sourceID;
   NetSendViewModel *model = mView.viewModel;
   EditController *editController = getController();
   OPtr<IMessage> message = editController->allocateMessage();
   if (message) {

      switch (source) {
         case NetSendParameterDataFormat: {
            message->setMessageID(kGVDataFormatMsgId);
            message->getAttributes()->setInt(kGVDataFormatMsgId, model.dataFormat.longValue);
            editController->sendMessage(message);
            break;
         }
         case NetSendParameterPort: {
            message->setMessageID(kGVPortMsgId);
            message->getAttributes()->setInt(kGVPortMsgId, model.port.longValue);
            editController->sendMessage(message);
            break;
         }
         case NetSendParameterBonjourName: {
            String128 string;
            NSString *bonjourName = model.bonjourName ? model.bonjourName : @"";
            UString(string, tStrBufferSize(String128)).fromAscii ([bonjourName UTF8String]);
            message->setMessageID(kGVBonjourNameMsgId);
            message->getAttributes()->setString(kGVBonjourNameMsgId, string);
            editController->sendMessage(message);
            break;
         }
         case NetSendParameterPassword: {
            String128 string;
            UString(string, tStrBufferSize(String128)).fromAscii ([mView.password UTF8String]);
            message->setMessageID(kGVPasswordMsgId);
            message->getAttributes()->setString(kGVPasswordMsgId, string);
            editController->sendMessage(message);
            break;
         }
         case NetSendParameterConnectionFlag: {
            ParamValue normValue = mView.connectionFlag;
            editController->beginEdit(kGVConnectionFlagParameter);
            editController->setParamNormalized(kGVConnectionFlagParameter, normValue);
            editController->performEdit(kGVConnectionFlagParameter, normValue);
            editController->endEdit(kGVConnectionFlagParameter);
            break;
         }
      }
   }
}

GV_NAMESPACE_END
