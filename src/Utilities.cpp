//
//  Utilities.cpp
//  VST3NetSend
//
//  Created by Vlad Gorloff on 07.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//


GV_NAMESPACE_BEGIN

std::string std_sprintf(const char* fmt, ...)
{
    char msg[strlen(fmt) + 1024]; // make sure that buffer is enought
    va_list args;
    va_start(args, fmt);
    vsprintf(msg, fmt, args);
    va_end(args);

    std::string result(msg);
    return result;
}

GV_NAMESPACE_END
