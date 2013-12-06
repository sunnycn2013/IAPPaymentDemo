//
//  CCStoreKitManager.m
//  IAPPaymentDemo
//
//  Created by admin on 13-11-19.
//  Copyright (c) 2013年 admin. All rights reserved.
//

#import "CCStoreKitManager.h"

static CCStoreKitManager* _sharedInstance = nil;

@implementation CCStoreKitManager

+(CCStoreKitManager*)sharedInstance
{
	@synchronized([CCStoreKitManager class])
	{
		if (!_sharedInstance)
			[[self alloc] init];
        
		return _sharedInstance;
	}
	return nil;
}

+(id)alloc
{
	@synchronized([CCStoreKitManager class])
	{
		NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.\n");
		_sharedInstance = [super alloc];
		return _sharedInstance;
	}
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
	}
	return self;
}

-(void)initialStore
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
-(void)releaseStore
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)buy:(NSString*)buyProductIDTag
{
    [self requestProductData:buyProductIDTag];
}

-(bool)CanMakePay
{
    return [SKPaymentQueue canMakePayments];
}

-(void)requestProductData:(NSString*)buyProductIDTag
{
    NSLog(@"---------Request product information------------\n");
    _buyProductIDTag = [buyProductIDTag retain];
    NSArray *product = [[NSArray alloc] initWithObjects:buyProductIDTag,nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start];
    [product release];
}

#pragma argument 
#pragma argument  SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"-----------Getting product information--------------\n");
    NSArray *myProduct = response.products;
    NSLog(@"Product ID:%@\n",response.invalidProductIdentifiers);
    NSLog(@"Product count: %d\n", [myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"Detail product info\n");
        NSLog(@"SKProduct description: %@\n", [product description]);
        NSLog(@"Product localized title: %@\n" , product.localizedTitle);
        NSLog(@"Product localized descitption: %@\n" , product.localizedDescription);
        NSLog(@"Product price: %@\n" , product.price);
        NSLog(@"Product identifier: %@\n" , product.productIdentifier);
    }
    SKPayment *payment = nil;
    payment = [SKPayment paymentWithProduct:[response.products objectAtIndex:0]];
    NSLog(@"---------Request payment------------\n");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [request autorelease];
    
}
- (void)requestProUpgradeProductData:(NSString*)buyProductIDTag
{
    NSLog(@"------Request to upgrade product data---------\n");
    NSSet *productIdentifiers = [NSSet setWithObject:buyProductIDTag];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"-------Show fail message----------\n");
    NSLog(@"%@",error);
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    [alerView release];
}

-(void) requestDidFinish:(SKRequest *)request
{
    NSLog(@"----------Request finished--------------\n");
    
}

-(void) purchasedTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"-----Purchased Transaction----\n");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
    [transactions release];
}

#pragma argument
#pragma argument  SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"-----Payment result--------\n");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                NSLog(@"-----Transaction purchased--------\n");
                UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"Congratulation"
                                                                    message:@"Transaction suceed!"
                                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
                
                [alerView show];
                [alerView release];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                NSLog(@"-----Transaction Failed--------\n");
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"Failed"
                                                                     message:@"Sorry, your transcation failed, try again."
                                                                    delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
                
                [alerView2 show];
                [alerView2 release];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                NSLog(@"----- Already buy this product--------\n");
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"-----Transcation puchasing--------\n");
                break;
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"-----completeTransaction--------\n");
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

-(void)recordTransaction:(NSString *)product
{
    NSLog(@"-----Record transcation--------\n");
    // Todo: Maybe you want to save transaction result into plist.
}

-(void)provideContent:(NSString *)product
{
    NSLog(@"-----Download product content--------\n");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"Failed\n");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction
{
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"-----Restore transaction--------\n");
}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"-------Payment Queue----\n");
}

#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@\n",  [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    switch([(NSHTTPURLResponse *)response statusCode]) {
        case 200:
        case 206:
            break;
        case 304:
            break;
        case 400:
            break;
        case 404:
            break;
        case 416:
            break;
        case 403:
            break;
        case 401:
        case 500:
            break;
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"test\n");
}   

-(void)dealloc
{
    [super dealloc];
}

@end
