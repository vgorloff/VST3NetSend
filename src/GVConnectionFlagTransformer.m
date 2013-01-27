//
//  GVConnectionFlagTransformer.m
//  VST3NetSend
//
//  Created by Vlad Gorloff on 27.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

@implementation GVConnectionFlagTransformer

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
        // Value == "0" in AU means "Connected"
        // Value >  "0" in AU means "Disconnected"
        // But button should showd opposite title.
        // So, when value not "0" we need to show title "Connect"
        result = ([value boolValue] == YES) ? @"Connect" : @"Disconnect";
    }
    else {
        result = @"";
    }
    return result;
}

@end
