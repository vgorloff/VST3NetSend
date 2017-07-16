//
//  NetSendParameters.h
//  VST3NetSend
//
//  Created by Vlad Gorlov on 16.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#ifndef VST3NetSend_NetSendParameters_h
#define VST3NetSend_NetSendParameters_h

#include <stdint.h>

enum NetSendParameters {

   kGVBypassParameter = UINT16_MAX,
   kGVConnectionFlagParameter = 0,
   kGVNumParameters,
};

#endif /* NetSendParameters_h */
