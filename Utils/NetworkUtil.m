//
//  NetworkUtil.m
//  three20test
//
//  Created by qqn_pipi on 10-4-14.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "NetworkUtil.h"
#import "Reachability.h"

@implementation NetworkUtil

+ (BOOL) connectedToNetwork
{
	Reachability* reach1 = [Reachability reachabilityForInternetConnection];
//	Reachability* reach2 = [Reachability reachabilityForLocalWiFi];
	
	if ( [reach1 currentReachabilityStatus] == NotReachable ){
		return NO;
	}
	else {
		return YES;
	}

}

+ (int)sendRequest:(NSURLRequest*)request respnoseHandlerBlock:(HTTPResponseHandlerBlock)respnoseHandlerBlock
{   
    NSLog(@"<sendRequest> send request URL=%@", [request description]);
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"<sendRequest> recv response : status=%d, error=%@", [response statusCode], [error description]);
    
    if (data != nil){
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"<sendRequest> recv data : %@", text);
        if (200 == [response statusCode]){
            respnoseHandlerBlock(text);
        }        
        [text release];            
        
        return response.statusCode;
    }         
    else if (200 == [response statusCode]) {
        return 0;
    }
    else{
        return response.statusCode;        
    }    
}

@end
