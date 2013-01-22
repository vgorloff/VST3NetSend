//
//  GVNetSendModel.m
//  VST3NetSend
//
//  Created by Volodymyr Gorlov on 1/22/13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

@implementation GVNetSendModel

-(void) privateInit
{
    self.status = @"";
    self.dataFormat = @0;
    self.port = @0;
    self.bonjourName = @"";
    self.password = @"";
}

- (id)init
{
    self = [super init];
    if (self) {
        [self privateInit];
    }
    return self;
}

-(void) privateDealloc
{
    self.status = nil;
    self.dataFormat = nil;
    self.port = nil;
    self.bonjourName = nil;
    self.password = nil;
}

- (void)dealloc
{
    [self privateDealloc];
}

@end
