//
//  GVSolidBackgroundView.m
//  VST3NetSend
//
//  Created by Vlad Gorloff on 27.01.13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

@implementation GVSolidBackgroundView

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor controlColor] set];
    NSRectFill(dirtyRect);
}

@end
