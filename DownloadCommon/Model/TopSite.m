//
//  TopSite.m
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TopSite.h"

@implementation TopSite


@synthesize siteType;
@synthesize siteFileType;
@synthesize siteURL;
@synthesize siteName;
@synthesize downloadCount;
@synthesize countryCode;
@synthesize siteId;

- (id)initWithSiteId:(NSString*)siteIdValue
            siteType:(int)siteTypeValue
          siteFileType:(NSString*)siteFileTypeValue
               siteURL:(NSString*)siteURLValue
              siteName:(NSString*)siteNameValue
         downloadCount:(int)downloadCountValue
           countryCode:(NSString*)countryCodeValue
{
    self = [super init];
    
    self.siteId = siteIdValue;
    self.siteURL = siteURLValue;
    self.siteFileType = siteFileTypeValue;
    self.siteType = siteTypeValue;
    self.siteName = siteNameValue;
    self.downloadCount = downloadCountValue;
    self.countryCode = countryCodeValue;
    
    return self;
}

- (void)dealloc
{
    [siteId release];
    [countryCode release];
    [siteFileType release];
    [siteURL release];
    [siteName release];
    [super dealloc];
}

@end
