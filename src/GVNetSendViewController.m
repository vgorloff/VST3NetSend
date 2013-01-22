//
//  GVNetSendViewController.m
//  VST3NetSend
//
//  Created by Volodymyr Gorlov on 1/14/13.
//  Copyright (c) 2013 Vlad Gorloff. All rights reserved.
//

@interface GVNetSendViewController ()
{
    GVNetSendModel* _model;
    NSObjectController* _modelController;
}

@end

@implementation GVNetSendViewController

-(void) privateInit
{
    _model = [[GVNetSendModel alloc] init];
    _modelController = [[NSObjectController alloc] initWithContent:_model];
}

-(void) privateDealloc
{
    _modelController = nil;
    _model = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self privateInit];
    }
    return self;
}

- (void)dealloc
{
    [self removeBindings];
    [self privateDealloc];
}

-(void) awakeFromNib
{
    [self setupBindings];
}

-(void) setupBindings
{
    [self.status bind:@"value" toObject:_modelController withKeyPath:@"selection.status" options:nil];
//    [self.dataFormat bind:@"value" toObject:_modelController withKeyPath:@"selection.dataFormat" options:nil];
    [self.port bind:@"value" toObject:_modelController withKeyPath:@"selection.port" options:nil];
    [self.bonjourName bind:@"value" toObject:_modelController withKeyPath:@"selection.bonjourName" options:nil];
    [self.password bind:@"value" toObject:_modelController withKeyPath:@"selection.password" options:nil];
}

-(void) removeBindings
{
    [self.status unbind:@"value"];
//    [self.dataFormat unbind:@"value"];
    [self.port unbind:@"value"];
    [self.bonjourName unbind:@"value"];
    [self.password unbind:@"value"];
}

@end
