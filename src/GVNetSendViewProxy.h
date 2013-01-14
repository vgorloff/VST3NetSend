//
//  GVNetSendViewController.h
//  VST3NetSend
//
//  Created by Volodymyr Gorlov on 1/14/13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

@interface GVNetSendViewProxy : NSObject
{
@public
    GVNetSendViewController* viewController;
}

-(void) loadUi:(NSBundle*)bundle forView:(NSView*)view withFrame:(NSRect)rect withVST3Controller:(void*)ctrl;

@end
