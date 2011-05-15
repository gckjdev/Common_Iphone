//
//  UploadContact.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-5.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "UploadContact.h"
#import "JSON.h"

@implementation ContactForUpload

@synthesize contactId, name, mobile, email, person;

- (void)dealloc
{
	[contactId release];
	[name release];
	[mobile release];
	[email release];
	
	[super dealloc];
}

+ (id)contactWithABPerson:(ABRecordRef)person
{
	if (person == NULL)
		return nil;
	
	ContactForUpload* contact = [[[ContactForUpload alloc] init] autorelease];
	if (contact != nil){
		contact.name = [AddressBookUtils getFullName:person];
		contact.mobile = [AddressBookUtils getFirstMobilePhone:person];
		contact.email = [AddressBookUtils getFirstEmail:person];
		contact.contactId = [NSString stringWithInt:ABRecordGetRecordID(person)];
		contact.person = person;
		
		if (contact.mobile == nil && contact.email == nil){
			return nil;
		}
		else if (contact.mobile == nil){
			contact.mobile = @"";
		}
		else if (contact.email == nil){
			contact.email = @"";
		}

	}
	
	return contact;
}

- (NSDictionary*)toDictionary
{
	NSMutableDictionary* dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:name forKey:PARA_CONTACTNAME];
	[dict setObject:mobile forKey:PARA_CONTACTMOBILE];
	[dict setObject:email forKey:PARA_CONTACTEMAIL];
	[dict setObject:contactId forKey:PARA_CONTACTID];
	
	return dict;
}

- (NSString*)toJSONString
{
	return [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\"}",
			PARA_CONTACTNAME, name,
			PARA_CONTACTMOBILE, [mobile phoneNumberFilter2],
			PARA_CONTACTEMAIL, email,
			PARA_CONTACTID, contactId];
}

@end


@implementation UploadContact

