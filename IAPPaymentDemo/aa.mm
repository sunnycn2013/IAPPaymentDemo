//
//  aa.cpp
//  IAPPaymentDemo
//
//  Created by admin on 13-11-19.
//  Copyright (c) 2013年 admin. All rights reserved.
//

#include "aa.h"
#include "CCStoreKitManager.h"
#define ProductID_IAP_1 @"com.qeebu.xiaofudai"


void aa::fun(){
    [[CCStoreKitManager sharedInstance] initialStore];
    [[CCStoreKitManager sharedInstance] buy:ProductID_IAP_1];
}

