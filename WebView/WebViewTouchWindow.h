//
//  MyWindow.h
//  tppispig
//
//  Created by gao wei on 10-7-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewTouchWindow : UIWindow
{
	CGPoint    tapLocation;
	NSTimer    *contextualMenuTimer;
}
@end