+ (NSArray*)getAllContactForUpload:(ABAddressBookRef)addressBook
{
	NSArray* allPeople = (NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
	NSMutableArray* contactForUploadArray = [[[NSMutableArray alloc] init] autorelease];
	
	int size = [allPeople count];
	for (int i=0; i<size; i++){
		ABRecordRef person = [allPeople objectAtIndex:i];
		ContactForUpload* contact = [ContactForUpload contactWithABPerson:person];
		if (contact != nil){
			[contactForUploadArray addObject:contact];
		}
	}
	
	[allPeople release];
	
	return contactForUploadArray;
}

+ (NSString*)jsonDataFromContactList:(NSArray*)contactList
{
	NSMutableString* retStr = [[[NSMutableString alloc] init] autorelease];
	[retStr appendFormat:@"{\"%@\":", RET_DATA];
	[retStr appendString:@"["];
	for (ContactForUpload* contact in contactList){
		if (contact == [contactList lastObject]){
			[retStr appendFormat:@"%@", [contact toJSONString]];			
		}
		else {
			[retStr appendFormat:@"%@,", [contact toJSONString]];
		}

	}
	[retStr appendString:@"]}"];
	
	return retStr;
}

+ (int)getContactId:(NSDictionary*)contactDict
{
	return [[contactDict objectForKey:@"i"] intValue];
}

+ (NSString*)getContactUserId:(NSDictionary*)contactDict
{
	return [contactDict objectForKey:@"u"];
}

+ (int)getContactStatus:(NSDictionary*)contactDict
{
	return [[contactDict objectForKey:@"s"] intValue];	
}


+ (NSArray*)uploadContact:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId contactList:(NSArray*)contactList countryTelPrefix:(NSString*)countryTelPrefix
{
	if (serverURL == nil || [serverURL length] == 0){
		NSLog(@"send uploadContact request, but serverURL is nil");
		return nil;
	}

	if (userId == nil || [userId length] == 0){
		NSLog(@"send uploadContact request, but userId is nil");
		return nil;
	}
	
	if (countryTelPrefix == nil || [countryTelPrefix length] == 0){
		NSLog(@"send uploadContact request, but userId is nil");
		return nil;
	}
	
	//	if (contactList == nil || [contactList size] == 0){
//		NSLog(@"send uploadContact request, but contactList is nil");
//		return nil;
//	}
	
	NSString* urlString = [[NSString stringWithFormat:@"%@m=fu&uid=%@&app=%@&ct=%@", serverURL, userId, appId, countryTelPrefix] stringByURLEncode];		
	if (urlString == nil){
		NSLog(@"send uploadContact request, but URL is nil");
		return nil;
	}
	
	urlString = [NetworkRequest appendTimeStampAndMacToURL:urlString];
	
//	BOOL result = NO;	
	NSURL* url = [NSURL URLWithString:urlString];	
	if (url == nil){
		NSLog(@"send uploadContact, but URL(%@) incorrect", urlString);
		return NO;
	}
	
	// @"{ \"dat\" : [ { \"na\" : \"benson peng\", \"mo\" : \"13802538605\", \"em\" : \"lingzhe@21cn.com\", \"id\" : \"123\" } ] }"
	NSString* contactTextData = [UploadContact jsonDataFromContactList:contactList];
	NSData* postData = [contactTextData dataUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];	
	[request addValue:@"gzip" forHTTPHeaderField:@"Accepts-Encoding"];
	[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];  
	[request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%llu", [postData length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:postData];	
	
	if (request == nil){
		NSLog(@"send uploadContact, but NSMutableURLRequest is nil");
		return NO;
	}
	
	NSError* error = nil;
	NSURLResponse* response = nil;
	
	// Send request by the connection
	NSLog(@"Send http request=%@, post data=%@", urlString, contactTextData);
	NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
	NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;	
	if (error != nil) {
		NSLog(@"Send http request error, error=%@", [error localizedDescription]);
	}
	else if (httpResponse == nil || (httpResponse.statusCode / 100) != 2) {
		NSLog(@"HTTP response failure, code=%d", httpResponse.statusCode);
		return NO;
	} 
	else {		
		if (data != nil){
			NSString* textData = [[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding] autorelease];		
			NSLog(@"response data=%@", textData);
			
			NSDictionary* dict = [textData JSONValue];
			NSArray* contactIdList = [dict objectForKey:RET_DATA];
			
			for (NSDictionary* contactDict in contactIdList){
				NSLog(@"<debug> Return contactUserId=%@, contactId=%@, status=%@", 
					  [contactDict objectForKey:@"u"],
					  [contactDict objectForKey:@"i"],
					  [contactDict objectForKey:@"s"]);
			}
			
			return contactIdList;
		}
	}	
	
	return nil;
	
}

+ (NSArray*)updateContact:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId contactList:(NSArray*)contactList countryTelPrefix:(NSString*)countryTelPrefix
{
	if (serverURL == nil || [serverURL length] == 0){
		NSLog(@"send updateContact request, but serverURL is nil");
		return nil;
	}
	
	if (userId == nil || [userId length] == 0){
		NSLog(@"send updateContact request, but userId is nil");
		return nil;
	}
	
	if (countryTelPrefix == nil || [countryTelPrefix length] == 0){
		NSLog(@"send updateContact request, but userId is nil");
		return nil;
	}
	
	//	if (contactList == nil || [contactList size] == 0){
	//		NSLog(@"send uploadContact request, but contactList is nil");
	//		return nil;
	//	}
	
	NSString* urlString = [[NSString stringWithFormat:@"%@m=uc&uid=%@&app=%@&ct=%@", serverURL, userId, appId, countryTelPrefix] stringByURLEncode];		
	if (urlString == nil){
		NSLog(@"send updateContact request, but URL is nil");
		return nil;
	}
	
	urlString = [NetworkRequest appendTimeStampAndMacToURL:urlString];
	
//	BOOL result = NO;	
	NSURL* url = [NSURL URLWithString:urlString];	
	if (url == nil){
		NSLog(@"send updateContact, but URL(%@) incorrect", urlString);
		return NO;
	}
	
	// @"{ \"dat\" : [ { \"na\" : \"benson peng\", \"mo\" : \"13802538605\", \"em\" : \"lingzhe@21cn.com\", \"id\" : \"123\" } ] }"
	NSString* contactTextData = [UploadContact jsonDataFromContactList:contactList];
	NSData* postData = [contactTextData dataUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];	
	[request addValue:@"gzip" forHTTPHeaderField:@"Accepts-Encoding"];
	[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];  
	[request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%llu", [postData length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:postData];	
	
	if (request == nil){
		NSLog(@"send updateContact, but NSMutableURLRequest is nil");
		return NO;
	}
	
	NSError* error = nil;
	NSURLResponse* response = nil;
	
	// Send request by the connection
	NSLog(@"Send http request=%@, post data=%@", urlString, contactTextData);
	NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
	NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;	
	if (error != nil) {
		NSLog(@"Send http request error, error=%@", [error localizedDescription]);
	}
	else if (httpResponse == nil || (httpResponse.statusCode / 100) != 2) {
		NSLog(@"HTTP response failure, code=%d", httpResponse.statusCode);
		return NO;
	} 
	else {		
		if (data != nil){
			NSString* textData = [[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding] autorelease];		
			NSLog(@"response data=%@", textData);
			
			NSDictionary* dict = [textData JSONValue];
			NSArray* contactIdList = [dict objectForKey:RET_DATA];
			
			for (NSDictionary* contactDict in contactIdList){
				NSLog(@"<debug> Return contactUserId=%@, contactId=%@, status=%@", 
					  [contactDict objectForKey:@"u"],
					  [contactDict objectForKey:@"i"],
					  [contactDict objectForKey:@"s"]);
			}
			
			return contactIdList;
		}
	}	
	
	return nil;
	
}


@end
