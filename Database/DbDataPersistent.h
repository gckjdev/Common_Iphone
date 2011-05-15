//
//  DbDataPersistent.h
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-5.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"

// return maximum row number in query SQL
#define kMaxRecordNum 1000
#define kDbNoRestriction -1

@interface DbDataPersistent : NSObject {

	sqlite3  *database;	
	NSString *dataFile;
}

@property (nonatomic, retain) NSString *dataFile;
@property sqlite3 *database;

- (NSMutableArray *)query:(NSString *)sql maxReordNum:(int)maxRecordNum;
- (BOOL)execute:(NSString *)sql;
- (void)close;
- (BOOL)open:(NSString *)dbFileName tableSql:(NSArray *)tableSql;
- (NSString *)dataFilePath:(NSString *)dbFileName;

- (int)getMaxRecordNum:(int)num;

-(void) checkAndCreateDatabase:(NSString *)databasePath databaseName:(NSString *)databaseName;


@end
