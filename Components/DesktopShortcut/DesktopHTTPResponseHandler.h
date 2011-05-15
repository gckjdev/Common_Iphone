//
//  DesktopHTTPResponseHandler.h
//  TouchIcon
//
//  Created by penglzh on 11-2-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPResponseHandler.h"


@interface DesktopHTTPResponseHandler : HTTPResponseHandler {

}

+ (void)setPageData:(NSData *)data;
+ (NSData *)getPageData;
+ (void)setPageData:(NSData *)data forKey:(NSString*)key;
+ (NSData *)getPageData:(NSString*)key;
+ (BOOL)hasData;
+ (void)cleanAllData;

@end
