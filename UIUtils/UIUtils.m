//
//  UIUtils.m
//  three20test
//
//  Created by qqn_pipi on 10-1-9.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIUtils.h"
#import "UIAlertViewUtils.h"
#import "DeviceDetection.h"

@implementation UIUtils

+ (UIAlertView*)popup:(NSString *)title msg:(NSString*)msg
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
	[alertView showWithBackground];
	return alertView;
}

+ (void)alert:(NSString *)msg
{
	UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:msg message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
	[alertView showWithBackground];
}

+ (void)askYesNo:(NSString *)msg cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle delegate:(id)delegate
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg message:@"" delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okButtonTitle, nil];
	[alertView showWithBackground];
	[alertView release];
}


+ (NSString*) cleanPhoneNumber:(NSString*)phoneNumber
{
	NSString* number = [NSString stringWithString:phoneNumber];
	NSString* number1 = [[[number stringByReplacingOccurrencesOfString:@" " withString:@""]
						  //						stringByReplacingOccurrencesOfString:@"-" withString:@""]
						  stringByReplacingOccurrencesOfString:@"(" withString:@""] 
						 stringByReplacingOccurrencesOfString:@")" withString:@""];
	
	return number1;	
}

+ (BOOL) canMakeCall:(NSString *)phoneNumber
{
	if ([DeviceDetection isIPodTouch]){
		return NO;
	}
	
	NSString* numberAfterClear = [UIUtils cleanPhoneNumber:phoneNumber];		
	NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberAfterClear]];
	if (phoneNumberURL == nil){
		return NO;
	}
	
	return YES;
}

+ (BOOL) canFaceTime
{
	if ([DeviceDetection detectModel] == MODEL_IPHONE_4G || [DeviceDetection detectModel] == MODEL_IPOD_TOUCH_4G){
		return YES;
	}
	
	return NO;
}

+ (void) makeFaceTime:(NSString *)faceTimeId
{
	if ([UIUtils canFaceTime] == NO){
		[UIUtils alert:kFaceTimeNotSupportOnDevice];
		return;
	}
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"facetime://%@", faceTimeId]];	
	NSLog(@"Make FaceTime, URL=%@", [NSString stringWithFormat:@"facetime://%@", faceTimeId]);	
	if (url == nil){
		NSLog(@"Make FaceTime, URL incorrect");
	}
	
	[[UIApplication sharedApplication] openURL:url];	
}

+ (void) makeCall:(NSString *)phoneNumber
{
	if ([DeviceDetection isIPodTouch]){
		[UIUtils alert:kCallNotSupportOnIPod];
		return;
	}
	
	NSString* numberAfterClear = [UIUtils cleanPhoneNumber:phoneNumber];	
	
	NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberAfterClear]];
	NSLog(@"make call, URL=%@", phoneNumberURL);
	
	[[UIApplication sharedApplication] openURL:phoneNumberURL];	
}

+ (void) sendSms:(NSString *)phoneNumber
{
	if ([DeviceDetection isIPodTouch]){
		[UIUtils alert:kSmsNotSupportOnIPod];
		return;
	}
	
	NSString* numberAfterClear = [UIUtils cleanPhoneNumber:phoneNumber];
	
	NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", numberAfterClear]];
	NSLog(@"send sms, URL=%@", phoneNumberURL);
	[[UIApplication sharedApplication] openURL:phoneNumberURL];	
}

+ (void) sendEmail:(NSString *)phoneNumber
{
	NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", phoneNumber]];
	NSLog(@"send sms, URL=%@", phoneNumberURL);
	[[UIApplication sharedApplication] openURL:phoneNumberURL];	
}

+ (void) sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body
{
//	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
//	NSString *body = @"&body=It is raining in sunny California!";
	
	NSString* str = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",
					 to, cc, subject, body];

	str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
//	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
//	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
	
}

+ (NSString*)getAppLink:(NSString*)appId
{
	NSString* iTunesLink = [NSString stringWithFormat:
							@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", appId];
	
    NSLog(@"iTunesLink=%@", iTunesLink);
    
	return iTunesLink;
}

+ (void)openApp:(NSString*)appId
{
	NSString* iTunesLink = [NSString stringWithFormat:
							@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", appId];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];	
}

+ (void)openURL:(NSString*)url
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];	
}

