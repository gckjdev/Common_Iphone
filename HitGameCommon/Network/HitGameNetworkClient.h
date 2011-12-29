//
//  HitGameNetworkClient.h
//  TestProtocolBuffer
//
//  Created by  on 11-12-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonNetworkClient.h"
#import "Game.pb.h"

@protocol GameNetworkClientProtocol <NSObject>

- (void)recvNewGameResponse:(int)resultCode game:(Game*)game;

@end

@interface HitGameNetworkClient : CommonNetworkClient<GameNetworkClientProtocol, CommonNetworkClientDelegate>

// common

@property (nonatomic, assign) id<GameNetworkClientProtocol> gameDelegate;

+ (HitGameNetworkClient*)shareClient;

- (BOOL)sendNewGameRequest:(NSString*)gameName userId:(NSString*)userId;

@end
