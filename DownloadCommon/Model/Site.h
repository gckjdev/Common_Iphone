//
//  Site.h
//  Download
//
//  Created by  on 11-11-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Site : NSManagedObject

@property (nonatomic, retain) NSString * siteName;
@property (nonatomic, retain) NSNumber * siteType;
@property (nonatomic, retain) NSString * siteURL;
@property (nonatomic, retain) NSString * siteId;
@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) NSNumber * downloadCount;
@property (nonatomic, retain) NSString * siteFileType;

@end
