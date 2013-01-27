//
//  NetSendView.cpp
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

tresult PLUGIN_API NetSendView::canResize ()
{
    return kResultFalse;
}

Steinberg::tresult PLUGIN_API NetSendView::getSize (ViewRect* size)
{
    return Steinberg::Vst::EditorView::getSize(size);
}

Steinberg::tresult PLUGIN_API NetSendView::onSize (ViewRect* newSize)
{
    Steinberg::tresult result = Steinberg::Vst::EditorView::onSize(newSize);
    return result;
}

void NetSendView::notifyParameterChanges(unsigned int index)
{
    switch (index) {
        case kGVStatusParameter:
        {
            ParamValue normValue = getController()->getParamNormalized(index);
            NSString* newStatus = (normValue > 0.5f) ? @"On" : @"Off";
            mViewProxy.status = newStatus;
            break;
        }

        default:
            break;
    }
}

void NetSendView::handleStateChanges(const NetSendProcessorState& state)
{
    mViewProxy.port = [NSNumber numberWithInt:state.port];
    mViewProxy.bonjourName = [NSString stringWithUTF8String:state.bonjourName];
    mViewProxy.password = [NSString stringWithUTF8String:state.password];
    notifyParameterChanges(kGVStatusParameter);
}

GV_NAMESPACE_END