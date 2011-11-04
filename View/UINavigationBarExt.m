//
//  UINavigationBarExt.m
//  MyPhoneService
//
//  Created by qqn_pipi on 10-3-13.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UINavigationBarExt.h"
#import "StringUtil.h"
#import "DeviceDetection.h"

NSMutableDictionary* barBackgroundName;
NSString* navigationBarBackgroundName;

void clearNavBarBackground()
{
    if ([DeviceDetection isOS5]){
        [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        return;
    }
    else{
        
    }
}

void activateNavBarBackground()
{
    
}

void GlobalSetNavBarBackground(NSString* imageName)
{
    if ([DeviceDetection isOS5]){
        UIImage* image = [UIImage imageNamed:imageName];
        [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        return;
    }
    
	if (navigationBarBackgroundName == imageName)
		return;
	
	if (navigationBarBackgroundName != nil){
		[navigationBarBackgroundName release];
	}

	navigationBarBackgroundName = imageName;
	[navigationBarBackgroundName retain];
}

NSString* GlobalGetNavBarBackground()
{
	return navigationBarBackgroundName;
}

@implementation UINavigationBar (UINavigationBarExt)

- (NSString*)getBackgroundKey
{
	return [NSString stringWithFormat:@"%08X-Barbackground", self];
}

- (NSString*)getBackgroundIndexKey
{
	return [NSString stringWithFormat:@"%08X-BarbackgroundIndex", self];
}

- (NSString*)getBackgroundTimerKey
{
	return [NSString stringWithFormat:@"%08X-BarbackgroundTimer", self];
}

- (void)stopTimer
{
	NSTimer* timer = [barBackgroundName	objectForKey:[self getBackgroundTimerKey]];	

	if (timer != nil){
//		NSLog(@"UINavigationBar:stopTimer");
		
		[barBackgroundName removeObjectForKey:[self getBackgroundTimerKey]];

		[timer invalidate];
		[timer release];
		timer = nil;		
	}
}

- (void)startTimer
{
	if (barBackgroundName == nil){
		barBackgroundName = [[NSMutableDictionary alloc] init];
	}
	
	NSTimer* timer = [barBackgroundName	objectForKey:[self getBackgroundTimerKey]];	
	if (timer == nil){
		// create timer and save it
		timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(refreshBar:) userInfo:self repeats:YES];
		[timer retain];		

		[barBackgroundName setObject:timer forKey:[self getBackgroundTimerKey]];
	}
	else {
		NSLog(@"Warning, timer alive when starting timer for bar");
	}

}



- (void)setBackgroundName:(NSArray*)imageNameArray
{
	if (barBackgroundName == nil){
		barBackgroundName = [[NSMutableDictionary alloc] init];
	}
	
	// set array
	[barBackgroundName setValue:imageNameArray forKey:[self getBackgroundKey]];	
	
	// set the first item as the selection index
	[barBackgroundName setValue:[NSString stringWithInt:0] forKey:[self getBackgroundIndexKey]];
}

- (NSArray*)getBackgroundName
{
	return [barBackgroundName valueForKey:[self getBackgroundKey]];
}

- (int)getCurrentBackgroundIndex
{
	return [[barBackgroundName valueForKey:[self getBackgroundIndexKey]] intValue];
}

- (UIImage*)getCurrentBackgroundImage
{
	NSArray* imageArray = [self getBackgroundName];
	int index = [self getCurrentBackgroundIndex];
	if (imageArray && index >=0 && index < [imageArray count]){
		return [UIImage imageNamed:[imageArray objectAtIndex:index]];
	}
	else {
		return nil;
	}
}

- (void)incBackgroundIndex
{
	NSArray* imageArray = [self getBackgroundName];
	if (imageArray == nil || [imageArray count] == 0)
		return;
	
	int index = [self getCurrentBackgroundIndex];
	
	index ++;
	if (index > [imageArray count] - 1){
		index = 0;	// reach the final item, reset to the first one
	}				 
		
	[barBackgroundName setValue:[NSString stringWithInt:index] forKey:[self getBackgroundIndexKey]];
	
}

- (void)drawRect:(CGRect)rect {

	UIImage *img = [self getCurrentBackgroundImage];	
	if (img == nil){
		if (navigationBarBackgroundName == nil)
			return;
		
		img = [UIImage imageNamed:navigationBarBackgroundName];
	}
	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	[self incBackgroundIndex];	

}

- (void)refreshBar:(id)sender
{
	[self setNeedsDisplay];
}

@end

