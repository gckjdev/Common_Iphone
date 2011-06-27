//
//  Place.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-13.
//  Copyright (c) 2011骞�__MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

enum PLACE_USE_FOR {
    PLACE_USE_NEARBY = 0,
    PLACE_USE_FOLLOW,
    PLACE_USE_SEARCH
};


@interface Place : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * placeId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * createUser;
@property (nonatomic, retain) NSString * followUser;
@property (nonatomic, assign) NSNumber * useFor;
@property (nonatomic, assign) NSNumber * deleteFlag;
@property (nonatomic, assign) NSNumber * deleteTimeStamp;

@end
