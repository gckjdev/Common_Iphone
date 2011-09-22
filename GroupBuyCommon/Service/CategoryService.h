//
//  CategoryService.h
//  groupbuy
//
//  Created by  on 11-9-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

@protocol CategoryServiceDelegate <NSObject>

@optional
- (void)getAllCategoryFinish:(int)result jsonArray:(NSArray *)jsonArray;

@end

@interface CategoryService : CommonService

- (void)getAllCategory:(id<CategoryServiceDelegate>)delegate;

@end

extern CategoryService *GlobalGetCategoryService();
