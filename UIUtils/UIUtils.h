//
//  UIUtils.h
//  three20test
//
//  Created by qqn_pipi on 10-1-9.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kCallNotSupportOnIPod		NSLocalizedString(@"kCallNotSupportOnIPod", @"")
#define kSmsNotSupportOnIPod		NSLocalizedString(@"kSmsNotSupportOnIPod", @"")
#define kFaceTimeNotSupportOnDevice NSLocalizedString(@"kFaceTimeNotSupportOnDevice", @"")

#define kAlertTextViewTag			2011031501

@interface UIUtils : NSObject {	

}

+ (void)alert:(NSString *)msg;
+ (void)alertWithTitle:(NSString *)title msg:(NSString *)msg;
+ (void)askYesNo:(NSString *)msg cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle delegate:(id)delegate;
+ (BOOL) canMakeCall:(NSString *)phoneNumber;
+ (void)makeCall:(NSString *)phoneNumber;
+ (void)sendSms:(NSString *)phoneNumber;
+ (void) sendEmail:(NSString *)phoneNumber;
+ (void) sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body;
+ (void)openApp:(NSString*)appId;
+ (void)openLocation:(CLLocation*)location;
+ (NSString*)getAppLink:(NSString*)appId;
+ (BOOL) canFaceTime;
+ (void) makeFaceTime:(NSString *)faceTimeId;

+ (UIViewController*)addViewController:(NSObject*)viewControllerAllocObject viewTitle:(NSString*)viewTitle viewImage:(NSString*)viewImage hasNavController:(BOOL)hasNavController viewControllers:(NSMutableArray*)viewControllers;

+ (UIViewController*)addViewController:(NSObject*)viewControllerAllocObject viewTitle:(NSString*)viewTitle viewImage:(NSString*)viewImage hasNavController:(BOOL)hasNavController hideNavigationBar:(BOOL)hideNavigationBar viewControllers:(NSMutableArray*)viewControllers;

+ (void)openURL:(NSString*)url;
+ (UIAlertView*)popup:(NSString *)title msg:(NSString*)msg;
+ (UIAlertView*)showTextView:(NSString*)title okButtonTitle:(NSString*)okButtonTitle cancelButtonTitle:(NSString*)cancelButtonTitle  delegate:(id<UIAlertViewDelegate>)delegate;
+ (UIAlertView*)showTextView:(NSString*)title okButtonTitle:(NSString*)okButtonTitle cancelButtonTitle:(NSString*)cancelButtonTitle  delegate:(id<UIAlertViewDelegate>)delegate secureTextEntry:(BOOL)secureTextEntry;

@end
