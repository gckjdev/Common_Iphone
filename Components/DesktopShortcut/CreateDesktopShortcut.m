//
//  CreateDesktopShortcut.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-2-16.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "CreateDesktopShortcut.h"
#import "GTMBase64.h"
#import "UIImageExt.h"

@implementation CreateDesktopShortcut

+ (NSString *)createPageWithName:(NSString *)name icon:(NSData *)icon startupImage:(NSData *)startupImage type:(int)type value:(NSString *)value messageInBrowser:(NSString*)messageInBrowser appURI:(NSString*)appURI{ 
	
	if (icon == nil || name == nil)
		return nil;
	
	NSString* iconString = [GTMBase64 stringByEncodingData:icon];
	NSString* startupImageString = [GTMBase64 stringByEncodingData:startupImage];
	if (iconString == nil || startupImageString == nil)
		return nil;
	
	NSMutableString *page = [[NSMutableString alloc] init];
	[page appendString:@"<head>"];
	[page appendString:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" />"];
	[page appendString:@"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />"];
	[page appendString:@"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />"];
	[page appendString:@"<meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\" />"];

	// add icon (without gloss effect)
//	[page appendString:@"<link rel=\"apple-touch-icon-precomposed\" href=\"data:image/png;base64,"];
//	[page appendString:iconString];
//	[page appendString:@"\" />"];

	// add start up image
	[page appendString:@"<link rel=\"apple-touch-startup-image\" href=\"data:image/png;base64,"];
	[page appendString:startupImageString];
	[page appendString:@"\" />"];
	
	// add icon (forbid gloss effect randomly)
	[page appendString:@"<script type=\"text/javascript\">"];
	[page appendString:@"if (!window.navigator.standalone) {"];
	[page appendString:@"document.write(\"<link rel=\\\"apple-touch-icon-precomposed\\\" href=\\\"data:image/png;base64,"];
	[page appendString:iconString];
	[page appendString:@"\\\" />\");}"];
	[page appendString:@"</script>"];
	
	[page appendString:@"<title>"];
	[page appendString:name];
	[page appendString:@"</title>"];
	[page appendString:@"</head>"];
	[page appendString:@"<body>"];
	[page appendString:@"<p>"];
	[page appendString:messageInBrowser];
	[page appendString:@"</p>"];
	
	// append shortcut action
	[page appendString:@"<a id=\"link\" href=\""];
	 
	if (kShortcutTypeCall == type) {
		[page appendString:appURI];
		[page appendString:@":"];
		[page appendString:kShortcutURLPrefixCall];
	} else if (kShortcutTypeSms == type) {
		//[page appendString:kShortcutURLPrefixSms];
		[page appendString:@"sms://"];
	} else if (kShortcutTypeEmail == type) {
		//[page appendString:kShortcutURLPrefixEmail];
		[page appendString:@"mailto:"];
	} else if (kShortcutTypeFaceTime == type) {
		[page appendString:appURI];
		[page appendString:@":"];
		[page appendString:kShortcutURLPrefixFaceTime];
	} else if (kShortcutTypeURL == type) {
		//[page appendString:kShortcutURLPrefixURL];
		if (![value hasPrefix:@"http://"] && ![value hasPrefix:@"https://"]) {
			[page appendString:@"http://"];
		}
	}	
	[page appendString:value];
	[page appendString:@"\"></a>"];
	
	[page appendString:@"<script type=\"text/javascript\">"];
	[page appendString:@"if (window.navigator.standalone) {"];
	[page appendString:@"var e = document.getElementById(\"link\");"];
	[page appendString:@"var ev = document.createEvent(\"MouseEvents\");"];
	[page appendString:@"ev.initEvent(\"click\",true,true);"];
	[page appendString:@"e.dispatchEvent(ev);}"];
	[page appendString:@"</script>"];
	[page appendString:@"</body>"];
	
	// remove escape string
	CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
	NSString *escapedStr = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)page, nil, forceEscaped, kCFStringEncodingUTF8);
	NSString *realPage = [NSString stringWithFormat:@"data:text/html;charset=UTF-8,%@", escapedStr];

	// release page string manually
	[page release];
	[escapedStr release];
	
	NSMutableString* finalPage = [NSMutableString stringWithCapacity:1500];
	[finalPage appendString:@"<html>"];
	[finalPage appendString:@"<head>"];
	[finalPage appendString:@"<meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\" />"];
	[finalPage appendString:@"</head>"];
	[finalPage appendString:@"<body>"];
	[finalPage appendString:@"<a id=\"link\" href=\""];
	[finalPage appendString:realPage];
	[finalPage appendString:@"\"></a>"];
	[finalPage appendString:@"<script type=\"text/javascript\">"];
	[finalPage appendString:@"var e = document.getElementById(\"link\");"];
	[finalPage appendString:@"var ev = document.createEvent(\"MouseEvents\");"];
	[finalPage appendString:@"ev.initEvent(\"click\",true,true);"];
	[finalPage appendString:@"e.dispatchEvent(ev);"];
	[finalPage appendString:@"</script>"];
	[finalPage appendString:@"</body>"];	
	
	return finalPage;
}


@end
