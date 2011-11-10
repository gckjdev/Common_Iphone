//
//  DownloadItem.h
//  Download
//
//  Created by  on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DownloadItem : NSManagedObject

@property (nonatomic, retain) NSNumber * downloadSize;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSNumber * fileSize;
@property (nonatomic, retain) NSNumber * fileType;
@property (nonatomic, retain) NSNumber * starred;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * webSite;

@end
