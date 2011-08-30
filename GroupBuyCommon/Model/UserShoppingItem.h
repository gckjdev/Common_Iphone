//
//  UserShoppingItem.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserShoppingItem : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSString * subCategoryName;
@property (nonatomic, retain) NSString * keywords;
@property (nonatomic, retain) NSDate * expireDate;
@property (nonatomic, retain) NSNumber * minRebate;
@property (nonatomic, retain) NSNumber * maxPrice;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * city;

@end