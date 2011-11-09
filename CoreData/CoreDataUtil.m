//
//  CoreDataUtil.m
//  Redial
//
//  Created by Peng Lingzhe on 9/28/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "CoreDataUtil.h"
#import <UIKit/UIKit.h>
#import "StringUtil.h"
#import "LogUtil.h"

#define kDefaultDBName				@"PIPIDB"
#define kDefaultDataModelName		@"MainDataModel"

CoreDataManager* GlobalGetCoreDataManager()
{
	NSObject* appDelegate = [[UIApplication sharedApplication] delegate];
	if ([appDelegate respondsToSelector:@selector(dataManager)])
		return [appDelegate performSelector:@selector(dataManager)];
	else{
		PPDebug(@"[ERROR] Cannot find data manager in GlobalGetCoreDataManager");
		return nil;
	}
}

@implementation CoreDataManager

@synthesize dbName;
@synthesize dbWorkingQueue;
@synthesize dataModelName;

+ (id)dataManager
{
	return GlobalGetCoreDataManager();
}

- (id)init
{
	if (self = [super init]){
		self.dbName = kDefaultDBName;
		self.dataModelName = kDefaultDataModelName;
		dbWorkingQueue = NULL;
	}
	
	PPDebug(@"Init CoreDataUtil, DB Name (%@)", dbName);	
	return self;
}

- (id)initWithDBName:(NSString*)name dataModelName:(NSString*)dmName 
{
	if (self = [super init]){
		if (name){
			self.dbName = name;
		}
		else {
			self.dbName = kDefaultDBName;
		}
		
		if (dataModelName){
			self.dataModelName = dmName;
		}

		[self persistentStoreCoordinator];
		[self managedObjectContext];
		[self managedObjectModel];
	}
	
	PPDebug(@"Init CoreDataUtil, DB Name (%@)", dbName);
	return self;
}

- (id)initWithDBName:(NSString*)name dataModelName:(NSString*)dmName hasWorkingQueue:(BOOL)hasWorkingQueue sharePersisitentStore:(NSPersistentStoreCoordinator*)sharePersisitentStore
{
	NSString* queueName;
	if (self = [super init]){
		if (name){
			self.dbName = name;
		}
		else {
			self.dbName = kDefaultDBName;
		}
		
		if (dataModelName){
			self.dataModelName = dmName;
		}

		persistentStoreCoordinator = sharePersisitentStore;
		[self managedObjectContext];
		[self managedObjectModel];
		
		if (hasWorkingQueue){
			queueName = [NSString stringWithFormat:@"%@_%@", dbName, [NSString GetUUID]];
			dbWorkingQueue = dispatch_queue_create([queueName cStringUsingEncoding:NSUTF8StringEncoding], NULL);
		}
	}
	
	PPDebug(@"Init CoreDataUtil, DB Name (%@) & Working Queue (%@)", dbName, queueName);
	return self;
}

- (BOOL)save
{
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            PPDebug(@"<saveChange> Unresolved error %@, %@", error, [error userInfo]);
			return NO;
        } 
		else {
			return YES;
		}
    }	
	else {
		return NO;
	}

}

- (id)insert:(NSString*)entityName
{
	PPDebug(@"<insert> %@", entityName);
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
}

- (NSArray*)execute:(NSString*)fetchRequestName
{
	NSFetchRequest* fq = [self.managedObjectModel fetchRequestFromTemplateWithName:fetchRequestName 
                                                             substitutionVariables:nil];
    
    if (fq == nil){
        PPDebug(@"<execute> execute fetch request (%@) fail, cannot create fetch request", fetchRequestName);
        return nil;
    }
	
	NSError* error = nil;
	NSArray* objects = [self.managedObjectContext executeFetchRequest:fq error:&error];
	if (error == nil){
		PPDebug(@"<execute> execute fetch request (%@) successfully, total %d record found", fetchRequestName, [objects count]);
//		for (NSObject* item in objects){
//			PPDebug(@"[Debug] result object (%@)", [item description]);
//		}
	}
	else {
		PPDebug(@"<execute> execute fetch request (%@), error=%@", fetchRequestName, [error localizedDescription]);
	}		
    
        
	return objects;
}

