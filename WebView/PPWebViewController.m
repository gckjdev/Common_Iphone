
#import "PPWebViewController.h"
#import "StringUtil.h"

@implementation PPWebViewController
@synthesize webView;
@synthesize toolbar;
@synthesize forwardButton;
@synthesize backButton;
@synthesize reloadButton;
@synthesize loadActivityIndicator;
@synthesize request;
@synthesize backAction;
@synthesize superViewController;

-(id)init
{
    self = [super init];
    if (self) {
        loadActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)dealloc
{
    [superViewController release];
    [webView release];
    [toolbar release];
    [forwardButton release];
    [backButton release];
    [reloadButton release];
    [loadActivityIndicator release];
    [request release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor clearColor];
    
    [super viewDidLoad];
    [self.webView setScalesPageToFit:YES];
    [self.webView setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.webView stopLoading];
    [self hideActivity];
    [loadActivityIndicator stopAnimating];
    if (loadActivityIndicator.superview)
        [loadActivityIndicator removeFromSuperview];

    [super viewDidDisappear:animated];
}

- (void)openURL:(NSString *)URLString
{
    [self showActivityWithText:@"加载数据中..."];

    NSLog(@"url = %@",URLString);
    
    NSURL *url = [NSURL URLWithString:[URLString stringByURLEncode]];
    request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)viewDidUnload
{
    [self setSuperViewController:nil];
    [self setWebView:nil];
    [self setToolbar:nil];
    [self setForwardButton:nil];
    [self setBackButton:nil];
    [self setReloadButton:nil];
    [self setLoadActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) clickBackBuuton{
    if (self.webView.canGoBack) {
        [self.webView stopLoading];
        [self.webView goBack];
    }
}
- (IBAction) clickForwardBuuton{
    if (self.webView.canGoForward) {
        [self.webView stopLoading];
        [self.webView goForward];
    }
}
- (IBAction) clickReloadBuuton{
    [self.webView stopLoading];
    [self.webView reload];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)requestURL navigationType:(UIWebViewNavigationType)navigationType{

//    if ([[[requestURL URL] description] rangeOfString:@"tel"].location != NSNotFound){
//        [UIUtils makeCall:[[requestURL URL] description]];
//        return NO;
//    }
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
//    int width = 320;
//    int height = 480;
//    [loadActivityIndicator
    
    [loadActivityIndicator setCenter:CGPointMake(toolbar.bounds.size.width - 30, toolbar.bounds.size.height/2)];

    if (loadActivityIndicator.superview)
        [loadActivityIndicator removeFromSuperview];
    [toolbar addSubview:loadActivityIndicator];
    
    [self showActivityWithText:@"加载数据中..."];
    
//    [self.view addSubview:loadActivityIndicator];
    
    [loadActivityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [self hideActivity];
    if (loadActivityIndicator.superview)
        [loadActivityIndicator removeFromSuperview];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self.webView loadRequest:request];
    }

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"web view didFailLoadWithError error = %@ ", [error description]);
    [self hideActivity];
    if (loadActivityIndicator.superview)
        [loadActivityIndicator removeFromSuperview];
}

+ (void)show:(UIViewController*)superController url:(NSString*)url
{
    PPWebViewController *webController = [[[PPWebViewController alloc] init] autorelease];
    [superController.navigationController pushViewController:webController animated:YES];    
    [webController openURL:url];
}

#define WEB_VIEW_FRAME   CGRectMake(8, 8, 304, 480-44-20-8-55-5)

- (void)enableGroupBuySettings
{
    webView.frame = WEB_VIEW_FRAME;
    webView.backgroundColor = [UIColor clearColor];
    
    [self setGroupBuyNavigationBackButton];
    [self setBackgroundImageName:@"background.png"];
    [self setGroupBuyNavigationTitle:@"商品主页"];
}

- (IBAction)clickBack:(id)sender
{
    if (self.backAction){
        self.backAction(superViewController);
    }
}

+ (void)showForGroupBuy:(UIViewController*)superController url:(NSString*)url
{
    PPWebViewController* webController = GlobalGetPPWebViewController();
    
    [webController setSuperViewController:superController];
    [webController setBackAction:^(UIViewController* viewController){
        [viewController dismissModalViewControllerAnimated:YES];        
    }];
    
    [superController.navigationController presentModalViewController:webController animated:YES];
    [webController openURL:url];    
}

@end

PPWebViewController *ppWebViewController;
PPWebViewController *GlobalGetPPWebViewController()
{
    if (ppWebViewController == nil){
        ppWebViewController = [[PPWebViewController alloc] init];
    }
    return ppWebViewController;
}