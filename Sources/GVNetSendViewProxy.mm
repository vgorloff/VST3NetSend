//
//  GVNetSendViewProxy.mm
//  VST3NetSend
//
//  Created by Volodymyr Gorlov on 1/14/13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#ifdef __OBJC__
   #import <Cocoa/Cocoa.h>
#endif
#import <CoreAudio/CoreAudio.h>
#import <VST3NetSendUI/VST3NetSendUI-Swift.h>
#import "GVNetSendViewProxy.h"
#import "pluginterfaces/base/ustring.h"
#import "pluginterfaces/gui/iplugview.h"
#import "NetSendView.h"
#import "NetSendController.h"
#import "CommonDefinitions.h"
#import "NetSendParameters.h"

using namespace Steinberg;
using namespace GV;

@interface GVNetSendViewProxy () {
   NetSendController* _editController;
   GV::NetSendView* _editView;
}

@end

@implementation GVNetSendViewProxy

- (id)initWithView:(void*)parentView {
   self = [super init];
   if (self) {
      _editView  = static_cast<GV::NetSendView*>(parentView);
      _editController = static_cast<NetSendController*>(_editView->getController());
   }
   return self;
}


- (void)dealloc {
   _editView = nullptr;
   _editController = nullptr;
}

-(void)setConnectionFlag:(NSNumber *) value {
   ParamValue valueNormalized = value.doubleValue;
   // Automation routine. See DemoGain vst3 for example.
   _editController->beginEdit(kGVConnectionFlagParameter);
   _editController->setParamNormalized(kGVConnectionFlagParameter, valueNormalized);
   _editController->performEdit(kGVConnectionFlagParameter, valueNormalized);
   _editController->endEdit(kGVConnectionFlagParameter);
}

-(void)setDataFormat:(NSNumber *)value {
   OPtr<IMessage> message = _editController->allocateMessage();
   if (message) {
      message->setMessageID(kGVDataFormatMsgId);
      message->getAttributes()->setInt(kGVDataFormatMsgId, value.longValue);
      _editController->sendMessage(message);
   }
}

-(void)setPort:(NSNumber *)value {
   OPtr<IMessage> message = _editController->allocateMessage();
   if (message) {
      message->setMessageID(kGVPortMsgId);
      message->getAttributes()->setInt(kGVPortMsgId, value.longValue);
      _editController->sendMessage(message);
   }
}

-(void)setBonjourName:(NSString *)value {
   OPtr<IMessage> message = _editController->allocateMessage();
   if (message) {
      String128 string;
      UString(string, tStrBufferSize(String128)).fromAscii ([value UTF8String]);
      message->setMessageID(kGVBonjourNameMsgId);
      message->getAttributes()->setString(kGVBonjourNameMsgId, string);
      _editController->sendMessage(message);
   }
}

-(void)setPassword:(NSString *)value {
   OPtr<IMessage> message = _editController->allocateMessage();
   if (message) {
      String128 string;
      UString(string, tStrBufferSize(String128)).fromAscii ([value UTF8String]);
      message->setMessageID(kGVPasswordMsgId);
      message->getAttributes()->setString(kGVPasswordMsgId, string);
      _editController->sendMessage(message);
   }
}

@end
