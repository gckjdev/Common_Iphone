//
//  StringUtil.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-10.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "StringUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"
#import "pinyin.h"

NSString* pinyinStringFirstLetter(unsigned short hanzi)
{
	char c = pinyinFirstLetter(hanzi);
	return [NSString stringWithFormat:@"%c", c];
}

BOOL NSStringIsValidEmail(NSString *checkString)
{
	BOOL sticterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
	
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = sticterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:checkString];
}

BOOL NSStringIsValidPhone(NSString *checkString)
{
	NSString *regex = @"[\\+0-9]+";
	NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	return [test evaluateWithObject:checkString];
}

@implementation NSString (NSStringUtil)



- (NSString *)pinyinFirstLetter
{
	if ([self length] > 0){
		return pinyinStringFirstLetter([self characterAtIndex:0]);
	}
	else {
		return @"";
	}
}

+ (NSString *)stringWithInt:(int)value
{
	return [NSString stringWithFormat:@"%d", value];
}

+ (NSString *)GetUUID
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return [(NSString *)string autorelease];
}

// filter " ", "+", "(", ")", "-"
- (NSString *)phoneNumberFilter
{
	NSString* str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"+" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];	
	return str;
}

- (NSString *)phoneNumberFilter2
{
	// performance can be improved later
	NSString* str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];	
	return str;
}

- (NSNumber *)toNumber
{
	return [NSNumber numberWithInt:[self intValue]];
}

- (NSArray *)emailStringToArray
{	
	NSString* str = [NSString stringWithString:self];
	
	// remove space and line break
	str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		   
	// return by ; or , or space
	NSCharacterSet* charSet = [NSCharacterSet characterSetWithCharactersInString:@",; "];
	NSArray* emailArray = [str componentsSeparatedByCharactersInSet:charSet];
	
	NSMutableArray* retArray = [[[NSMutableArray alloc] init] autorelease];
	for (NSString* str in emailArray){
		NSString* email = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if (email && [email length] > 0){
			[retArray addObject:email];
		}
	}
	
	return retArray;
}

- (NSString *)stringByURLEncode
{
	NSMutableString* escaped = [NSMutableString stringWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];       
//	[escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	
	return escaped;
}

- (NSString *)encodedURLParameterString 
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           CFSTR(":/=,!$&'()*+;[]@#?"),
                                                                           kCFStringEncodingUTF8);
	return [result autorelease];
}


- (NSString *)stringByAddQueryParameter:(NSString*)parameter value:(NSString*)value
{
	NSString* p = parameter;
	NSString* v = value;
	if (p == nil)
		p = @"";
	if (v == nil)
		v = @"";
	
	return [self stringByAppendingFormat:@"&%@=%@", p, v];
}

- (NSString *)stringByAddQueryParameter:(NSString*)parameter boolValue:(BOOL)value
{
	NSString* p = parameter;
	if (p == nil)
		p = @"";
	
	return [self stringByAppendingFormat:@"&%@=%d", p, value];
}

- (NSString *)stringByAddQueryParameter:(NSString*)parameter intValue:(int)value
{
	NSString* p = parameter;
	if (p == nil)
		p = @"";
	
	return [self stringByAppendingFormat:@"&%@=%d", p, value];
}

- (NSString *)stringByAddQueryParameter:(NSString*)parameter doubleValue:(double)value
{
	NSString* p = parameter;
	if (p == nil)
		p = @"";
	
	return [self stringByAppendingFormat:@"&%@=%f", p, value];
}

