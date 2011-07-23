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
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    if (request == nil){
        output.resultCode = ERROR_CLIENT_REQUEST_NULL;
        return output;
    }
    
    NSLog(@"[SEND] URL=%@", [request description]);    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"[RECV] : status=%d, error=%@", [response statusCode], [error description]);
    
    if (response == nil){
        output.resultCode = ERROR_NETWORK;
    }
    else if (response.statusCode != 200){
        output.resultCode = response.statusCode;
    }
    else{
        if (data != nil){
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"[RECV] data : %@", text);
            
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
