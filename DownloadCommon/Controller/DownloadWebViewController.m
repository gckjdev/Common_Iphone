
#import "DownloadWebViewController.h"
#import "StringUtil.h"
#import "WebViewAdditions.h"
#import "LogUtil.h"
#import "DownloadService.h"

DownloadWebViewController *downloadWebViewController;

DownloadWebViewController *GlobalGetDownloadWebViewController()
{
    if (downloadWebViewController == nil){
        downloadWebViewController = [[DownloadWebViewController alloc] init];
    }
    return downloadWebViewController;
}

@implementation DownloadWebViewController

@synthesize webView;
@synthesize loadActivityIndicator;
@synthesize request;
@synthesize backAction;
@synthesize superViewController;
@synthesize currentURL;
@synthesize webSite;

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
    [webSite release];
    [currentURL release];
    [superViewController release];
    [webView release];
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

    [self.webView registerLongPressHandler];
    
    [super viewDidLoad];
    
    
//    [self.webView setScalesPageToFit:YES];
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
    
    [super viewDidDisappear:animated];
}

- (void)openURL:(NSString *)URLString
{
    NSLog(@"url = %@",URLString);
    
    NSURL *url = [NSURL URLWithString:[URLString stringByURLEncode]];
    request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)viewDidUnload
{
    [self setSuperViewController:nil];
    [self setWebView:nil];
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

- (void)longpressTouch:(UIWebView*)webView info:(HTMLLinkInfo*)linkInfo
{
    if ([linkInfo hasLink]){
        [UIUtils alert:@"start downloading"];
        [[DownloadService defaultService] downloadFile:linkInfo.href 
                                               webSite:webSite 
                                               origUrl:currentURL];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)requestURL navigationType:(UIWebViewNavigationType)navigationType{
    
    //    if ([[[requestURL URL] description] rangeOfString:@"tel"].location != NSNotFound){
    //        [UIUtils makeCall:[[requestURL URL] description]];
    //        return NO;
    //    }
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    if (loadActivityIndicator.superview)
        [loadActivityIndicator removeFromSuperview];
    
    [self showActivityWithText:@"加载数据中..."];
    
    [loadActivityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    // set current URL
    self.currentURL = self.webView.request.URL.absoluteString;
    
    // forbid popup call out window
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    
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
    DownloadWebViewController* webController = GlobalGetDownloadWebViewController();
    
    [webController setSuperViewController:superController];
    [webController setBackAction:^(UIViewController* viewController){
        [viewController dismissModalViewControllerAnimated:YES];        
    }];
    
    [superController presentModalViewController:webController animated:YES];
    [webController openURL:url];  
    [webController setWebSite:url];
}

- (IBAction)clickBack:(id)sender
{
    if (self.backAction){
        self.backAction(superViewController);
    }
}


@end

