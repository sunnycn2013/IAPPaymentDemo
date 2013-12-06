//
//  ViewController.h
//  IAPPaymentDemo
//
//  Created by admin on 13-11-19.
//  Copyright (c) 2013年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCStoreKitManager.h"

@interface ViewController : UIViewController{
    CCStoreKitManager* storeManager;
}

@property (nonatomic,retain) CCStoreKitManager* storeManager;
- (IBAction)btn:(id)sender;

@end
