//
//  CommonNetworkClient.h
//  TestProtocolBuffer
//
//  Created by  on 11-12-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

#define READ_TAG_LENGTH                 1
#define READ_TAG_DATA                   2

#define COMMON_NETWORK_READ_TIMEOUT     (-1)

@protocol CommonNetworkClientDelegate <NSObject>

@optional

- (void)didConnected;
- (void)didBroken;

@end

@interface CommonNetworkClient : NSObject<GCDAsyncSocketDelegate>

@property (nonatomic, retain) GCDAsyncSocket *asyncSocket;
@property (nonatomic, copy)   NSString *serverHost;
@property (atomic, retain)    NSTimer *reconnectTimer;
@property (atomic, assign)    BOOL needReconnect;
@property (nonatomic, assign) int serverPort;
@property (nonatomic, assign) dispatch_queue_t workingQueue;
@property (nonatomic, assign) id<CommonNetworkClientDelegate> delegate;

// operations
- (void)connect:(NSString*)host port:(int)port;
- (void)connect:(NSString*)host port:(int)port autoReconnect:(BOOL)autoReconnect;
- (void)disconnect;
- (BOOL)sendData:(NSData*)data;

// method for override
- (void)handleData:(NSData*)data;

@end
