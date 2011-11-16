//
//  WebViewAdditions.h
//  tppispig
//
//  Created by gao wei on 10-7-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLLinkInfo : NSObject 
    
@property (nonatomic, retain) NSString* href;   // for A HREF
@property (nonatomic, retain) NSString* src;    // for IMG SRC
@property (nonatomic, retain) NSString* tags; 
@property (nonatomic, retain) NSString* text; 
    
- (BOOL)hasLink;
- (BOOL)hasImage;

@end

@protocol WebViewTouchDelegate <NSObject>

- (void)longpressTouch:(UIWebView*)webView info:(HTMLLinkInfo*)linkInfo;

@end

@interface UIWebView(WebViewAdditions)

- (CGSize)windowSize;
- (CGPoint)scrollOffset;
- (void)registerLongPressHandler;
- (NSString*)getTitle;

@end
