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
{

}

NetSendController::~NetSendController()
{
    
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
        NetSendView* ui = new NetSendView(this, &defaultSize); /// @todo \b FIXME: GV: 2012.11.23 \n It is possible to pass size here
        assert(ui != nullptr);
        return ui;
    }
    return 0;
}

//tresult PLUGIN_API WavemeterController::setComponentState (IBStream* state)
//{
//    WavemeterParameterState gps;
//    tresult                 result = gps.setState(state);
//    if (result == kResultTrue)
//    {
//        setParameterNormalized(kGVLevelParameter, gps.gain, true, true);
//        setParameterNormalized(kGVTimeParameter, gps.time, true, true);
//        setParameterNormalized(kGVChannel01Active, gps.ch01Active, true, true);
//        setParameterNormalized(kGVChannel02Active, gps.ch02Active, true, true);
//        setParameterNormalized(kGVChannel03Active, gps.ch03Active, true, true);
//        setParameterNormalized(kGVChannel04Active, gps.ch04Active, true, true);
//        setParameterNormalized(kGVChannel05Active, gps.ch05Active, true, true);
//        setParameterNormalized(kGVChannel06Active, gps.ch06Active, true, true);
//        setParameterNormalized(kGVChannel07Active, gps.ch07Active, true, true);
//        setParameterNormalized(kGVChannel08Active, gps.ch08Active, true, true);
//    }
//    return result;
//}

GV_NAMESPACE_END