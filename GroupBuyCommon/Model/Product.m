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
@dynamic distance;
@dynamic offset;

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

- (NSArray*)gpsArray
{
    NSArray* array = [self.gps JSONValue];
    NSMutableArray* gpsArray = [[[NSMutableArray alloc] init] autorelease];
    for (NSArray* valuePair in array){
        if (valuePair && [valuePair count] == 2){
            double latitude = [[valuePair objectAtIndex:0] doubleValue];
            double longitude = [[valuePair objectAtIndex:1] doubleValue];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];            
            [gpsArray addObject:location];
            [location release];
        }
    }
    
    if ([gpsArray count] > 0)
        return gpsArray;
    else
        return nil;
}

- (double)calcShortestDistance:(CLLocation*)currentLocation
{
    NSArray* gpsArray = [self gpsArray];
    if (gpsArray){
        double distance = MAXFLOAT;
        for (CLLocation* location in gpsArray){
            double calc = [currentLocation distanceFromLocation:location];
            if (calc < distance){
                distance = calc; 
            }
        }

        return distance;
    }
    else{
        return MAXFLOAT;
    }
}

@end
