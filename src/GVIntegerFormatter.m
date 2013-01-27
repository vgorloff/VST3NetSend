//
//  GVIntegerFormatter.m
//  VST3NetSend
//
//  Created by Vlad Gorloff on 27.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

@implementation GVIntegerFormatter

-(NSString*) stringForNumberValue:(NSNumber*)anNumber
{
    NSString* format = @"%d";
    return [NSString stringWithFormat:format, [anNumber  integerValue]];
}

#pragma mark NSFormatter methods

-(NSString*) stringForObjectValue:(id)anObject
{
    if (![anObject isKindOfClass:[NSNumber class]]) {
        return nil;
    }

    return [self stringForNumberValue:anObject];
}

-(NSString*) editingStringForObjectValue:(id)anObject
{
    if (![anObject isKindOfClass:[NSNumber class]]) {
        return nil;
    }

    return [self stringForNumberValue:anObject];
}

-(BOOL) getObjectValue:(out id*)obj forString:(NSString*)string errorDescription:(out NSString**)error
{
    NSInteger  integerResult = 0;
    BOOL       returnValue   = NO;

    NSScanner* scanner       = [NSScanner scannerWithString:[string stringByReplacingOccurrencesOfString:@"," withString:@"." ]];
    if ([scanner scanInteger:&integerResult] && ([scanner isAtEnd])) 
    {
        returnValue = YES;
        if (obj) {
            *obj = [NSNumber numberWithFloat:integerResult];
        }
    }
    else
    {
        if (error) {
            *error = NSLocalizedString(@"Couldn’t convert text to integer", @"Error converting");
        }
    }
    return returnValue;
}

@end
