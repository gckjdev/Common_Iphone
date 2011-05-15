//
//  BasicManager.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-6.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "BasicManager.h"


@implementation BasicManager

@synthesize db;

+ (void)init
{
	[super init];
}

- (id)initWithDb:(DbDataPersistent* )database
{
	if (self = [super init]){
		NSLog(@"Basic Manager, Init With Db");
		self.db = database;
	}
	
	return self;
}

- (BOOL)beginTransaction
{
	return [self.db execute:@"begin transaction"];	
}

- (BOOL)commitTransaction
{
	return [self.db execute:@"commit transaction"];	
}

- (void)dealloc
{
	NSLog(@"Basic Manager, Dealloc");
	[db release];
	[super dealloc];
}

@end
