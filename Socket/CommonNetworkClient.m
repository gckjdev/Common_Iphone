//
//  CommonNetworkClient.m
//  TestProtocolBuffer
//
//  Created by  on 11-12-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommonNetworkClient.h"

@implementation CommonNetworkClient

@synthesize asyncSocket;
@synthesize workingQueue;
@synthesize serverHost;
@synthesize serverPort;
@synthesize reconnectTimer;
@synthesize needReconnect;
@synthesize delegate;

- (id)init
{
    self = [super init];
    self.workingQueue = dispatch_queue_create("CommonNetworkClient", NULL);
    return self;
}

- (void)dealloc
{
    dispatch_release(self.workingQueue);
    self.workingQueue = NULL;
    
    [reconnectTimer release];
    [asyncSocket release];
    [serverHost release];
    [super dealloc];
}

- (void)handleData:(NSData*)data
{
    NSLog(@"Handle Data But Do Nothing, You Must Override this method!");
}

- (BOOL)sendData:(NSData*)data
{
    int TAG_HEADER = 1;
    int TAG_DATA = 2;
    
    if ([data length] == 0){
        NSLog(@"WARNING, Send Data But Data Length = 0");
        return YES;
    }
    
    if ([asyncSocket isConnected] == NO){
        return NO;
    }
    
    dispatch_async(self.workingQueue, ^{
        int TAG_BOTH = 3;
        
        int len = [data length];    
        uint32_t netInt = CFSwapInt32HostToBig(len);    
        NSMutableData* headerData = [NSMutableData dataWithBytes:(uint8_t*)(&netInt) length:sizeof(netInt)];
//        [finalData appendData:data];
        [asyncSocket writeData:headerData withTimeout:-1 tag:TAG_HEADER];        
        [asyncSocket writeData:data withTimeout:-1 tag:TAG_DATA];        
    });
    
    return YES;
}

- (void)stopReconnectTimer
{
    NSLog(@"stopReconnectTimer");

    [self.reconnectTimer invalidate];
    self.reconnectTimer = nil;
}

#define RECONNECT_TIMER_INTERVAL    1   // 1 seconds

- (void)startReconnectTimer
{
    // stop timer if any
    [self stopReconnectTimer];
        
    NSLog(@"startReconnectTimer");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:RECONNECT_TIMER_INTERVAL
                                                               target:self 
                                                             selector:@selector(reconnect:) 
                                                             userInfo:nil 
                                                              repeats:NO];
    });
    
}

- (void)reconnect:(NSTimer*)timer
{    
    if (!self.needReconnect)
        return;
        
    NSLog(@"Reconnecting...");
    [self connect:serverHost port:serverPort];
}

- (void)connect:(NSString*)host port:(int)port
{
    [self connect:host port:port autoReconnect:YES];
}

- (void)connect:(NSString*)host port:(int)port autoReconnect:(BOOL)autoReconnect
{            
    dispatch_async(self.workingQueue, ^{
        
        
        if (asyncSocket && ([self.asyncSocket isConnected] == YES)){
            NSLog(@"Connecting to Host(%@) Port(%d) But Already Connected?", host, port);
            return;
        }
        
        // set flag
        self.needReconnect = autoReconnect;

        [self stopReconnectTimer];
        
        self.serverHost = host;
        self.serverPort = port;        
        self.asyncSocket = [[[GCDAsyncSocket alloc] initWithDelegate:self 
                                                       delegateQueue:self.workingQueue] 
                            autorelease];
        NSError *err = nil;
        [asyncSocket connectToHost:host onPort:port error:&err];    
        NSLog(@"Connecting to Host(%@) Port(%d) Error(%@)", host, port, [err description]);        
    });
    
    return;
}

- (void)disconnect
{
    dispatch_async(self.workingQueue, ^{
        
        [self setNeedReconnect:NO];        
        [self stopReconnectTimer];
        
        NSLog(@"<disconnect>");
        if (asyncSocket){
            [asyncSocket disconnect];
            self.asyncSocket = nil;
        }
    });
}


#pragma GCD Socket Delegate
#pragma mark -

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    NSLog(@"<socketDidCloseReadStream>");
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"<socketDidDisconnect> error = %@", [err description]);
    self.asyncSocket = nil;
    
    if (err != nil){
        if (delegate && [delegate respondsToSelector:@selector(didBroken)]){
            [delegate didBroken];
        }
    }
    
    if ([self needReconnect]){
        [self startReconnectTimer];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"<didWriteDataWithTag> tag = %ld", tag);
}

- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"<didReadData> data length=%d, tag = %ld", [data length], tag);    
    if (tag == READ_TAG_LENGTH)
    {
        int* bodyLength = (int*)[data bytes];
        int len = ntohl(*bodyLength);
        NSLog(@"<didReadData> header length read, length = %d", len);
        [asyncSocket readDataToLength:len withTimeout:COMMON_NETWORK_READ_TIMEOUT tag:READ_TAG_DATA];
    }
    else if (tag == READ_TAG_DATA)
    {
        // business logci here
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleData:data];
        });
                
        // Start reading the next response
        [asyncSocket readDataToLength:4 withTimeout:-1 tag:1];
    }
}

- (void)startReadLength
{
    [asyncSocket readDataToLength:4     // length size is 4 (int32)
                      withTimeout:COMMON_NETWORK_READ_TIMEOUT 
                              tag:READ_TAG_LENGTH];
}

- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Host(%@) Port(%d) Connected", host, port);
    
    if (delegate && [delegate respondsToSelector:@selector(didConnected)]){
        [delegate didConnected];
    }
    
    [self startReadLength];
}     



@end
