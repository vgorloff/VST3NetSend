//
//  GVNetSendModel.h
//  VST3NetSend
//
//  Created by Volodymyr Gorlov on 1/22/13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

@interface GVNetSendModel : NSObject

@property NSNumber* status;
@property NSNumber* connectionFlag;
@property NSNumber* dataFormat;
@property NSNumber* port;
@property NSString* bonjourName;
@property NSString* password;

@end
