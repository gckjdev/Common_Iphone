//
//  ProductService.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "PPViewController.h"

#define PRODUCT_ACTION_CLICK            @"click"
#define PRODUCT_ACTION_BUY              @"buy"
#define PRODUCT_ACTION_ADD_FAVORITE     @"save"
#define PRODUCT_ACTION_FORWARD          @"send"
#define PRODUCT_ACTION_UP               @"up"
#define PRODUCT_ACTION_DOWN             @"down"

@protocol ProductServiceDelegate <NSObject>

@optional

// common method now!!! we can refactor all to this method 
- (void)productDataRefresh:(int)result;
- (void)productDataRefresh:(int)result jsonArray:(NSArray*)jsonArray;
- (void)actionOnProductFinish:(int)result actionName:(NSString *)actionName count:(long)count;
- (void)writeCommentFinish:(int)result;
- (void)getCommentFinish:(int)result jsonArray:(NSArray *)jsonArray;
- (void)segmentTextFinish:(int)result jsonArray:(NSArray *)jsonArray;
- (void)taobaoSearchFinish:(int)result jsonArray:(NSArray *)jsonArray;


@end

@interface ProductService : CommonService {
    
    dispatch_queue_t    actionWorkingQueue;
    dispatch_queue_t    segmentTextQueue;
}

- (dispatch_queue_t)getWorkingQueue:(int)useFor;

- (void)requestProductData:(id<ProductServiceDelegate>)delegateObject
                    useFor:(int)useFor
               startOffset:(int)startOffset
                 cleanData:(BOOL)cleanData;

- (void)requestProductData:(id<ProductServiceDelegate>)delegateObject
                    useFor:(int)useFor
               startOffset:(int)startOffset
                 cleanData:(BOOL)cleanData
				   keyword:(NSString*)keyword;

- (void)requestProductDataByCategory:(id<ProductServiceDelegate>)delegateObject todayOnly:(BOOL)todayOnly;

- (void)updateKeywords;

- (void)actionOnProduct:(NSString*)productId actionName:(NSString*)actionName actionValue:(int)actionValue;
- (void)actionOnProduct:(NSString*)productId actionName:(NSString*)actionName actionValue:(int)actionValue viewController:(PPViewController<ProductServiceDelegate>*)viewController;


- (void)writeCommentWithContent:(NSString *)content nickName:(NSString *)nickName productId:(NSString *)productId viewController:(PPViewController<ProductServiceDelegate> *)viewController;

- (void)getCommentsWithProductId:(NSString *)productId viewController:(PPViewController<ProductServiceDelegate> *)viewController;

- (void)segmentText:(NSString*)text delegate:(id<ProductServiceDelegate>)delegate;
- (void)taobaoSearch:(NSString*)keyword delegate:(id<ProductServiceDelegate>)delegate;

@end

extern ProductService* GlobalGetProductService();