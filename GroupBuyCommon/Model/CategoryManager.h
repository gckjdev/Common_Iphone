//
//  CategoryManager.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryManager : NSObject {
    
    NSArray         *categories;
    NSDictionary    *subCateogriesDict;
    
}

@property (nonatomic, readonly) NSArray         *categories;
@property (nonatomic, readonly) NSDictionary    *subCateogriesDict;

+ (CategoryManager*)getManager;

+ (NSArray*)getAllCategories;
+ (NSArray*)getSubCategoriesByCategory:(NSString*)category;
+ (NSString*)refineSubCategoryNames:(NSString*)categoryName subCategoryNames:(NSString*)subCategoryNames; 

@end
