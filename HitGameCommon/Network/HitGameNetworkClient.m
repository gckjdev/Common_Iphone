//
//  HitGameNetworkClient.m
//  TestProtocolBuffer
//
//  Created by  on 11-12-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "HitGameNetworkClient.h"
#import "Game.pb.h"

@implementation HitGameNetworkClient

static HitGameNetworkClient *_shareClient;

@synthesize gameDelegate;

- (void)dealloc
{
    [super dealloc];
}

+ (HitGameNetworkClient*)shareClient
{
    if (_shareClient == nil){
        _shareClient = [[HitGameNetworkClient alloc] init];        
        _shareClient.gameDelegate = _shareClient;
        _shareClient.delegate = _shareClient;
    }
    
    return _shareClient;
}

#pragma Common Network Delegate
#pragma mark -

- (void)didConnected
{
    NSLog(@"Server connected");    
}

- (void)didBroken
{
    NSLog(@"Server connection broken");
}

#pragma Game Delegate
#pragma mark -

- (void)recvNewGameResponse:(int)resultCode game:(Game *)game
{
    NSLog(@"recvNewGameResponse, result = %d, game = (%@) (%@) (%@)", 
          resultCode, game.gameId, game.name, game.host);    
}

#pragma Game Logic
#pragma mark -

- (void)handleData:(NSData*)data
{
    GameResponse *response = [GameResponse parseFromData:data];
    NSLog(@"[RECV] response code = %d", response.resultCode);

    if ([response hasNewGameResp]){
        NewGameResponse *newGameResp = [response newGameResp];
        Game* game = [newGameResp game];
//        NSLog(@"NewGameResp (%@) (%@) (%@)", game.gameId, game.name, game.host);
        
        if (gameDelegate && [gameDelegate respondsToSelector:@selector(recvNewGameResponse:game:)]){
            [gameDelegate recvNewGameResponse:response.resultCode game:game];
        }
    }
}

- (BOOL)sendNewGameRequest:(NSString*)gameName userId:(NSString*)userId
{
    GameRequest_Builder *requestBuilder = [[GameRequest_Builder alloc] init];
    NewGameRequest_Builder *newGameRequestBuilder = [[NewGameRequest_Builder alloc] init];
    
    [newGameRequestBuilder setName:gameName];
    [newGameRequestBuilder setUserId:userId];
    
    [requestBuilder setId:time(0)];
    [requestBuilder setCommand:GameRequest_CommandTypeNewGame];
    [requestBuilder setNewGameCommand:[newGameRequestBuilder build]];
    
    GameRequest *request = [requestBuilder build];
    [self sendData:[request data]];    
    
    [requestBuilder release];
    [newGameRequestBuilder release];    
    
    return YES;
}

@end
