//
//  PPWebViewController.h
//  FreeMusic
//
//  Created by qqn_pipi on 10-10-10.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PPWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {

	UIActivityIndicatorView	*loadingView;
	IBOutlet UIView			*superViewForWebView;
	IBOutlet UIToolbar		*toolbar;	
	
	NSMutableArray			*webViewArray;
	int						currentIndex;	// which web view in array is shown
}

@property (nonatomic, retain) UIActivityIndicatorView	*loadingView;
@property (nonatomic, retain) IBOutlet UIView			*superViewForWebView;
@property (nonatomic, retain) IBOutlet UIToolbar		*toolbar;	
@property (nonatomic, retain) NSMutableArray			*webViewArray;
@property (nonatomic, assign) int						currentIndex;

// tool bar actions
- (void)clickPrev:(id)sender;
- (void)clickNext:(id)sender;
- (void)clickRefresh:(id)sender;

- (void)openURL:(NSString*)urlString;

@end
