//
//  ActionHandler.h
//  groupbuy
//
//  Created by  on 11-11-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
@class Product;

@protocol ActionDelegate <NSObject>

@optional
-(void)ActionDidSend:(NSInteger)actionType actionName:(NSString *) actionName Product:(Product *)product;
@end

@interface ActionHandler : NSObject<UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    Product *_product;
    UIViewController *_callingViewController;
}
+(ActionHandler *)defaultHandler;
-(void)actionOnSave:(Product *)product;
-(void)actionOnForward:(Product *)product viewController:(UIViewController *)viewController;
-(void)actionOnComment:(Product *)product viewController:(UIViewController *)viewController;
-(void)actionOnBuy:(Product *)product viewController:(UIViewController *)viewController;
@end

extern ActionHandler *GlobalGetActionHandler();