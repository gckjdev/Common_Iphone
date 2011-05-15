//
//  ImageSearchResult.h
//  three20test
//
//  Created by qqn_pipi on 10-4-11.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageSearchResult : NSObject {

	NSString* titleNoFormatting;
	NSString* unescapedUrl;
	NSString* url;
	NSString* visibleUrl;
	
	int		  width;
	int		  height;
	int		  tbWidth;
	int		  tbHeight;
	
	NSString* tbUrl;
	
	
	
}

@property (nonatomic, retain) NSString* titleNoFormatting;
@property (nonatomic, retain) NSString* unescapedUrl;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* visibleUrl;

@property (nonatomic)		  int		  width;
@property (nonatomic)		  int		  height;
@property (nonatomic)		  int		  tbWidth;
@property (nonatomic)		  int		  tbHeight;

@property (nonatomic, retain) NSString* tbUrl;

@end
