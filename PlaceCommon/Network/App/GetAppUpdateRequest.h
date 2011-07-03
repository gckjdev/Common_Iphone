//
//  GetAppUpdate.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface GetAppUpdateInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;

@end

@interface GetAppUpdateOutput : CommonOutput
{
	NSString*		version;    // new app version
    NSString*       appURL;     // new app download URL
    NSString*       sinaAppKey;
    NSString*       sinaAppSecret;
    NSString*       qqAppKey;
    NSString*       qqAppSecret;
    NSString*       renrenAppKey;
    NSString*       renrenAppSecret;
    
}

@property (nonatomic, retain) NSString*       version;    // new app version
@property (nonatomic, retain) NSString*       appURL;     // new app download URL
@property (nonatomic, retain) NSString*       sinaAppKey;
@property (nonatomic, retain) NSString*       sinaAppSecret;
@property (nonatomic, retain) NSString*       qqAppKey;
@property (nonatomic, retain) NSString*       qqAppSecret;
@property (nonatomic, retain) NSString*       renrenAppKey;
@property (nonatomic, retain) NSString*       renrenAppSecret;

@end

@interface GetAppUpdateRequest : NetworkRequest {
	
}

+ (GetAppUpdateOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId;

@end
