//
//  ActionHandler.m
//  groupbuy
//
//  Created by  on 11-11-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ActionHandler.h"
#import "ProductService.h"
#import "GroupBuyReport.h"
#import "ProductManager.h"
#import "Product.h"
#import "TKAlertCenter.h"
#import "StringUtil.h"
#import "UINavigationBarExt.h"

ActionHandler *handler = nil;
ActionHandler *GlobalGetActionHandler()
{
    if (handler == nil) {
        handler = [[ActionHandler alloc] init];
    }
    return handler;
}

@implementation ActionHandler

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(ActionHandler *)defaultHandler
{
    return GlobalGetActionHandler();
}


-(void)actionOnSave:(Product *)product;
{
    [GlobalGetProductService() actionOnProduct:product.productId actionName:PRODUCT_ACTION_ADD_FAVORITE actionValue:1];
    [GroupBuyReport reportClickSaveProduct:product];
    if ([ProductManager createProductForFavorite:product]){
        NSString* newMsg = [NSString stringWithFormat:@"%@ %@", kUnhappyFace, @"团购商品收藏成功"];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:
         [NSString stringWithFormat:@"%@", newMsg]];    
    }
}








-(void)actionOnForward:(Product *)product viewController:(UIViewController *)viewController
{
    _product = product;
    _callingViewController = viewController;
    [GlobalGetProductService() actionOnProduct:product.productId actionName:PRODUCT_ACTION_FORWARD actionValue:1];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLS(@"取消") destructiveButtonTitle:nil otherButtonTitles:NSLS(@"短信转发"), NSLS(@"邮件转发"), nil];
    
    [actionSheet showFromTabBar:viewController.tabBarController.tabBar];
    [actionSheet release];
}

#pragma mark - send email

- (void)displayComposerSheetTo:(NSArray*)toRecipients 
				  ccRecipients:(NSArray*)ccRecipients 
				 bccRecipients:(NSArray*)bccRecipients 
					   subject:(NSString*)subject
						  body:(NSString*)body
						isHTML:(BOOL)isHTML
					  delegate:(id)delegate

{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	
	if (delegate != nil){
		picker.mailComposeDelegate = delegate;
	}
	else {
		picker.mailComposeDelegate = self;
	}
    
	
	[picker setSubject:subject];	
	
	[picker setToRecipients:toRecipients];
	[picker setCcRecipients:ccRecipients];	
	[picker setBccRecipients:bccRecipients];

	[picker setMessageBody:body isHTML:isHTML];
	
	[_callingViewController presentModalViewController:picker animated:YES];
    [picker release];
}

-(void)launchMailAppOnDeviceTo:(NSString*)toRecipient 
				  ccRecipients:(NSArray*)ccRecipients 
					   subject:(NSString*)subject
						  body:(NSString*)body

{
	
	// compose cc string
	NSMutableString* ccString = [[NSMutableString alloc] init];
	int index = 0;
	for (NSString* cc in ccRecipients){
		if (index > 0)
			[ccString appendFormat:@",%@", cc];
		else
			[ccString appendFormat:@"%@", cc];
		index ++;
	}
	
	NSString *email = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@", toRecipient, ccString, subject, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
	
	[ccString release];
}

- (BOOL)sendEmailTo:(NSArray*)toRecipients 
	   ccRecipients:(NSArray*)ccRecipients 
	  bccRecipients:(NSArray*)bccRecipients 
			subject:(NSString*)subject
			   body:(NSString*)body
			 isHTML:(BOOL)isHTML
		   delegate:(id)delegate
{
	NSString* firstRecipient = @"";
	if (toRecipients && [toRecipients count] > 0)
		firstRecipient = [toRecipients objectAtIndex:0];			
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheetTo:toRecipients ccRecipients:ccRecipients bccRecipients:bccRecipients subject:subject body:body isHTML:isHTML delegate:delegate];
		}
		else
		{
			[self launchMailAppOnDeviceTo:firstRecipient ccRecipients:ccRecipients subject:subject body:body];
		}
	}
	else
	{
		[self launchMailAppOnDeviceTo:firstRecipient ccRecipients:ccRecipients subject:subject body:body];
	}
	
	return YES;
}

#pragma mark SMS Methods

-(void)sendSms:(NSString*)receiver body:(NSString*)body
{
	NSLog(@"<sendSms> receiver=%@, body=%@", receiver, body);
	MFMessageComposeViewController* vc = [[[MFMessageComposeViewController alloc] init] autorelease];
	vc.messageComposeDelegate = self;
	vc.body = body;
	vc.recipients = [NSArray arrayWithObject:receiver];
	
	if ([MFMessageComposeViewController canSendText] == NO){
		return;
	}	 
	
	[_callingViewController presentModalViewController:vc animated:YES];
}

-(void)sendSmsWithReceivers:(NSArray*)receivers body:(NSString*)body
{
	NSLog(@"<sendSms> receiver=%@, body=%@", [receivers description], body);
	MFMessageComposeViewController* vc = [[[MFMessageComposeViewController alloc] init] autorelease];
	vc.messageComposeDelegate = self;
	vc.body = body;
	vc.recipients = receivers;
	
	if ([MFMessageComposeViewController canSendText] == NO){
		return;
	}	 
	
	[_callingViewController presentModalViewController:vc animated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{		
	NSLog(@"<sendSms> result=%d", result);	
	[_callingViewController dismissModalViewControllerAnimated:YES];
}


- (void)handleForwardProduct:(NSInteger)buttonIndex
{    
    int index = 0;
    if ([_product.title length] > 30){
        index = 30;
    }
    else{
        index = [_product.title length];
    }
    
    NSString* shortDesc = [_product.title substringToIndex:index];    
    NSString* subject = [NSString stringWithFormat:@"［甘橙团购推荐］转发团购产品:%@", shortDesc];    
    
    NSString* smsBody = [NSString stringWithFormat:@"%@ %@ - %@", _product.loc, 
                         _product.siteName, _product.title];
    
    NSString* htmlBody = [NSString stringWithFormat:@"%@ - %@\n\n%@\n\n来自［甘橙团购]", 
                          _product.siteName, _product.title, _product.loc];
    
    enum{
        BUTTON_SEND_BY_SMS,
        BUTTON_SEND_BY_EMAIL,
        BUTTON_CANCEL
    };
    
    switch (buttonIndex) {
        case BUTTON_SEND_BY_SMS:
        {
            GlobalSetNavBarBackground(nil);
            [self sendSms:@"" body:smsBody];
        }
            break;
            
        case BUTTON_SEND_BY_EMAIL:
        {
            GlobalSetNavBarBackground(nil);
            [self sendEmailTo:nil ccRecipients:nil bccRecipients:nil subject:subject body:htmlBody isHTML:NO delegate:self];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -  actionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self handleForwardProduct:buttonIndex];
}

@end
