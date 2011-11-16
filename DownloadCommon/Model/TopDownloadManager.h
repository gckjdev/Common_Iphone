//
//  TopDownloadManager.h
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopDownloadManager : NSObject

@property (nonatomic, retain) NSMutableArray* siteList;

+ (TopDownloadManager *)defaultManager;

- (NSArray*)updateData:(NSArray*)jsonArray;


@end
