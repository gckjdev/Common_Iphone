//
//  Product.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Product.h"
#import "JSON.h"

@implementation Product
@dynamic data;
@dynamic useFor;
@dynamic productId;
@dynamic startDate;
@dynamic endDate;
@dynamic latitude;
@dynamic longitude;
@dynamic price;
@dynamic value;
@dynamic rebate;
@dynamic title;
@dynamic loc;
@dynamic image;
@dynamic deleteFlag;
@dynamic deleteTimeStamp;
@dynamic bought;
@dynamic siteName;
@dynamic siteURL;
@dynamic browseDate;
@dynamic wapURL;
@dynamic desc;
@dynamic detail;
@dynamic gps;
@dynamic address;
@dynamic tel;
@dynamic shop;

- (NSArray*)addressArray
{
    return [self.address JSONValue];
}

- (NSArray*)telArray
{
    return [self.tel JSONValue];
}

- (NSArray*)shopArray
{
    return [self.shop JSONValue];
}


@end
