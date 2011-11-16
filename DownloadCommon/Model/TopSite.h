//
//  TopSite.h
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum SITE_TYPE {
    SITE_TYPE_SYSTEM = 1,
    SITE_TYPE_USER = 2,
    SITE_TYPE_LOCAL = 99
};

@interface TopSite : NSObject

@property (nonatomic, assign) int siteType;
@property (nonatomic, retain) NSString *siteId;
@property (nonatomic, retain) NSString *siteFileType;
@property (nonatomic, retain) NSString *siteURL;
@property (nonatomic, retain) NSString *siteName;
@property (nonatomic, assign) int downloadCount;
@property (nonatomic, retain) NSString *countryCode;

- (id)initWithSiteId:(NSString*)siteId
            siteType:(int)siteTypeValue
          siteFileType:(NSString*)siteFileTypeValue
               siteURL:(NSString*)siteURLValue
              siteName:(NSString*)siteNameValue
         downloadCount:(int)downloadCountValue
           countryCode:(NSString*)countryCodeValue;

@end
