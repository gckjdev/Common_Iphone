//
//  TopDownloadItem.m
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TopDownloadItem.h"

@implementation TopDownloadItem
@synthesize fileType;
@synthesize fileName;
@synthesize url;
@synthesize webSite;
@synthesize webSiteName;
@synthesize totalDownload;
@synthesize rank;
@synthesize score;
@synthesize createDate;
@synthesize modifyDate;
@synthesize countryCode;
@synthesize language;

- (id)initWithFileType:(NSString*)fileTypeValue 
              fileName:(NSString *)fileNameValue
                   url:(NSString *)urlValue
               webSite:(NSString *)webSiteValue
           webSiteName:(NSString *)webSiteNameValue
         totalDownload:(int)totalDownloadValue
                  rank:(int)rankValue
                 score:(float)scoreValue
            createDate:(NSDate *)createDateValue
            modifyDate:(NSDate *)modifyDateValue
           countryCode:(NSString *)countryCodeValue
              language:(NSString *)languageValue
{
    self = [super init];
    
    self.fileType = fileTypeValue;
    self.fileName = fileNameValue;
    self.url = urlValue;
    self.webSiteName = webSiteNameValue;
    self.webSite = webSiteValue;
    self.totalDownload = totalDownloadValue;
    self.rank = rankValue;
    self.score = scoreValue;
    self.createDate = createDateValue;
    self.modifyDate = modifyDateValue;
    self.countryCode = countryCodeValue;
    self.language = languageValue;
    
    return self;

}

- (void)dealloc
{
    [fileType release];
    [fileName release];
    [url release];
    [webSiteName release];
    [webSite release];
    [createDate release];
    [modifyDate release];
    [countryCode release];
    [language release];
    [super dealloc];
    
}

@end
