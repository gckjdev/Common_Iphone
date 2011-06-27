//
//  SendPrivateMessage.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "SendPrivateMessageRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"
#import "ResultUtils.h"

@implementation SendPrivateMessageInput

@synthesize userId;
@synthesize contentType;
@synthesize textContent;
@synthesize latitude;
@synthesize longitude;
@synthesize syncSNS;
@synthesize appId;
@synthesize image;
@synthesize toUserId;

- (void)dealloc
{
	[appId release];
	[userId	release];
	[textContent release];
    [image release];
    [toUserId release];
	[super dealloc];	
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_SENDMESSAGE];	
    str = [str stringByAddQueryParameter:PARA_TO_USERID value:toUserId];
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_CONTENT_TYPE intValue:contentType];
	str = [str stringByAddQueryParameter:PARA_TEXT_CONTENT value:textContent];
	str = [str stringByAddQueryParameter:PARA_LATITUDE doubleValue:latitude];
	str = [str stringByAddQueryParameter:PARA_LONGTITUDE doubleValue:longitude];
	str = [str stringByAddQueryParameter:PARA_SYNC_SNS boolValue:syncSNS];
    	
	return str;
}

@end

@implementation SendPrivateMessageOutput

@synthesize messageId;
@synthesize imageURL;
@synthesize createDate;
@synthesize avatar;
@synthesize nickName;

- (void)dealloc
{
	[messageId release];
    [createDate release];
    [imageURL release];   
    [avatar release];
    [nickName release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, messageId=%@", resultCode, messageId];
}

@end



@implementation SendPrivateMessageRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[SendPrivateMessageRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[SendPrivateMessageInput class]]){
		SendPrivateMessageInput* obj = (SendPrivateMessageInput*)input;
		NSString* url = [obj createUrlString:[self getBaseUrlString]];		
		return [url stringByURLEncode];
	}
	else {
		return nil;
	}
	
}

// virtual method
- (BOOL)parseToReponse:(NSData*)data output:(NSObject*)output
{
	const void* bytes = [data bytes];
	NSString* textData = [[[NSString alloc] initWithBytes:bytes length:[data length] encoding:NSUTF8StringEncoding] autorelease];		
	NSLog(@"SendPrivateMessageRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[SendPrivateMessageOutput class]]){
		
		SendPrivateMessageOutput* obj = (SendPrivateMessageOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			// TODO
            NSDictionary* dict = [obj dictionaryDataFromJSON:textData];
            obj.messageId = [dict objectForKey:PARA_MESSAGE_ID];
            obj.nickName = [dict objectForKey:PARA_NICKNAME];
            obj.avatar = [dict objectForKey:PARA_AVATAR];
            obj.createDate = [ResultUtils createDate:dict];
			NSLog(@"SendPrivateMessageRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"SendPrivateMessageRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

+ (int)getdeviceOS
{
	return OS_IOS;
}

+ (SendPrivateMessageOutput*)send:(NSString*)serverURL 
                       fromUserId:(NSString*)fromUserId
                         toUserId:(NSString*)toUserId
                            appId:(NSString*)appId 
                      contentType:(int)contentType 
                      textContent:(NSString*)textContent
                         latitude:(double)latitude 
                        longitude:(double)longitude
                          syncSNS:(BOOL)syncSNS
                            image:(UIImage*)image;


{
	int result = ERROR_SUCCESS;
	SendPrivateMessageInput* input = [[SendPrivateMessageInput alloc] init];
	SendPrivateMessageOutput* output = [[[SendPrivateMessageOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = fromUserId;
    input.toUserId = toUserId;
	input.appId = appId;
    input.appId = appId;
    input.contentType = contentType;
    input.textContent = textContent;
    input.latitude = latitude;
    input.longitude = longitude;
    input.syncSNS = syncSNS;
    
    NSData* postData = nil;
    if (input.contentType == CONTENT_TYPE_TEXT_PHOTO && image != nil){
        postData = UIImagePNGRepresentation(image);
    }
	
	if ([[SendPrivateMessageRequest requestWithURL:serverURL] sendPostRequest:input output:output postData:postData]){
		result = output.resultCode;
	}
	else{
		output.resultCode = ERROR_NETWORK;
	}
	
	[input release];
	
	return output;	
}

+ (SendPrivateMessageOutput*)send:(NSString*)serverURL 
                       fromUserId:(NSString*)fromUserId
                         toUserId:(NSString*)toUserId
                            appId:(NSString*)appId 
                      textContent:(NSString*)textContent
{
    return [SendPrivateMessageRequest send:serverURL 
                                fromUserId:fromUserId
                                  toUserId:toUserId
                                  appId:appId 
                            contentType:CONTENT_TYPE_TEXT 
                            textContent:textContent 
                               latitude:0 
                              longitude:0 
                                syncSNS:NO 
                                  image:nil];
}


@end

