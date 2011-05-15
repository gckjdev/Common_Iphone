//
//  BasicManager.h
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-6.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbDataPersistent.h"


// default manager for all manager objects

@interface BasicManager : NSObject {
	DbDataPersistent*	db;
}

@property (nonatomic, retain) DbDataPersistent *db;

+ (void)init;
- (id)initWithDb:(DbDataPersistent* )database;
- (BOOL)beginTransaction;
- (BOOL)commitTransaction;
@end
