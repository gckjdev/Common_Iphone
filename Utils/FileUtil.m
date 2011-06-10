//
//  FileUtil.m
//  three20test
//
//  Created by qqn_pipi on 10-3-23.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "FileUtil.h"


@implementation FileUtil

+ (NSString*)getAppHomeDir
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [paths objectAtIndex:0];
	
	return documentDir;
}

+ (NSString*)getFileFullPath:(NSString*)fileName
{
	return [[FileUtil getAppHomeDir] stringByAppendingPathComponent:fileName];
}

// find database file in given databasePath, and copy it to Document directory as initialize DB
+ (BOOL) copyFileFromBundleToAppDir:(NSString *)bundleResourceFile appDir:(NSString *)appDir overwrite:(BOOL)overwrite
{
	BOOL success = NO;
	
	// init file manager
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// init path
	NSString* bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundleResourceFile];
	NSString* appPath = [NSString stringWithFormat:@"%@%@", appDir, bundleResourceFile];
	
	// check if file exist to app directory
	success = [fileManager fileExistsAtPath:appPath];
	if (success) {
//		NSLog(@"<copyFileFromBundleToAppDir> targeted file (%@) exists", appPath);
	}
	
	if (overwrite == NO && success == YES){
//		NSLog(@"<copyFileFromBundleToAppDir> don't overwrite, return");
		return YES;
	}
	
	// now copy to file	
	if ((success = [fileManager copyItemAtPath:bundlePath toPath:appPath error:nil]) == YES)
		NSLog(@"<copyFileFromBundleToAppDir> copy file from %@ to %@ successfully", bundlePath, appPath);
	else {
		NSLog(@"<copyFileFromBundleToAppDir> copy file from %@ to %@ failure", bundlePath, appPath);
	}
	
	return success;
}

+ (NSURL*)bundleURL:(NSString*)filename
{
    if (filename == nil)
        return nil;
    
	NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",filename]];
	NSURL* url = [NSURL fileURLWithPath:path];	    
    return url;
}

@end
