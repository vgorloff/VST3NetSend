//
//  GVNetSendViewController.m
//  VST3NetSend
//
//  Created by Volodymyr Gorlov on 1/14/13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

@interface GVNetSendViewProxy ()
{
    GVNetSendVST3Controller* mVST3Controller;
}

@end

@implementation GVNetSendViewProxy

- (id)init
{
    self = [super init];
    if (self)
    {
        mVST3Controller = nullptr;
    }
    return self;
}


- (void)dealloc
{
    assert(viewController != nil);
    [viewController.view removeFromSuperviewWithoutNeedingDisplay];
    viewController = nil;
    mVST3Controller = nullptr;
}

-(void) loadUi:(NSBundle*)myBundle forView:(NSView*)parentView withFrame:(NSRect)rect withVST3Controller:(void*)vst3Ctrl
{
    viewController = [[GVNetSendViewController alloc] initWithNibName:@"VST3NetSendView" bundle:myBundle];
    assert(viewController != nil);
    [parentView addSubview:viewController.view]; // view initialised lazy
    [viewController.view setFrame:rect];
    mVST3Controller = static_cast<GVNetSendVST3Controller*>(vst3Ctrl);
}

@end
