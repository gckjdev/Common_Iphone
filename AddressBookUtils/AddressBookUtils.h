//
//  AddressBookUtils.h
//  three20test
//
//  Created by qqn_pipi on 10-3-19.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

#define kGroupIdForAllGroup		(-999)

@interface PPContact : NSObject
{
	ABRecordRef	person;
	ABRecordID	personId;
	NSString	*name;
}

@property (nonatomic, assign) ABRecordRef	person;
@property (nonatomic, assign) ABRecordID	personId;
@property (nonatomic, retain) NSString		*name;

- (id)initWithPerson:(ABRecordRef)person personId:(ABRecordID)personId;
- (NSString*)stringForGroup;

@end

@interface PPGroup : NSObject
{
	ABRecordRef group;
	ABRecordID  groupId;
	NSString    *name;
}

@property (nonatomic, assign) ABRecordRef	group;
@property (nonatomic, assign) ABRecordID	groupId;
@property (nonatomic, retain) NSString		*name;

- (id)initWithGroup:(ABRecordRef)groupVal groupId:(ABRecordID)groupIdVal name:(NSString*)nameVal;

@end



@interface AddressBookUtils : NSObject {

}

// get label of phone number (e.g. Mobile, Home, etc)
+ (NSString *)getPhoneLabel:(ABMultiValueRef)phones index:(int)index;

// get full name of contact
+ (NSString *)getFullName:(ABAddressBookRef)addressBook personId:(int)personId;
+ (NSString *)getFullName:(ABRecordRef)person;

+ (NSString*)getPhoneWithPerson:(ABRecordRef)person identifier:(ABMultiValueIdentifier)identifier property:(ABPropertyID)property;

// get all phone numbers of one contact
+ (NSArray *)getPhones:(ABRecordRef)person;

// get all emails of one contact
+ (NSArray *)getEmails:(ABRecordRef)person;
+ (NSString *)getFirstEmail:(ABRecordRef)person;

// get image of contact
+ (UIImage*)getImageByPerson:(ABRecordRef)person;

+ (UIImage*)getSmallImage:(ABRecordRef)person size:(CGSize)size;
+ (NSString*)getShortName:(ABRecordRef)person;
+ (NSDate*)copyModificationDate:(ABRecordRef)person;

// set address into contact
+ (BOOL)addAddress:(ABRecordRef)person street:(NSString*)street;

// set phones into contact
+ (BOOL)addPhone:(ABRecordRef)person phone:(NSString*)phone;

// set image into contact
+ (BOOL)addImage:(ABRecordRef)person image:(UIImage*)image;

+ (NSArray *)getEmailsWithAddressBook:(ABRecordID)personId addressBook:(ABAddressBookRef)addressBook;
+ (NSArray *)getPhonesWithAddressBook:(ABRecordID)personId addressBook:(ABAddressBookRef)addressBook;

+ (BOOL)hasPhones:(ABRecordRef)person;
+ (BOOL)hasEmails:(ABRecordRef)person;
+ (BOOL)hasMobiles:(ABRecordRef)person;
+ (NSArray *)getMobilePhones:(ABRecordRef)person;
+ (NSString *)getFirstMobilePhone:(ABRecordRef)person;

+ (NSString*)getPersonNameByPhone:(NSString*)phone addressBook:(ABAddressBookRef)addressBook;
+ (ABRecordRef)getPersonByPhone:(NSString*)phone addressBook:(ABAddressBookRef)addressBook;
+ (ABRecordRef)getPersonByPhone:(NSString*)phone addressBook:(ABAddressBookRef)addressBook countryTelPrefix:(NSString*)countryTelPrefix;

+ (NSString*)getPhoneLabel:(ABRecordRef)person phone:(NSString*)phone;

+ (NSMutableArray *)queryContact:(NSString*)searchText  addressBook:(ABAddressBookRef)addressBook;
+ (NSMutableArray *)queryAllContact:(ABAddressBookRef)addressBook;
+ (NSMutableArray *)queryAllGroup:(ABAddressBookRef)addressBook;
+ (NSArray *)queryContactByGroup:(NSString*)searchText inGroup:(int)groupId addressBook:(ABAddressBookRef)addressBook;

+ (BOOL)isPersonNew:(ABRecordRef)person lastCheckDate:(NSDate*)lastCheckDate;
+ (BOOL)isPersonModify:(ABRecordRef)person lastCheckDate:(NSDate*)lastCheckDate;

+ (UIImage*)getThumbnailImage:(ABRecordRef)person;

@end
