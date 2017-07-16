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
   NetSendViewController* _viewController;
   NetSendController* _editController;
   GV::NetSendView* _editView;

   NSNumber* _status;
   NSNumber* _connectionFlag;
   NSNumber* _dataFormat;
   NSNumber* _port;
   NSString* _bonjourName;
   NSString* _password;
}

@end

@implementation GVNetSendViewProxy

- (id)initWithView:(void*)parentView {
   self = [super init];
   if (self) {
      _status = @0;
      _connectionFlag = @0;
      _dataFormat = @0;
      _port = @0;
      _bonjourName = @"";
      _password = @"";

      _editView  = static_cast<GV::NetSendView*>(parentView);
      _editController = static_cast<NetSendController*>(_editView->getController());
      _viewController = _editView->mViewController;

      [self setupBindings];
   }
   return self;
}


- (void)dealloc {
   [self removeBindings];
   _viewController = nil;
   _editView = nullptr;
   _editController = nullptr;

   _status = nil;
   _connectionFlag = nil;
   _dataFormat = nil;
   _port = nil;
   _bonjourName = nil;
   _password = nil;
}

-(void)setupBindings {
   NSDictionary* bindingOptions = [NSDictionary dictionaryWithObject:@"" forKey:NSNullPlaceholderBindingOption];
   [self bind:@"status" toObject:_viewController.viewModelObjectController withKeyPath:@"selection.status" options:nil];
   [self bind:@"connectionFlag" toObject:_viewController.viewModelObjectController withKeyPath:@"selection.connectionFlag" options:nil];
   [self bind:@"dataFormat" toObject:_viewController.viewModelObjectController withKeyPath:@"selection.dataFormat" options:nil];
   [self bind:@"port" toObject:_viewController.viewModelObjectController withKeyPath:@"selection.port" options:nil];
   [self bind:@"bonjourName" toObject:_viewController.viewModelObjectController withKeyPath:@"selection.bonjourName" options:bindingOptions];
   [self bind:@"password" toObject:_viewController.viewModelObjectController withKeyPath:@"selection.password" options:bindingOptions];
}

-(void)removeBindings {
   [self unbind:@"status"];
   [self unbind:@"connectionFlag"];
   [self unbind:@"dataFormat"];
   [self unbind:@"port"];
   [self unbind:@"bonjourName"];
   [self unbind:@"password"];
}

-(void)setStatus:(NSNumber *)value {
   _status = value;
   [self propagateValue:value forBinding:@"status"];
}

-(NSNumber *)status {
   return _status;
}

-(void)setConnectionFlag:(NSNumber *) value {
   _connectionFlag = value;
   [self propagateValue:value forBinding:@"connectionFlag"];
   ParamValue valueNormalized = value.doubleValue;
   // Automation routine. See DemoGain vst3 for example.
   _editController->beginEdit(kGVConnectionFlagParameter);
   _editController->setParamNormalized(kGVConnectionFlagParameter, valueNormalized);
   _editController->performEdit(kGVConnectionFlagParameter, valueNormalized);
   _editController->endEdit(kGVConnectionFlagParameter);
}

-(NSNumber*)connectionFlag {
   return _connectionFlag;
}

-(void)setDataFormat:(NSNumber *)value {
   _dataFormat = value;
   [self propagateValue:value forBinding:@"dataFormat"];
   OPtr<IMessage> message = _editController->allocateMessage();
   if (message) {
      message->setMessageID(kGVDataFormatMsgId);
      message->getAttributes()->setInt(kGVDataFormatMsgId, value.longValue);
      _editController->sendMessage(message);
   }
}

-(NSNumber*)dataFormat {
   return _dataFormat;
}

-(void)setPort:(NSNumber *)value {
   _port = value;
   [self propagateValue:value forBinding:@"port"];
   OPtr<IMessage> message = _editController->allocateMessage();
   if (message) {
      message->setMessageID(kGVPortMsgId);
      message->getAttributes()->setInt(kGVPortMsgId, value.longValue);
      _editController->sendMessage(message);
   }
}

-(NSNumber*)port {
   return _port;
}

-(void)setBonjourName:(NSString *)value {
   _bonjourName = value;
   [self propagateValue:value forBinding:@"bonjourName"];
   OPtr<IMessage> message = _editController->allocateMessage();
   if (message) {
      String128 string;
      UString(string, tStrBufferSize(String128)).fromAscii ([value UTF8String]);
      message->setMessageID(kGVBonjourNameMsgId);
      message->getAttributes()->setString(kGVBonjourNameMsgId, string);
      _editController->sendMessage(message);
   }
}

-(NSString *)bonjourName {
   return _bonjourName;
}

-(void)setPassword:(NSString *)value {
   _password = value;
   [self propagateValue:value forBinding:@"password"];
   OPtr<IMessage> message = _editController->allocateMessage();
   if (message) {
      String128 string;
      UString(string, tStrBufferSize(String128)).fromAscii ([value UTF8String]);
      message->setMessageID(kGVPasswordMsgId);
      message->getAttributes()->setString(kGVPasswordMsgId, string);
      _editController->sendMessage(message);
   }
}

-(NSString *)password {
   return _password;
}

-(void)propagateValue:(id)value forBinding:(NSString*)binding {
   NSParameterAssert(binding != nil);

   //WARNING: bindingInfo contains NSNull, so it must be accounted for
   NSDictionary* bindingInfo = [self infoForBinding:binding];
   if(!bindingInfo) {
      assert(false);
      return; //there is no binding
   }

   //apply the value transformer, if one has been set
   NSDictionary* bindingOptions = [bindingInfo objectForKey:NSOptionsKey];
   if(bindingOptions){
      NSValueTransformer* transformer = [bindingOptions valueForKey:NSValueTransformerBindingOption];
      if(!transformer || (id)transformer == [NSNull null]){
         NSString* transformerName = [bindingOptions valueForKey:NSValueTransformerNameBindingOption];
         if(transformerName && (id)transformerName != [NSNull null]){
            transformer = [NSValueTransformer valueTransformerForName:transformerName];
         }
      }

      if(transformer && (id)transformer != [NSNull null]){
         if([[transformer class] allowsReverseTransformation]){
            value = [transformer reverseTransformedValue:value];
         } else {
            NSLog(@"WARNING: binding \"%@\" has value transformer, but it doesn't allow reverse transformations in %s", binding, __PRETTY_FUNCTION__);
         }
      }
   }

   id boundObject = [bindingInfo objectForKey:NSObservedObjectKey];
   if(!boundObject || boundObject == [NSNull null]){
      NSLog(@"ERROR: NSObservedObjectKey was nil for binding \"%@\" in %s", binding, __PRETTY_FUNCTION__);
      return;
   }

   NSString* boundKeyPath = [bindingInfo objectForKey:NSObservedKeyPathKey];
   if(!boundKeyPath || (id)boundKeyPath == [NSNull null]){
      NSLog(@"ERROR: NSObservedKeyPathKey was nil for binding \"%@\" in %s", binding, __PRETTY_FUNCTION__);
      return;
   }

   [boundObject setValue:value forKeyPath:boundKeyPath];
}

@end
