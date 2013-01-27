//
//  GVConnectionStatusTransformer.m
//  VST3NetSend
//
//  Created by Vlad Gorloff on 27.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

#include <AudioUnit/AudioUnit.h>

@implementation GVConnectionStatusTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value
{
    NSString* result;
    if (value != nil) {
        switch ([value intValue])
        {
            case kAUNetStatus_NotConnected:
                result = @"Not Connected";
                break;
            case kAUNetStatus_Connected:
                result = @"Connected";
                break;
            case kAUNetStatus_Overflow:
                result = @"Overflow";
                break;
            case kAUNetStatus_Underflow:
                result = @"Underflow";
                break;
            case kAUNetStatus_Connecting:
                result = @"Connecting";
                break;
            case kAUNetStatus_Listening:
                result = @"Listening";
                break;
        }
    }
    else {
        result = @"";
    }
    return result;
}

@end
