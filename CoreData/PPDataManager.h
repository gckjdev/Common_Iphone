//
//  PPDataManager.h
//  FreeMusic
//
//  Created by qqn_pipi on 10-10-10.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataUtil.h"

@interface PPDataManager : NSObject {

}

+ (id)manager;

- (BOOL)createDataFromFile:(NSString*)filePath;

// virtual method, invoke by createDataFromFile, for sub class to implement
- (void)createItem:(NSDictionary*)item position:(int)position dataManager:(CoreDataManager*)dataManager;

@end
