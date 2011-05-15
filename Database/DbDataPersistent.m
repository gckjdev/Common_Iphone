//
//  DbDataPersistent.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-5.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "DbDataPersistent.h"


@implementation DbDataPersistent

@synthesize dataFile;
@synthesize database;

- (NSString *)dataFilePath:(NSString *)dbFileName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [paths objectAtIndex:0];

	return [documentDir stringByAppendingPathComponent:dbFileName];
}

- (BOOL)open:(NSString *)dbFileName tableSql:(NSArray *)tableSql
{
	// get database file path by given file name
	self.dataFile = [self dataFilePath:dbFileName];
	
	// check if database exists, if not, copy it from main bundle
	[self checkAndCreateDatabase:dataFile databaseName:dbFileName];
	
	// open database
	if (sqlite3_open([self.dataFile UTF8String], &database) != SQLITE_OK){
		NSLog(@"Fail to open db at %@", self.dataFile);
		[self close];
		return NO;
	}
	else {
		NSLog(@"Open DB at %@", self.dataFile);
	}
	
	// create table if any
	if (tableSql != nil)
		NSLog(@"Create tables...");
	for (NSString *sql in tableSql){
		if ([self execute:sql] == NO){
			[self close];			
			return NO;
		}		
	}
	
	return YES;
	
	

	
}

- (void)close
{
	NSLog(@"Close database");
	
	if (database != NULL)
		sqlite3_close(database);
	
	database = NULL;
	return;
}

// execute SQL (e.g. INSRET, DELETE, UPDATE)
- (BOOL)execute:(NSString *)sql
{	
	BOOL result = NO;
	char *errorMsg = NULL;
	if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
		NSLog(@"Execute SQL=%@, Failure! Error Msg=%s", sql, errorMsg);
		sqlite3_free(errorMsg);
	}
	else{
		result = YES;
		NSLog(@"Execute SQL=%@, Success!", sql);
		if (errorMsg != NULL){
			sqlite3_free(errorMsg);
		}
		else {
//			NSLog(@"[Debug] errorMsg is NULL, don't need to free memory");
		}
	}
	return YES;
}


- (int)getMaxRecordNum:(int)num
{
	if (num < 0)
		return kMaxRecordNum;
	else if (num > kMaxRecordNum){
		NSLog(@"Warning, given number(%d) is larger than system settings", num);
		return kMaxRecordNum;
	}
	else {
		return num;
	}

}

// execute query SQL (SELECT), return SQL result set
- (NSMutableArray *)query:(NSString *)sql maxReordNum:(int)maxRecordNum
{

	NSLog(@"Execute query(%@) maxRecordNum(%d)", sql, maxRecordNum);
	
	sqlite3_stmt *stmt = NULL;
	BOOL result = NO;
	
	NSMutableArray *dataList = [[[NSMutableArray alloc] init] autorelease];
	
	if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK){
		
		int column_count = sqlite3_column_count(stmt);
		
		int row = 0;
		int max_row = [self getMaxRecordNum:maxRecordNum];
		
		while (sqlite3_step(stmt) == SQLITE_ROW){
			
			NSMutableArray *rowData = [[NSMutableArray alloc] init];
			for (int i=0; i<column_count; i++){			
				char* text = (char *)sqlite3_column_text(stmt, i);
				if (text != nil)
					[rowData addObject:[NSString stringWithUTF8String:text]];			
				else {
					[rowData addObject:[NSString stringWithUTF8String:""]];			
				}

			}
			[dataList addObject:rowData];
			[rowData release];			
			
			row ++;
			if (row >= max_row)
				break;
		}
		
		NSLog(@"Exec query successuflly, %d row returned", row);
		
		result = YES;
	}
	else {
		NSLog(@"Execute query(%@) maxRecordNum(%d) failure(%s)", sql, maxRecordNum, sqlite3_errmsg(database));
		result = NO;
	}

	sqlite3_finalize(stmt);	
	
	return dataList;
}

- (void)dealloc
{
	[dataFile release];
	[self close];
	[super dealloc];
}

// find database file in given databasePath, and copy it to Document directory as initialize DB
-(void) checkAndCreateDatabase:(NSString *)databasePath databaseName:(NSString *)databaseName
{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if (success) {
		NSLog(@"database file (%@) exists", databasePath);
		return;
	}
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
	// Copy the database from the package to the users filesystem
	if ([fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil] == YES)
		NSLog(@"copy file to %@ successfully", databasePath);
	else {
		NSLog(@"copy file to %@ failure", databasePath);
	}

	
}

@end
