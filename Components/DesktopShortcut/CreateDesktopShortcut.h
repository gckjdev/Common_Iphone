//
//  CreateDesktopShortcut.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-2-16.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kShortcutURLPrefixCall		@"$$$$1"
#define kShortcutURLPrefixSms		@"sms://"
#define kShortcutURLPrefixFaceTime	@"$$$$3"
#define kShortcutURLPrefixEmail		@"mailto:"
#define kShortcutURLPrefixURL		@"$$$$5"

enum ShortcutType {
	kShortcutTypeCall,
	kShortcutTypeSms,
	kShortcutTypeFaceTime,
	kShortcutTypeEmail,
	kShortcutTypeURL
};

@interface CreateDesktopShortcut : NSObject {

}

+ (NSString *)createPageWithName:(NSString *)name icon:(NSData *)icon startupImage:(NSData *)startupImage type:(int)type value:(NSString *)value messageInBrowser:(NSString*)messageInBrowser  appURI:(NSString*)appURI;

@end
