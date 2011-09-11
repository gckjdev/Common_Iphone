//
//  CategoryManager.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryManager : NSObject {
    
    NSArray         *groupbuyCatories;
    NSDictionary    *groupbuyCatoriesDict;
    NSArray         *categories;
    NSDictionary    *subCateogriesDict;
    
}

@property (nonatomic, readonly) NSArray         *categories;
@property (nonatomic, readonly) NSDictionary    *subCateogriesDict;
@property (nonatomic, readonly) NSArray         *groupbuyCatories;
@property (nonatomic, readonly) NSDictionary    *groupbuyCatoriesDict;

+ (CategoryManager*)getManager;

// for SHOPPING ITEM category
+ (NSArray*)getAllCategories;
+ (NSArray*)getSubCategoriesByCategory:(NSString*)category;
+ (NSString*)refineSubCategoryNames:(NSString*)categoryName subCategoryNames:(NSString*)subCategoryNames; 

// for NORMAL GROUPBUY category
+ (NSArray*)getAllGroupBuyCategories;
+ (NSArray*)getGroupBuyCategoryIdByName:(NSString*)name;

@end
