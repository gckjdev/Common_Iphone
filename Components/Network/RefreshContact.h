//
//  RefreshContact.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface RefreshContactInput : NSObject
{
	NSString*		userId;
	NSString*		appId;
	NSString*		countryTelPrefix;
}

@property (nonatomic, retain) NSString*			userId;
@property (nonatomic, retain) NSString*			appId;
@property (nonatomic, retain) NSString*			countryTelPrefix;

@end

@interface RefreshContactOutput : CommonOutput
{
	NSArray*		contactList;
}

@property (nonatomic, retain) NSArray*		contactList;

+ (int)getContactId:(NSDictionary*)contactDict;
+ (NSString*)getContactUserId:(NSDictionary*)contactDict;
+ (int)getContactStatus:(NSDictionary*)contactDict;


@end

@interface RefreshContactRequest : NetworkRequest {
	
}

+ (RefreshContactOutput*)RefreshContact:serverURL userId:(NSString*)userId appId:(NSString*)appId countryTelPrefix:(NSString*)countryTelPrefix;

@end
