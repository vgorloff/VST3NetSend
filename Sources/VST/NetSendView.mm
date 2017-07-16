//
//  NetSendView.mm
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#import "NetSendView.h"
#import "GVNetSendViewProxy.h"
#import "CommonDefinitions.h"
#import "NetSendParameters.h"
#import <CoreAudio/CoreAudio.h>
#import <VST3NetSendUI/VST3NetSendUI-Swift.h>

NSRect NSRectFromVSTViewRect(Steinberg::ViewRect rect) {
   int w = rect.getWidth();
   int h = rect.getHeight();
   NSRect result = NSMakeRect(rect.left, rect.top, w, h);
   return result;
}

GV_NAMESPACE_BEGIN

NetSendView::NetSendView (EditController* controller, ViewRect* size)
: EditorView(controller, size)
, mViewProxy(nil) {
}

NetSendView::~NetSendView () {
   mViewProxy = nil;
}

tresult PLUGIN_API NetSendView::attached (void* ptr, Steinberg::FIDString type) {
   if (isPlatformTypeSupported(type) != Steinberg::kResultTrue) {
      return Steinberg::kResultFalse;
   }

   NSBundle* UIFrameworkBundle = [NSBundle bundleForClass:NetSendViewController.class];
   NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"VST3NetSend" bundle:UIFrameworkBundle];
   mViewController = [storyboard instantiateInitialController];

   NSRect rect = NSRectFromVSTViewRect(getRect());
   NSView *superview = (__bridge NSView*)ptr;
   [superview addSubview:mViewController.view]; // view initialised lazy
   [mViewController.view setFrame:rect];

   mViewProxy = [[GVNetSendViewProxy alloc] initWithView:this];
   assert(mViewProxy != nil);

   tresult result = CPluginView::attached(ptr, type);
   assert(result == kResultOk);
   return result;
}

tresult PLUGIN_API NetSendView::removed () {
   [mViewController.view removeFromSuperviewWithoutNeedingDisplay];
   mViewController = nil;
   Steinberg::tresult result = CPluginView::removed();
   mViewProxy = nil;
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
         NSNumber*  connectionFlag = (normValue > 0.5f) ? [NSNumber numberWithBool:TRUE]: [NSNumber numberWithBool:FALSE];
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
      mViewController.viewModel.dataFormat  = dataFormat;
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

GV_NAMESPACE_END
