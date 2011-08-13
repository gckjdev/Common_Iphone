//
//  CoreDataUtil.h
//  Redial
//
//  Created by Peng Lingzhe on 9/28/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject {

	NSString* dbName;
	NSString* dataModelName;
	
@private
    NSManagedObjectContext			*managedObjectContext;
    NSManagedObjectModel			*managedObjectModel;
    NSPersistentStoreCoordinator	*persistentStoreCoordinator;	
	dispatch_queue_t				dbWorkingQueue;
}

@property (nonatomic, retain) NSString* dbName;
@property (nonatomic, retain) NSString* dataModelName;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, assign, readonly) dispatch_queue_t dbWorkingQueue;

+ (id)dataManager;
- (id)initWithDBName:(NSString*)name dataModelName:(NSString*)dmName;
- (id)initWithDBName:(NSString*)name dataModelName:(NSString*)dmName hasWorkingQueue:(BOOL)hasWorkingQueue sharePersisitentStore:(NSPersistentStoreCoordinator*)sharePersisitentStore;

- (NSString *)applicationDocumentsDirectory;

- (BOOL)save;
- (id)insert:(NSString*)entityName;
- (BOOL)del:(NSManagedObject*)object;

- (NSArray*)execute:(NSString*)fetchRequestName;
- (NSArray*)execute:(NSString*)fetchRequestName sortBy:(NSString*)keyName ascending:(BOOL)ascending;
- (NSObject*)execute:(NSString*)fetchRequestName forKey:(NSString*)primaryKey value:(NSObject*)value;
- (NSArray*)execute:(NSString*)fetchRequestName forKey:(NSString*)key value:(NSObject*)value sortBy:(NSString*)sortKey ascending:(BOOL)ascending;
- (NSArray*)execute:(NSString*)fetchRequestName keyValues:(NSDictionary*)keyValues sortBy:(NSString*)sortKey ascending:(BOOL)ascending;

//- (BOOL)saveInQueue;
//- (id)insertInQueue:(NSString*)entityName;
//- (BOOL)delInQueue:(NSManagedObject*)object;
//
//- (NSArray*)executeInQueue:(NSString*)fetchRequestName;
//- (NSArray*)executeInQueue:(NSString*)fetchRequestName sortBy:(NSString*)keyName ascending:(BOOL)ascending;
//- (NSObject*)executeInQueue:(NSString*)fetchRequestName forKey:(NSString*)primaryKey value:(NSObject*)value;
//- (NSArray*)executeInQueue:(NSString*)fetchRequestName forKey:(NSString*)key value:(NSObject*)value sortBy:(NSString*)sortKey ascending:(BOOL)ascending;


@end

CoreDataManager* GlobalGetCoreDataManager();