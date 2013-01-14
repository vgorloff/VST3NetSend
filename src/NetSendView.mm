//
//  NetSendView.cpp
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//


GV_NAMESPACE_BEGIN

NSRect NSRectFromViewRect(ViewRect rect)
{
    int32 w = rect.getWidth();
    int32 h = rect.getHeight();
    NSRect result = NSMakeRect(rect.left, rect.top, w, h);
    return result;
}

//bool isZeroViewRect(ViewRect rect)
//{
//    int32 w = rect.getWidth();
//    int32 h = rect.getHeight();
//    bool result = (w <= 0 || h <= 0);
//    return result;
//}

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
    
    mViewProxy = [[GVNetSendViewProxy alloc] init];
    assert(mViewProxy != nil);
    
    NSString*           bundleName   = @GV_BUNDLE_ID;
    NSBundle*           pluginBundle = [NSBundle bundleWithIdentifier:bundleName];
    assert(pluginBundle != nil);
    
    NSView* parent = (__bridge NSView*)ptr;
    NSRect rect = NSRectFromViewRect(getRect());
    EditController* myVst3Controller = getController();
    [mViewProxy loadUi:pluginBundle forView:parent withFrame:rect withVST3Controller:myVst3Controller];

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

GV_NAMESPACE_END