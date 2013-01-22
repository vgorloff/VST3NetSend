//
//  GVNetSendViewController.h
//  VST3NetSend
//
//  Created by Volodymyr Gorlov on 1/14/13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

@interface GVNetSendViewController : NSViewController

@property (weak) IBOutlet NSTextField* status;
@property (weak) IBOutlet NSPopUpButton* dataFormat;
@property (weak) IBOutlet NSTextField* port;
@property (weak) IBOutlet NSTextField* bonjourName;
@property (weak) IBOutlet NSSecureTextField* password;

@end
