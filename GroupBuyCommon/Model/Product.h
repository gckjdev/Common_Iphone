//
//  Product.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface Product : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) NSNumber * useFor;
@property (nonatomic, retain) NSString * productId;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * rebate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * loc;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * deleteFlag;
@property (nonatomic, retain) NSNumber * deleteTimeStamp;
@property (nonatomic, retain) NSNumber * bought;
@property (nonatomic, retain) NSString * siteName;
@property (nonatomic, retain) NSString * siteURL;
@property (nonatomic, retain) NSDate * browseDate;
@property (nonatomic, retain) NSString * wapURL;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * gps;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * shop;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * offset;

- (NSArray*)addressArray;
- (NSArray*)telArray;
- (NSArray*)shopArray;
- (NSArray*)gpsArray;
- (double)calcShortestDistance:(CLLocation*)currentLocation;
- (void)copyFrom:(Product*)product useFor:(int)useFor;


@end
