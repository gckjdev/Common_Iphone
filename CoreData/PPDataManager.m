//
//  PPDataManager.m
//  FreeMusic
//
//  Created by qqn_pipi on 10-10-10.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "PPDataManager.h"
#import "JSON.h"

@implementation PPDataManager

- (void)createItem:(NSDictionary*)item position:(int)position dataManager:(CoreDataManager*)dataManager
{
}

+ (id)manager
{
	return [[[PPDataManager alloc] init] autorelease];
}

- (BOOL)createDataFromFile:(NSString*)filePath
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	
	NSString *path = [[NSBundle mainBundle] pathForResource:filePath ofType:@"txt"];
	NSString* jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
	
	// parse JSON string and save to DB
	NSDictionary* dict = [jsonString JSONValue];
	NSArray* groups = [dict objectForKey:@"items"];
	int position = 0;
	for (NSDictionary* item in groups){
		
		[self createItem:item position:position dataManager:dataManager];		
		position ++;		
	}
	
	if ([dataManager save] == YES){
		NSLog(@"create data from file(%@) successfully", path);
	}
	else {
		NSLog(@"create data from file(%@) failure", path);
	}
	
	
	return YES;
	
}


@end