- (NSArray*)execute:(NSString*)fetchRequestName sortBy:(NSString*)keyName ascending:(BOOL)ascending
{
	NSFetchRequest* fq = [self.managedObjectModel fetchRequestFromTemplateWithName:fetchRequestName 
                                                             substitutionVariables:nil];
    
    if (fq == nil){
        PPDebug(@"<execute> execute fetch request (%@) fail, cannot create fetch request", fetchRequestName);
        return nil;
    }
	
	// set sorted rules
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyName ascending:ascending];
	NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
	[fq setSortDescriptors:sortDescriptors];
	[sortDescriptors release];		
	[sortDescriptor release];
	
	NSError* error = nil;
	NSArray* objects = [self.managedObjectContext executeFetchRequest:fq error:&error];
	if (error == nil){
		PPDebug(@"<execute> execute fetch request (%@) successfully, total %d record", fetchRequestName, [objects count]);
//		for (NSObject* item in objects){
//			PPDebug(@"[Debug] result object (%@)", [item description]);
//		}
	}
	else {
		PPDebug(@"<execute> execute fetch request (%@), error=%@", fetchRequestName, [error localizedDescription]);
	}		
		
    
	return objects;
}

- (NSObject*)execute:(NSString*)fetchRequestName forKey:(NSString*)primaryKey value:(NSObject*)value 
{
	if (primaryKey == nil || value == nil || fetchRequestName == nil)
		return nil;
	
	NSDictionary* dict = [NSDictionary dictionaryWithObject:value forKey:primaryKey];	
	NSFetchRequest* fq = [self.managedObjectModel fetchRequestFromTemplateWithName:fetchRequestName
														substitutionVariables:dict];
	
	NSError* error = nil;
	NSArray* objects = [self.managedObjectContext executeFetchRequest:fq error:&error];
	if (error == nil){
		PPDebug(@"<execute> execute fetch request (%@) successfully", fetchRequestName);
//		for (NSObject* item in objects){
//			PPDebug(@"[Debug] result object (%@)", [item description]);
//		}
	}
	else {
		PPDebug(@"<execute> execute fetch request (%@), error=%@", fetchRequestName, [error localizedDescription]);
	}		
	
    
	if (objects && [objects count] > 0)
		return [objects objectAtIndex:0];
	else
		return nil;
}

- (NSArray*)execute:(NSString*)fetchRequestName keyValues:(NSDictionary*)keyValues sortBy:(NSString*)sortKey ascending:(BOOL)ascending
{
	if (keyValues == nil || fetchRequestName == nil)
		return nil;
	
	NSFetchRequest* fq = [self.managedObjectModel fetchRequestFromTemplateWithName:fetchRequestName
															 substitutionVariables:keyValues];
	
    if (fq == nil){
        PPDebug(@"<execute> execute fetch request (%@) fail, key values = %@, cannot create fetch request", [keyValues description], fetchRequestName);
        return nil;
    }
    
	// set sorted rules
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
	NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
	[fq setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError* error = nil;
	NSArray* objects = [self.managedObjectContext executeFetchRequest:fq error:&error];
	if (error == nil){
		PPDebug(@"<execute> execute fetch request (%@) successfully, total %d record found", [fq description], [objects count]);
		//		for (NSObject* item in objects){
		//			PPDebug(@"[Debug] result object (%@)", [item description]);
		//		}
	}
	else {
		PPDebug(@"<execute> execute fetch request (%@), error=%@", [fq description], [error localizedDescription]);
	}		
	
    
	return objects;
}


- (NSArray*)execute:(NSString*)fetchRequestName forKey:(NSString*)key value:(NSObject*)value sortBy:(NSString*)sortKey ascending:(BOOL)ascending
{
	if (key == nil || value == nil || fetchRequestName == nil)
		return nil;
	
	NSDictionary* dict = [NSDictionary dictionaryWithObject:value forKey:key];	
	NSFetchRequest* fq = [self.managedObjectModel fetchRequestFromTemplateWithName:fetchRequestName
															 substitutionVariables:dict];
	
    if (fq == nil){
        PPDebug(@"<execute> execute fetch request (%@) fail, cannot create fetch request", [fq description]);
        return nil;
    }
    
	// set sorted rules
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
	NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
	[fq setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError* error = nil;
	NSArray* objects = [self.managedObjectContext executeFetchRequest:fq error:&error];
	if (error == nil){
		PPDebug(@"<execute> execute fetch request (%@) successfully, total %d record found", [fq description], [objects count]);
		//		for (NSObject* item in objects){
		//			PPDebug(@"[Debug] result object (%@)", [item description]);
		//		}
	}
	else {
		PPDebug(@"<execute> execute fetch request (%@), error=%@", [fq description], [error localizedDescription]);
	}		
	
    
	return objects;
}


- (BOOL)del:(NSManagedObject*)object
{
	PPDebug(@"<del> delete object (%@)", [object description]);
	[self.managedObjectContext deleteObject:object];
	return YES;	
}



#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
		PPDebug(@"Create managedObjectContext");
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
	NSString *path = [[NSBundle mainBundle] pathForResource:dataModelName ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:path];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	
//    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];   
	PPDebug(@"Create managedObjectModel");
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	NSString *dbNameWithSuffix = [NSString stringWithFormat:@"%@.sqlite", dbName];
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:dbNameWithSuffix];
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:dbName ofType:@"sqlite"];
		if (defaultStorePath) {
			if ([fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL] == YES){
				PPDebug(@"Copy DB to %@ Successfully!", storePath);
			}
			else {
				PPDebug(@"Copy DB to %@ Failure!", storePath);
				
			}
			
		}
	}
	else {
		PPDebug(@"DB %@ Exist", storePath);
	}
	
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, 
								[NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, 
								nil];	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	PPDebug(@"Create persistentStoreCoordinator");
	
	NSError *error;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		// Update to handle the error appropriately.
		PPDebug(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }    
	PPDebug(@"addPersistentStoreWithType OK!");
	
    return persistentStoreCoordinator;
}

