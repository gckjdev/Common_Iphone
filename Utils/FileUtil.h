//
//  FileUtil.h
//  three20test
//
//  Created by qqn_pipi on 10-3-23.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileUtil : NSObject {

}

+ (NSString*)getAppHomeDir;
+ (NSString*)getFileFullPath:(NSString*)fileName;
+ (BOOL) copyFileFromBundleToAppDir:(NSString *)bundleResourceFile appDir:(NSString *)appDir overwrite:(BOOL)overwrite;
+ (NSURL*)bundleURL:(NSString*)filename;

@end
