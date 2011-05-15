//
//  SearchHistoryManager.h
//  three20test
//
//  Created by qqn_pipi on 10-4-7.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchHistoryManager : NSObject {

}

+ (NSMutableArray*)getHistoryText:(NSString*)key;
+ (BOOL)addHistoryText:(NSString*)key text:(NSString*)text;
+ (BOOL)clearAllHistory:(NSString*)key;
+ (BOOL)deleteTextFromHistory:(NSString*)key text:(NSString*)text;
+ (void)deleteLastRecord:(int)maxRecordToKeep key:(NSString*)key;

@end
