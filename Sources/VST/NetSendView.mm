//
//  NetSendView.mm
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#import "NetSendView.h"
#import "NetSendParameters.h"
#import "NetSendController.h"
#import "pluginterfaces/base/ustring.h"
#import <CoreAudio/CoreAudio.h>
#import <AppKit/AppKit.h>
#import <VST3NetSendUI/VST3NetSendUI-Swift.h>

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

   NSBundle* UIFrameworkBundle = [NSBundle bundleForClass:NetSendViewController.class];
   NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"VST3NetSend" bundle:UIFrameworkBundle];
   mViewController = [storyboard instantiateInitialController];
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

   tresult result = CPluginView::attached(ptr, type);
   assert(result == kResultOk);
   return result;
}

tresult PLUGIN_API NetSendView::removed () {
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
         EditController *editController = getController();
         ParamValue normValue = editController->getParamNormalized(index);
         NSNumber* connectionFlag = (normValue > 0.5f) ? [NSNumber numberWithBool:TRUE]: [NSNumber numberWithBool:FALSE];
         if ([connectionFlag compare:mViewController.viewModel.connectionFlag] != NSOrderedSame) { // Preverting infinite loop
            editController->beginEdit(kGVConnectionFlagParameter);
            editController->setParamNormalized(kGVConnectionFlagParameter, normValue);
            editController->performEdit(kGVConnectionFlagParameter, normValue);
            mViewController.viewModel.connectionFlag = connectionFlag;
            editController->endEdit(kGVConnectionFlagParameter);
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

   EditController *editController = getController();

   NSNumber* dataFormat  = [NSNumber numberWithInt:state.dataFormat];
   NSNumber* port        = [NSNumber numberWithLong:state.port];
   NSString* bonjourName = [NSString stringWithUTF8String:state.bonjourName];
   NSString* password    = [NSString stringWithUTF8String:state.password];
   
   if ([dataFormat compare:mViewController.viewModel.dataFormat] != NSOrderedSame) {
      mViewController.viewModel.dataFormat = dataFormat;
      OPtr<IMessage> message = editController->allocateMessage();
      if (message) {
         message->setMessageID(kGVDataFormatMsgId);
         message->getAttributes()->setInt(kGVDataFormatMsgId, dataFormat.longValue);
         editController->sendMessage(message);
      }
   }
   if ([port compare:mViewController.viewModel.port] != NSOrderedSame) {
      mViewController.viewModel.port = port;
      OPtr<IMessage> message = editController->allocateMessage();
      if (message) {
         message->setMessageID(kGVPortMsgId);
         message->getAttributes()->setInt(kGVPortMsgId, port.longValue);
         editController->sendMessage(message);
      }
   }
   if ([bonjourName compare:mViewController.viewModel.bonjourName] != NSOrderedSame) {
      mViewController.viewModel.bonjourName = bonjourName;
      OPtr<IMessage> message = editController->allocateMessage();
      if (message) {
         String128 string;
         UString(string, tStrBufferSize(String128)).fromAscii ([bonjourName UTF8String]);
         message->setMessageID(kGVBonjourNameMsgId);
         message->getAttributes()->setString(kGVBonjourNameMsgId, string);
         editController->sendMessage(message);
      }
   }
   if ([password compare:mViewController.viewModel.password] != NSOrderedSame) {
      mViewController.viewModel.password = password;
      OPtr<IMessage> message = editController->allocateMessage();
      if (message) {
         String128 string;
         UString(string, tStrBufferSize(String128)).fromAscii ([password UTF8String]);
         message->setMessageID(kGVPasswordMsgId);
         message->getAttributes()->setString(kGVPasswordMsgId, string);
         editController->sendMessage(message);
      }
   }
}

GV_NAMESPACE_END
