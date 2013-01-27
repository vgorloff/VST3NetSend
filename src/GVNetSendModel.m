//
//  GVNetSendModel.m
//  VST3NetSend
//
//  Created by Volodymyr Gorlov on 1/22/13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

@implementation GVNetSendModel

- (id)init
{
    self = [super init];
    if (self) {
        self.status = @0;
        self.connectionFlag = @0;
        self.dataFormat = @0;
        self.port = @0;
        self.bonjourName = @"";
        self.password = @"";
    }
    return self;
}

- (void)dealloc
{
    self.status = nil;
    self.connectionFlag = nil;
    self.dataFormat = nil;
    self.port = nil;
    self.bonjourName = nil;
    self.password = nil;
}

@end
