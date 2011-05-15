//
//  ImageSearchResult.m
//  three20test
//
//  Created by qqn_pipi on 10-4-11.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "ImageSearchResult.h"


@implementation ImageSearchResult

@synthesize titleNoFormatting;
@synthesize unescapedUrl;
@synthesize url;
@synthesize visibleUrl;

@synthesize width;
@synthesize height;
@synthesize tbWidth;
@synthesize tbHeight;

@synthesize tbUrl;


- (NSString *)description
{
	return [NSString stringWithFormat:
			@"titleNoFormatting=%@\nunescapedUrl=%@\nurl=%@\nvisibleUrl=%@\ntbUrl=%@\nwidth=%d, height=%d\ntbWidth=%d, tbHeight=%d\n",
			titleNoFormatting, unescapedUrl, url, visibleUrl, tbUrl,
			width, height, tbWidth, tbHeight];
}


- (void)dealloc
{
	[titleNoFormatting release];
	[unescapedUrl release];
	[url release];
	[visibleUrl release];
	[tbUrl release];
	
	[super dealloc];
}

@end
