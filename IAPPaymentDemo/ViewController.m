//
//  ViewController.m
//  IAPPaymentDemo
//
//  Created by admin on 13-11-19.
//  Copyright (c) 2013年 admin. All rights reserved.
//

#import "ViewController.h"
#define ProductID_IAP_1 @"com.qeebu.xiaofudai"


@interface ViewController ()

@end

@implementation ViewController
@synthesize storeManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[CCStoreKitManager sharedInstance] initialStore];
    [storeManager initialStore];
       // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn:(id)sender {
    [[CCStoreKitManager sharedInstance] initialStore];
    [[CCStoreKitManager sharedInstance] buy:ProductID_IAP_1];

}

- (void)dealloc{
    [[CCStoreKitManager sharedInstance] releaseStore];
    [super dealloc];
}
@end
