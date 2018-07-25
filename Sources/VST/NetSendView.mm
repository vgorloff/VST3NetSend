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
: EditorView(controller, rectSize)
, mViewController(nil) {

   mViewController = [[NetSendViewController alloc] init];
   NSSize size = mViewController.view.frame.size;
   Steinberg::ViewRect rect = Steinberg::ViewRect(getRect().left, getRect().top, size.width, size.height);
   setRect(rect);
}

NetSendView::~NetSendView () {
   mViewController = nil;
}

tresult PLUGIN_API NetSendView::attached (void* ptr, Steinberg::FIDString type) {
   if (isPlatformTypeSupported(type) != Steinberg::kResultTrue) {
      return Steinberg::kResultFalse;
   }

   NSView *superview = (__bridge NSView*)ptr;
   [superview addSubview:mViewController.view]; // view initialised lazy
   NSRect frame = NSRectFromVSTViewRect(getRect());
   [mViewController.view setFrame:frame];

   mViewController.modelChangeHandler = ^(enum NetSendParameter sourceID) {
      this->handleViewModelChanges(sourceID);
   };

   tresult result = CPluginView::attached(ptr, type);
   assert(result == kResultOk);
   return result;
}

tresult PLUGIN_API NetSendView::removed () {
   mViewController.modelChangeHandler = nil;
   [mViewController.view removeFromSuperviewWithoutNeedingDisplay];
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
         NSNumber* connectionFlag = (normValue > 0.5f) ? [NSNumber numberWithBool:TRUE]: [NSNumber numberWithBool:FALSE];
         if ([connectionFlag compare:mViewController.viewModel.connectionFlag] != NSOrderedSame) { // Preverting infinite loop
            mViewController.viewModel.connectionFlag = connectionFlag;
         }
         break;
      }
   }
}

void NetSendView::setConnectionStatus(int64 stat) {
   NSNumber* status = [NSNumber numberWithFloat:stat];
   mViewController.viewModel.status = status;
}

void NetSendView::handleStateChanges (const NetSendProcessorState& state) {

   NSNumber* dataFormat  = [NSNumber numberWithInt:state.dataFormat];
   NSNumber* port        = [NSNumber numberWithLong:state.port];
   NSString* bonjourName = [NSString stringWithUTF8String:state.bonjourName];
   NSString* password    = [NSString stringWithUTF8String:state.password];
   
   if ([dataFormat compare:mViewController.viewModel.dataFormat] != NSOrderedSame) {
      mViewController.viewModel.dataFormat = dataFormat;
   }
   if ([port compare:mViewController.viewModel.port] != NSOrderedSame) {
      mViewController.viewModel.port = port;
   }
   if ([bonjourName compare:mViewController.viewModel.bonjourName] != NSOrderedSame) {
      mViewController.viewModel.bonjourName = bonjourName;
   }
   if ([password compare:mViewController.viewModel.password] != NSOrderedSame) {
      mViewController.viewModel.password = password;
   }
}

void NetSendView::handleViewModelChanges(int sourceID) {
   NetSendParameter source = (NetSendParameter)sourceID;
   NetSendViewModel *model = mViewController.viewModel;
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
            NSString *password = model.password ? model.password : @"";
            UString(string, tStrBufferSize(String128)).fromAscii ([password UTF8String]);
            message->setMessageID(kGVPasswordMsgId);
            message->getAttributes()->setString(kGVPasswordMsgId, string);
            editController->sendMessage(message);
            break;
         }
         case NetSendParameterConnectionFlag: {
            ParamValue normValue = model.connectionFlag.doubleValue;
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
