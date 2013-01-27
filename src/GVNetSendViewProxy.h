//
//  GVNetSendViewController.h
//  VST3NetSend
//
//  Created by Volodymyr Gorlov on 1/14/13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

@interface GVNetSendViewProxy : NSObject

@property NSString* status;
@property NSNumber* dataFormat;
@property NSNumber* port;
@property NSString* bonjourName;
@property NSString* password;

- (id)initWithView:(void*)editView;
-(void) attachToSuperview:(NSView*)superview;

@end
