//
//  TopDownloadItem.h
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopDownloadItem : NSObject

@property (nonatomic, retain) NSString *fileType;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *webSite;
@property (nonatomic, retain) NSString *webSiteName;
@property (nonatomic, assign) int totalDownload;
@property (nonatomic, assign) int rank;
@property (nonatomic, assign) float score;
@property (nonatomic, retain) NSDate *createDate;
@property (nonatomic, retain) NSDate *modifyDate;
@property (nonatomic, retain) NSString *countryCode;
@property (nonatomic, retain) NSString *language;

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
              language:(NSString *)languageValue;

@end
