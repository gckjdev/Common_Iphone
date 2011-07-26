
#import "PPWebViewController.h"

TTWebController* gWebController;

TTWebController* GlobalGetWebController()
{
    if (gWebController == nil){
        gWebController = [[TTWebController alloc] init];
    }
    
    return gWebController;
}



@implementation PPWebViewController
@synthesize webView;
@synthesize toolbar;
@synthesize forwardButton;
@synthesize backButton;
@synthesize reloadButton;
@synthesize loadActivityIndicator;
@synthesize request;
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
    
    [super viewDidLoad];
    [self.webView setScalesPageToFit:YES];
    [self.webView setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)openURL:(NSString *)URLString
{
    NSLog(@"url = %@",URLString);
    
    NSURL *url = [NSURL URLWithString:URLString];
    request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)viewDidUnload
{
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    [loadActivityIndicator setCenter:CGPointMake(toolbar.bounds.size.width - 30, toolbar.bounds.size.height/2)];
    [toolbar addSubview:loadActivityIndicator];
    [loadActivityIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [loadActivityIndicator removeFromSuperview];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self.webView loadRequest:request];
    }

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通知" message:@"网络连接错误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    [alertView release];
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