#pragma mark Multi Thread
- (BOOL)saveInQueue
{
	__block BOOL result;
	if (dbWorkingQueue != NULL){
		dispatch_sync(dbWorkingQueue, ^{
			result = [self save];
		});
	}
	else {
		result = [self save];
	}

	return result;
}

- (id)insertInQueue:(NSString*)entityName
{
	__block NSObject* object;
	if (dbWorkingQueue != NULL){
		dispatch_sync(dbWorkingQueue, ^{
			object = [self insertInQueue:entityName];
		});
	}
	else {
		object = [self insert:entityName];
	}
	
	return object;
}

- (BOOL)delInQueue:(NSManagedObject*)object
{
	__block BOOL result;
	if (dbWorkingQueue != NULL){
		dispatch_sync(dbWorkingQueue, ^{
			result = [self del:object];
		});
	}
	else {
		result = [self del:object];
	}
	
	return result;
}

- (NSArray*)executeInQueue:(NSString*)fetchRequestName
{
	__block NSArray* object;
	if (dbWorkingQueue != NULL){
		dispatch_sync(dbWorkingQueue, ^{
			object = [self execute:fetchRequestName];
		});
	}
	else {
		object = [self execute:fetchRequestName];
	}
	
	return object;
}

- (NSArray*)executeInQueue:(NSString*)fetchRequestName sortBy:(NSString*)keyName ascending:(BOOL)ascending
{
	__block NSArray* object;
	if (dbWorkingQueue != NULL){
		dispatch_sync(dbWorkingQueue, ^{
			object = [self execute:fetchRequestName sortBy:keyName ascending:ascending];
		});
	}
	else {
		object = [self execute:fetchRequestName sortBy:keyName ascending:ascending];
	}
	
	return object;
}

- (NSObject*)executeInQueue:(NSString*)fetchRequestName forKey:(NSString*)primaryKey value:(NSObject*)value
{
	__block NSObject* object;
	if (dbWorkingQueue != NULL){
		dispatch_sync(dbWorkingQueue, ^{
			object = [self execute:fetchRequestName forKey:primaryKey value:value];
		});
	}
	else {
		object = [self execute:fetchRequestName forKey:primaryKey value:value];
	}
	
	return object;	
}

- (NSArray*)executeInQueue:(NSString*)fetchRequestName forKey:(NSString*)key value:(NSObject*)value sortBy:(NSString*)sortKey ascending:(BOOL)ascending
{
	__block NSArray* object;
	if (dbWorkingQueue != NULL){
		dispatch_sync(dbWorkingQueue, ^{
			object = [self execute:fetchRequestName forKey:key value:value sortBy:sortKey ascending:ascending];
		});
	}
	else {
		object = [self execute:fetchRequestName forKey:key value:value sortBy:sortKey ascending:ascending];
	}
	
	return object;		
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)dealloc
{		
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];
	[dataModelName release];
	[dbName release];
	
	if (dbWorkingQueue != NULL){
		dispatch_release(dbWorkingQueue);
		dbWorkingQueue = NULL;
	}
	
	[super dealloc];
}

@end
