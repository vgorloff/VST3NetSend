//
//  CommonDefinitions.h
//  VST3NetSend
//
//  Created by Vlad Gorloff on 06.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#ifndef VST3NetSend_CommonDefinitions_h
#define VST3NetSend_CommonDefinitions_h

#define GV_PLUGIN_NAME  "WaveLabs VST3NetSend"
#define GV_VENDOR       "WaveLabs Audio"
#define GV_EMAIL        "mailto:info@wavelabs.com.ua"
#define GV_URL          "http://wavelabs.com.ua"

#define GV_FULL_VERSION_STR   "1.0.3" /// @todo \b FIXME: GV: 2013.01.07 \n This should be centralized and synced with bundle version.

#define GV_MAX_NUM_CHANNELS 8

// Next two defines should be in sync with view dimensions in XIB-file.
#define GV_UI_WIDTH 358
#define GV_UI_HEIGHT 218

#define GV_NAMESPACE_BEGIN namespace GV {
#define GV_NAMESPACE_END   }

enum NetSendParameters
{
    kGVBypassParameter = UINT16_MAX,
    kGVConnectionFlagParameter = 0,
    kGVNumParameters,

    kGVDataFormat,
    kGVPort,
    kGVBonjourName,
    kGVPassword
};

#ifndef __OBJC__

// See default filters in "/etc/asl.conf"
#include <asl.h>
#ifdef DEBUG
static const int GVSysLogLevel   = ASL_LEVEL_DEBUG;
static const int GVPrintLogLevel = ASL_LEVEL_NOTICE;
#else
static const int GVSysLogLevel   = ASL_LEVEL_NOTICE;
static const int GVPrintLogLevel = ASL_LEVEL_WARNING;
#endif

#define GVLogEmerg(format, ...) NSLog_level(ASL_LEVEL_EMERG, "[M]",format, ##__VA_ARGS__)
#define GVLogAlert(format, ...) NSLog_level(ASL_LEVEL_ALERT, "[A]",format, ##__VA_ARGS__)
#define GVLogCrit(format, ...) NSLog_level(ASL_LEVEL_CRIT, "[C]",format, ##__VA_ARGS__)
#define GVLogError(format, ...) NSLog_level(ASL_LEVEL_ERR, "[E]",format, ##__VA_ARGS__)
#define GVLogWarn(format, ...) NSLog_level(ASL_LEVEL_WARNING, "[W]",format, ##__VA_ARGS__)
#define GVLogNotice(format, ...) NSLog_level(ASL_LEVEL_NOTICE, "[N]",format, ##__VA_ARGS__)
#define GVLogInfo(format, ...) NSLog_level(ASL_LEVEL_INFO, "[I]",format, ##__VA_ARGS__)
#define GVLogDebug(format, ...) NSLog_level(ASL_LEVEL_DEBUG, "[D]", format, ##__VA_ARGS__)

#define NSLog_level(log_level, prefix, format, ...) \
{\
    std::string __gv_log_msg = std_sprintf(format, ##__VA_ARGS__); \
    std::string __gv_log_file(__FILE__); \
    const char * __gv_log_file_name = __gv_log_file.substr(__gv_log_file.find_last_of('/') + 1).c_str(); \
    const char * __gv_log_message_string = __gv_log_msg.c_str(); \
    \
    asl_set_filter(NULL, ASL_FILTER_MASK_UPTO(GVSysLogLevel)); \
    aslmsg __gv_log_message = asl_new(ASL_TYPE_MSG); \
    asl_set(__gv_log_message, ASL_KEY_SENDER, "GV"); \
    asl_log(NULL, __gv_log_message, log_level, "%s %s:%d %s: %s", prefix, __gv_log_file_name, __LINE__, __func__, __gv_log_message_string); \
    asl_free(__gv_log_message); \
    if (log_level <= GVPrintLogLevel) { \
        printf("%s %s:%d %s: %s\n", prefix, __gv_log_file_name, __LINE__, __func__, __gv_log_message_string); \
    } \
}

#endif

#endif
