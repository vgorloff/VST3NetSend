//
//  VST3Controller.cpp
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

GV_NAMESPACE_BEGIN

NetSendController::NetSendController()
: EditController()
, mView(nullptr)
{
}

NetSendController::~NetSendController()
{
    mView = nullptr;
}

tresult PLUGIN_API NetSendController::initialize (FUnknown* context)
{
    tresult result = EditController::initialize(context);
    if (result != kResultTrue) {
        return result;
    }

    parameters.addParameter(STR16("Bypass"), 0, 1, 0, ParameterInfo::kCanAutomate | ParameterInfo::kIsBypass, NetSendParameters::kGVBypassParameter);
    parameters.addParameter(STR16("Connection"), 0, 1, 0, ParameterInfo::kCanAutomate, NetSendParameters::kGVStatusParameter);

    return kResultTrue;
}

IPlugView * PLUGIN_API NetSendController::createView (FIDString name)
{
    if (ConstString(name) == ViewType::kEditor)
    {
        ViewRect defaultSize = ViewRect(0, 0, GV_UI_WIDTH, GV_UI_HEIGHT);
        mView = new NetSendView(this, &defaultSize); /// @todo \b FIXME: GV: 2012.11.23 \n It is possible to pass size here
        assert(mView != nullptr);
        return mView;
    }
    return 0;
}

tresult PLUGIN_API NetSendController::setComponentState (IBStream* state)
{
    NetSendProcessorState gps;
    tresult                 result = gps.setState(state);
    if (result == kResultTrue) {
        mParams = gps;
        setParamNormalized(kGVStatusParameter, gps.status);
        if (mView != nullptr) {
            mView->handleStateChanges(gps);
        }
    }
    return result;
}



tresult PLUGIN_API NetSendController::setParamNormalized (ParamID tag, ParamValue value)
{
    if (mView != nullptr) {
        mView->notifyParameterChanges(tag);
    }
    
    tresult result = EditController::setParamNormalized(tag, value);
    return result;
}


void NetSendController::editorAttached (EditorView* editor)
{
    if (mView != nullptr) {
        mView->handleStateChanges(mParams);
    }
}

void NetSendController::editorRemoved (EditorView* editor)
{

}

void NetSendController::editorDestroyed (EditorView* editor)
{
    mView = nullptr;
}

GV_NAMESPACE_END