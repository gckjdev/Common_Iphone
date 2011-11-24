//
//  ShowAlertTextViewController.h
//  FootballScore
//
//  Created by haodong qiu on 11-11-22.
//  Copyright (c) 2011年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowAlertTextView : UIView {
}
@end

@interface ShowAlertTextViewController : UIViewController
{
    NSTimer *showTimer;
    NSString *message;
}

@property(nonatomic,retain) NSTimer *showTimer;
@property(nonatomic,retain) NSString *message;
@property (retain, nonatomic) IBOutlet UILabel *messageLabel;

- (void)removeFromSuperView;
- (void)updateViewByMessage:(NSString*)message;
- (void)createHideTimer;
+ (void) show:(UIView*)superView message:(NSString*)message;
- (void)cancelDisplay;

@end
