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
{
}

NetSendView::~NetSendView ()
{
}

tresult PLUGIN_API NetSendView::attached (void* ptr, Steinberg::FIDString type)
{
    if (isPlatformTypeSupported(type) != Steinberg::kResultTrue) {
        return Steinberg::kResultFalse;
    }

    tresult result = CPluginView::attached(ptr, type);
    assert(result == kResultOk);
    return result;
}

tresult PLUGIN_API NetSendView::removed ()
{
    Steinberg::tresult result = CPluginView::removed();
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

GV_NAMESPACE_END