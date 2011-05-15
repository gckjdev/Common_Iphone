//
//  GoogleTranslateAPI.h
//  FreeSMS
//
//  Created by Peng Lingzhe on 1/11/11.
//  Copyright 2011 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>

//	[GoogleTranslateAPI translateFrom:@"en" targetLang:@"zh-CN" text:@"Hello World"];
//	[GoogleTranslateAPI translateCnToTw:@"中国加油！"];

@interface GoogleTranslateAPI : NSObject {

}

+ (NSString*)translateFrom:(NSString*)sourceLang targetLang:(NSString*)targetLang text:(NSString*)text;
+ (NSString*)translateCnToTw:(NSString*)text;

@end
