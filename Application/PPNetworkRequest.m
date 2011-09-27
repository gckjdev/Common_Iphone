//
//  PPNetworkRequest.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PPNetworkRequest.h"
#import "StringUtil.h"
#import "JSON.h"
#import "PPNetworkConstants.h"

@implementation CommonNetworkOutput

@synthesize resultMessage, resultCode, jsonDataArray, jsonDataDict, textData, arrayData;

- (void)resultFromJSON:(NSString*)jsonString
{
	// get code and message
	NSDictionary* dict = [jsonString JSONValue];		
	self.resultCode = [[dict objectForKey:@"ret"] intValue];				
    //	self.resultMessage = [dict objectForKey:@"msg"];		
}

- (NSArray*)arrayFromJSON:(NSString*)jsonString
{
	// get array data from data object (if it's an array)
	NSDictionary* dict = [jsonString JSONValue];
	NSArray* retArray = [dict objectForKey:@"dat"];
	
	return retArray;
}

- (NSDictionary*)dictionaryDataFromJSON:(NSString*)jsonString
{
	// get array data from data object (if it's an array)
	NSDictionary* dict = [jsonString JSONValue];
	NSDictionary* retDict = [dict objectForKey:@"dat"];
	
	return retDict;
}

- (void)dealloc
{
    [arrayData release];
    [textData release];
	[resultMessage release];
    [jsonDataArray release];
    [jsonDataDict release];
	[super dealloc];
}


@end

@implementation PPNetworkRequest

+ (CommonNetworkOutput*)sendRequest:(NSString*)baseURL
         constructURLHandler:(ConstructURLBlock)constructURLHandler
             responseHandler:(PPNetworkResponseBlock)responseHandler
                      output:(CommonNetworkOutput*)output
{    
    NSURL* url = nil;    
    if (constructURLHandler != NULL)
        url = [NSURL URLWithString:[constructURLHandler(baseURL) stringByURLEncode]];
    else
        url = [NSURL URLWithString:baseURL];        
    
    if (url == nil){
        output.resultCode = ERROR_CLIENT_URL_NULL;
        return output;
    }
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    if (request == nil){
        output.resultCode = ERROR_CLIENT_REQUEST_NULL;
        return output;
    }

#ifdef DEBUG    
    NSLog(@"[SEND] URL=%@", [request description]);    
#endif
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
#ifdef DEBUG    
    NSLog(@"[RECV] : status=%d, error=%@", [response statusCode], [error description]);
#endif    
    
    if (response == nil){
        output.resultCode = ERROR_NETWORK;
    }
    else if (response.statusCode != 200){
        output.resultCode = response.statusCode;
    }
    else{
        if (data != nil){
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

#ifdef DEBUG
            NSLog(@"[RECV] data : %@", text);
#endif            
            
            NSDictionary* dataDict = [text JSONValue];
            [text release];            
            if (dataDict == nil){
                output.resultCode = ERROR_CLIENT_PARSE_JSON;
                return output;
            }
            
            output.resultCode = [[dataDict objectForKey:RET_CODE] intValue];
            responseHandler(dataDict, output);
            
            return output;
        }         
        
    }
    
    return output;
}


@end
