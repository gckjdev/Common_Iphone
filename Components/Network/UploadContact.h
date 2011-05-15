//
//  UploadContact.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-5.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"
#import "AddressBookUtils.h"

@interface ContactForUpload : NSObject
{
	NSString	*name;
	NSString	*contactId;
	NSString	*mobile;
	NSString	*email;
	
	ABRecordRef	person;
}

@property (nonatomic, retain) NSString	*name;
@property (nonatomic, retain) NSString	*contactId;
@property (nonatomic, retain) NSString	*mobile;
@property (nonatomic, retain) NSString	*email;
@property (nonatomic, assign) ABRecordRef	person;

+ (id)contactWithABPerson:(ABRecordRef)person;

@end


@interface UploadContact : NSObject {

}

+ (NSArray*)uploadContact:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId contactList:(NSArray*)contactList countryTelPrefix:(NSString*)countryTelPrefix;
+ (NSArray*)updateContact:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId contactList:(NSArray*)contactList countryTelPrefix:(NSString*)countryTelPrefix;
+ (NSArray*)getAllContactForUpload:(ABAddressBookRef)addressBook;

+ (int)getContactId:(NSDictionary*)contactDict;
+ (NSString*)getContactUserId:(NSDictionary*)contactDict;
+ (int)getContactStatus:(NSDictionary*)contactDict;



@end
