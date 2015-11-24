//
//  NetSendView.mm
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

GV_NAMESPACE_BEGIN

NetSendView::NetSendView (EditController* controller, ViewRect* size)
    : EditorView(controller, size)
    , mViewProxy(nil)
{
}

NetSendView::~NetSendView ()
{
    mViewProxy = nil;
}

tresult PLUGIN_API NetSendView::attached (void* ptr, Steinberg::FIDString type)
{
    if (isPlatformTypeSupported(type) != Steinberg::kResultTrue) {
        return Steinberg::kResultFalse;
    }

    mViewProxy = [[GVNetSendViewProxy alloc] initWithView:this];
    assert(mViewProxy != nil);
    [mViewProxy attachToSuperview:(__bridge NSView*)ptr];
    tresult result = CPluginView::attached(ptr, type);
    assert(result == kResultOk);
    return result;
}

tresult PLUGIN_API NetSendView::removed ()
{
    Steinberg::tresult result = CPluginView::removed();
    mViewProxy = nil;
    assert(result == kResultOk);
    return result;
}

tresult PLUGIN_API NetSendView::isPlatformTypeSupported (Steinberg::FIDString type)
{
    if (strcmp(type, Steinberg::kPlatformTypeNSView) == 0) {
        return Steinberg::kResultTrue;
    }

    return Steinberg::kInvalidArgument;
}

void NetSendView::notifyParameterChanges (unsigned int index)
{
    switch (index)
    {
        case kGVConnectionFlagParameter:
        {
            ParamValue normValue = getController()->getParamNormalized(index);
            NSNumber*  connectionFlag = (normValue > 0.5f) ? [NSNumber numberWithBool:TRUE]: [NSNumber numberWithBool:FALSE];
            if ([connectionFlag compare:mViewProxy.connectionFlag] != NSOrderedSame) { // Preverting infinite loop
                mViewProxy.connectionFlag = connectionFlag;
            }
            break;
        }
    }
}

void NetSendView::setConnectionStatus(int64 stat)
{
    NSNumber* status = [NSNumber numberWithFloat:stat];
    mViewProxy.status = status;
}

void NetSendView::handleStateChanges (const NetSendProcessorState& state)
{
    NSNumber* dataFormat  = [NSNumber numberWithInt:state.dataFormat];
    NSNumber* port        = [NSNumber numberWithFloat:state.port];
    NSString* bonjourName = [NSString stringWithUTF8String:state.bonjourName];
    NSString* password    = [NSString stringWithUTF8String:state.password];
    
    if ([dataFormat compare:mViewProxy.dataFormat] != NSOrderedSame) {
        mViewProxy.dataFormat  = dataFormat;
    }
    if ([port compare:mViewProxy.port] != NSOrderedSame) {
        mViewProxy.port  = port;
    }
    if ([bonjourName compare:mViewProxy.bonjourName] != NSOrderedSame) {
        mViewProxy.bonjourName = bonjourName;
    }
    if ([password compare:mViewProxy.password] != NSOrderedSame) {
        mViewProxy.password = password;
    }
}

GV_NAMESPACE_END
