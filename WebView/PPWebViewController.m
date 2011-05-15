//
//  PPWebViewController.m
//  FreeMusic
//
//  Created by qqn_pipi on 10-10-10.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "PPWebViewController.h"


@implementation PPWebViewController

@synthesize loadingView;
@synthesize superViewForWebView;
@synthesize toolbar;	
@synthesize webViewArray;
@synthesize currentIndex;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		
		// add loading view
		self.loadingView = [[[UIActivityIndicatorView alloc]
											 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
		[loadingView startAnimating];				
		UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
		self.navigationItem.rightBarButtonItem = activityItem;
		[activityItem release];
		
		// back button
		UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithImage:
					   TTIMAGE(@"bundle://Three20.bundle/images/backIcon.png")
													   style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
		_backButton.tag = 2;
		_backButton.enabled = NO;
		
		// forward button
		UIBarButtonItem *_forwardButton = [[UIBarButtonItem alloc] initWithImage:
						  TTIMAGE(@"bundle://Three20.bundle/images/forwardIcon.png")
														  style:UIBarButtonItemStylePlain target:self action:@selector(forwardAction)];
		_forwardButton.tag = 1;
		_forwardButton.enabled = NO;

		// refresh button
		UIBarButtonItem *_refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
						  UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction)];
		_refreshButton.tag = 3;
		
		// stop button
		_stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
					   UIBarButtonSystemItemStop target:self action:@selector(stopAction)];
		_stopButton.tag = 3;
		_actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
						 UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
		
		UIBarItem* space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
							 UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
		
//		_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.height - TTToolbarHeight(), self.view.width, TTToolbarHeight())];
		_toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
		_toolbar.tintColor = TTSTYLEVAR(toolbarTintColor);
		_toolbar.items = [NSArray arrayWithObjects:
						  _backButton, space, _forwardButton, space, _refreshButton, space, _actionButton, nil];
    }
    return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[loadingView release];
	[superViewForWebView release];
	[toolbar release];
	[webViewArray release;
    [super dealloc];
}

#pragma mark -
#pragma mark UIWebViewDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType {
	if ([[TTNavigator navigator].URLMap isAppURL:request.URL]) {
		[_loadingURL release];
		_loadingURL = [[NSURL URLWithString:@"about:blank"] retain];
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
	
	[_loadingURL release];
	_loadingURL = [request.URL retain];
	_backButton.enabled = [_webView canGoBack];
	_forwardButton.enabled = [_webView canGoForward];
	return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidStartLoad:(UIWebView*)webView {
	self.title = TTLocalizedString(@"Loading...", @"");
	if (!self.navigationItem.rightBarButtonItem) {
		[self.navigationItem setRightBarButtonItem:_activityItem animated:YES];
	}
	[_toolbar replaceItemWithTag:3 withItem:_stopButton];
	_backButton.enabled = [_webView canGoBack];
	_forwardButton.enabled = [_webView canGoForward];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidFinishLoad:(UIWebView*)webView {
	TT_RELEASE_SAFELY(_loadingURL);
	
	self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	if (self.navigationItem.rightBarButtonItem == _activityItem) {
		[self.navigationItem setRightBarButtonItem:nil animated:YES];
	}
	[_toolbar replaceItemWithTag:3 withItem:_refreshButton];
	
	_backButton.enabled = [_webView canGoBack];
	_forwardButton.enabled = [_webView canGoForward];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
	TT_RELEASE_SAFELY(_loadingURL);
	[self webViewDidFinishLoad:webView];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIActionSheetDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[[UIApplication sharedApplication] openURL:self.URL];
	}
}



@end
