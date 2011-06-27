//
//  UpdateUser.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface UpdateUserInput : NSObject {
    
	NSString*		appId;
    NSString*       userId;
    
    NSString*       mobile;
    NSString*       email;
    NSString*       nickName;
    NSString*       password;
    NSData*         avatar;
	
}

@property (nonatomic, retain) NSString*       appId;
@property (nonatomic, retain) NSString*       userId;
@property (nonatomic, retain) NSString*       mobile;
@property (nonatomic, retain) NSString*       email;
@property (nonatomic, retain) NSString*       nickName;
@property (nonatomic, retain) NSString*       password;
@property (nonatomic, retain) NSData*         avatar;

@end

@interface UpdateUserOutput : CommonOutput {
    NSString*           avatarURL;
}

@property (nonatomic, retain) NSString	*avatarURL;

@end

@interface UpdateUserRequest : NetworkRequest {
	
}

+ (UpdateUserOutput*)send:(NSString*)serverURL
                   userId:(NSString*)userId
                    appId:(NSString*)appId
                   mobile:(NSString*)mobile
                    email:(NSString*)email                 
                 password:(NSString*)password                
                 nickName:(NSString*)nickName
                   avatar:(NSData*)avatar;

@end
