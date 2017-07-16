//
//  GVNetSendViewProxy.h
//  VST3NetSend
//
//  Created by Volodymyr Gorlov on 1/14/13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#ifdef __OBJC__
   #import <Cocoa/Cocoa.h>
#endif

@interface GVNetSendViewProxy : NSObject

@property NSNumber* status;
@property NSNumber* connectionFlag;
@property NSNumber* dataFormat;
@property NSNumber* port;
@property NSString* bonjourName;
@property NSString* password;

- (id)initWithView:(void*)editView;

@end