+ (void)openLocation:(CLLocation*)location
{
	NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f", location.coordinate.latitude, location.coordinate.longitude];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];		
}

#pragma mark Tab Bar View Controller Utills

+ (UIViewController*)addViewController:(NSObject*)viewControllerAllocObject viewTitle:(NSString*)viewTitle viewImage:(NSString*)viewImage highlightImage:(NSString*)highlightImage hasNavController:(BOOL)hasNavController viewControllers:(NSMutableArray*)viewControllers
{
	UIViewController* retViewController = [[viewControllerAllocObject init] autorelease];		
	UITabBarItem* button1 = [[[UITabBarItem alloc] initWithTitle:viewTitle image:[UIImage imageNamed:viewImage] tag:0] autorelease];						
    
	if (hasNavController){
		UINavigationController *navController1 = [[[UINavigationController alloc] initWithRootViewController:retViewController] autorelease];				
		[viewControllers addObject:navController1];
		navController1.tabBarItem = button1;	
		navController1.title = viewTitle;
		retViewController.title = viewTitle;
	}
	else {
		[viewControllers addObject:retViewController];
		retViewController.tabBarItem = button1;	
	}
	
	return retViewController;
}


+ (UIViewController*)addViewController:(NSObject*)viewControllerAllocObject viewTitle:(NSString*)viewTitle viewImage:(NSString*)viewImage hasNavController:(BOOL)hasNavController viewControllers:(NSMutableArray*)viewControllers
{
	UIViewController* retViewController = [[viewControllerAllocObject init] autorelease];		
	UITabBarItem* button1 = [[[UITabBarItem alloc] initWithTitle:viewTitle image:[UIImage imageNamed:viewImage] tag:0] autorelease];							   
	
	if (hasNavController){
		UINavigationController *navController1 = [[[UINavigationController alloc] initWithRootViewController:retViewController] autorelease];				
		[viewControllers addObject:navController1];
		navController1.tabBarItem = button1;	
		navController1.title = viewTitle;
		retViewController.title = viewTitle;
	}
	else {
		[viewControllers addObject:retViewController];
		retViewController.tabBarItem = button1;	
	}
	
	return retViewController;
}

#pragma mark Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    enum ButtonIndex {
        kAddCalendar,
        kDoNothing
    };
	
    switch (buttonIndex) {
        case kDoNothing:
            break;
        case kAddCalendar:
        {
        }
            break;
        default:
            break;
    }
	
}

+ (UIAlertView*)showTextView:(NSString*)title okButtonTitle:(NSString*)okButtonTitle cancelButtonTitle:(NSString*)cancelButtonTitle  delegate:(id<UIAlertViewDelegate>)delegate 
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"this gets covered!" delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okButtonTitle, nil];	
	UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];	
	myTextField.tag = kAlertTextViewTag;
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 60);	
	[alert setTransform:myTransform];	
	[myTextField setBackgroundColor:[UIColor whiteColor]];	
	[myTextField setFont:[UIFont systemFontOfSize:16]];
	[alert addSubview:myTextField];	
	[alert show];	
	[alert release];
	[myTextField becomeFirstResponder];
	[myTextField release];	
	
	return alert;
}

+ (UIAlertView*)showTextView:(NSString*)title okButtonTitle:(NSString*)okButtonTitle cancelButtonTitle:(NSString*)cancelButtonTitle  delegate:(id<UIAlertViewDelegate>)delegate secureTextEntry:(BOOL)secureTextEntry
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"this gets covered!" delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okButtonTitle, nil];	
	UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];	
	myTextField.tag = kAlertTextViewTag;
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 60);	
	[alert setTransform:myTransform];	
	[myTextField setBackgroundColor:[UIColor whiteColor]];	
	[myTextField setFont:[UIFont systemFontOfSize:16]];
	[myTextField setSecureTextEntry:secureTextEntry];
	[alert addSubview:myTextField];	
	[alert show];	
	[alert release];
	[myTextField becomeFirstResponder];
	[myTextField release];	
	
	return alert;
}

#pragma mark Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    enum ButtonIndex {
        kButtonCloseIndex,
        kButtonDialIndex
    };
	
    switch (buttonIndex) {
        case kButtonCloseIndex:
            break;
        case kButtonDialIndex:
        {
        }
            break;
        default:
            break;
    }		
}

@end