+ (NSString*)formatPhone:(NSString*)phone countryTelPrefix:(NSString*)countryTelPrefix
{
	NSString* retPhone = [NSString stringWithString:phone];
	
	retPhone = [retPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
	retPhone = [retPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
	retPhone = [retPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
	retPhone = [retPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	if ([retPhone hasPrefix:countryTelPrefix])
		return retPhone;
	
	if ([retPhone hasPrefix:@"+"])
		return retPhone;
	
	NSString* retPhonePlus = [NSString stringWithFormat:@"+%@", retPhone];
	if ([retPhonePlus hasPrefix:countryTelPrefix])
		return retPhonePlus;
	
	return [NSString stringWithFormat:@"%@%@", countryTelPrefix, retPhone];
}

- (NSString*)insertHappyFace
{
	return [kHappyFace stringByAppendingFormat:@" %@", self];
}

- (NSString*)insertUnhappyFace
{
	return [kUnhappyFace stringByAppendingFormat:@" %@", self];
}

- (NSString*)encode3DESBase64:(NSString*)key
{
	return [NSString TripleDES:self encryptOrDecrypt:kCCEncrypt key:key];
}

- (NSString*)decodeBase643DES:(NSString*)key
{
	return [NSString TripleDES:self encryptOrDecrypt:kCCDecrypt key:key];	
}

- (NSString*)encodeMD5Base64:(NSString*)key
{
	NSString* input = [NSString stringWithFormat:@"%@%@", self, key];	
	const char *cStr = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
	
	return [GTMBase64 stringByEncodingBytes:result length:CC_MD5_DIGEST_LENGTH];
}

+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key {
	
//	NSString* req = @"234234234234234中国";
//	NSString* rsp = nil;
//	NSString* key = @"888fdafdakfjak;";
//	
//	NSString* ret1 = [NSString TripleDES:req encryptOrDecrypt:kCCEncrypt key:key];		
//	NSLog(@"3DES/Base64 Encode Result=%@", ret1);
//	
//	NSString* ret2 = [NSString TripleDES:ret1 encryptOrDecrypt:kCCDecrypt key:key];
//	NSLog(@"3DES/Base64 Decode Result=%@", ret2);
	
	
	const void *vplainText;
	size_t plainTextBufferSize;
	
	if (encryptOrDecrypt == kCCDecrypt)
	{
		NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
		plainTextBufferSize = [EncryptData length];
		vplainText = [EncryptData bytes];
	}
	else
	{
		NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
		plainTextBufferSize = [data length];
		vplainText = (const void *)[data bytes];
	}
	
	CCCryptorStatus ccStatus;
	uint8_t *bufferPtr = NULL;
	size_t bufferPtrSize = 0;
	size_t movedBytes = 0;
	// uint8_t ivkCCBlockSize3DES;
	
	bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
	bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
	memset((void *)bufferPtr, 0x0, bufferPtrSize);
	// memset((void *) iv, 0x0, (size_t) sizeof(iv));
	
	//	NSString *key = @"123456789012345678901234";
	NSString *initVec = @"init Vec";
	const void *vkey = (const void *) [key UTF8String];
	const void *vinitVec = (const void *) [initVec UTF8String];
	
	ccStatus = CCCrypt(encryptOrDecrypt,
					   kCCAlgorithm3DES,
					   kCCOptionPKCS7Padding,
					   vkey, //"123456789012345678901234", //key
					   kCCKeySize3DES,
					   vinitVec, //"init Vec", //iv,
					   vplainText, //"Your Name", //plainText,
					   plainTextBufferSize,
					   (void *)bufferPtr,
					   bufferPtrSize,
					   &movedBytes);
	//if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
	/*else*/ if (ccStatus == kCCParamError) return @"PARAM ERROR";
	else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
	else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
	else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
	else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
	else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED";
	
	NSString *result;
	
	if (encryptOrDecrypt == kCCDecrypt)
	{
		result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr 
																length:(NSUInteger)movedBytes] 
										encoding:NSUTF8StringEncoding] 
				  autorelease];
	}
	else
	{
		NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
		result = [GTMBase64 stringByEncodingData:myData];
	}
	
	return result;
	
} 

- (BOOL)isMobileInChina
{
	if ([self length] != 11)
		return NO;
	else if ([self hasPrefix:@"13"] ||
			 [self hasPrefix:@"15"] ||
			 [self hasPrefix:@"16"] ||
			 [self hasPrefix:@"18"])
		return YES;
	else {
		return NO;
	}
}

- (NSMutableDictionary *)URLQueryStringToDictionary
{
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    if (pairs == nil || [pairs count] == 0)
        return nil;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for(NSString *pair in pairs) {
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        if([keyValue count] == 2) {
            NSString *key = [keyValue objectAtIndex:0];
            NSString *value = [keyValue objectAtIndex:1];
            [dict setObject:value forKey:key];
        }
    }    
    
    return dict;
}

+ (NSString*)floatToStringWithoutZeroTail:(float)floatValue
{
    NSString* stringFloat = [NSString stringWithFormat:@"%f",floatValue];
    const char* floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength  = 0;
    int i = length-1;
    
    for(; i >= 0; i--)
    {
        if(floatChars[i] == '0')
            zeroLength++;
        else
        {
            if(floatChars[i] =='.')
                i--;
            break;
        }  
    }
    
    NSString* returnString;
    
    if(i == -1)
        returnString  = @"0";  
    else 
        returnString = [stringFloat substringToIndex:i+1]; 
    return returnString;
}
@end

//return [retArray sortedArrayUsingComparator:^(id obj1, id obj2) {					
//	return [[((CountryData*)obj1).name pinyinFirstLetter] compare:[((CountryData*)obj2).name pinyinFirstLetter]]; 
//}];	
