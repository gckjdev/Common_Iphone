
#import "DownloadWebViewController.h"
#import "StringUtil.h"
#import "WebViewAdditions.h"
#import "LogUtil.h"
#import "DownloadService.h"
#import "DownloadItem.h"
#import "TopSiteManager.h"
#import "DownloadResource.h"
#import "UIButtonExt.h"

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
@synthesize urlForAction;
@synthesize openURLForAction;
@synthesize backButton;
@synthesize stopButton;
@synthesize reloadButton;
@synthesize addFavoriteButton;
@synthesize urlFileType;
@synthesize backwardButton;
@synthesize forwardButton;

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
    [urlForAction release];
    [backButton release];
    [stopButton release];
    [reloadButton release];
    [addFavoriteButton release];
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
    [self.backButton setTitle:NSLS(@"kBackButtonTitle") forState:UIControlStateNormal];
    [self.backButton setImage:RETURN_IMAGE forState:UIControlStateNormal];    
    [self.backButton centerImageAndTitle];
    
    [self.backwardButton setTitle:NSLS(@"kBackwardButtonTitle") forState:UIControlStateNormal];
    [self.backwardButton setImage:BACKWARD_IMAGE forState:UIControlStateNormal];    
    [self.backwardButton centerImageAndTitle];
    
    [self.forwardButton setTitle:NSLS(@"kForwardButtonTitle") forState:UIControlStateNormal];
    [self.forwardButton setImage:FORWARD_IMAGE forState:UIControlStateNormal];    
    [self.forwardButton centerImageAndTitle];
    
    [self.stopButton setTitle:NSLS(@"kStopButtonTitle") forState:UIControlStateNormal];
    [self.stopButton setImage:STOP_IMAGE forState:UIControlStateNormal];
    [self.stopButton centerImageAndTitle];
    
    [self.reloadButton setTitle:NSLS(@"kReloadButtonTitle") forState:UIControlStateNormal];
    [self.reloadButton setImage:REFRESH_IMAGE forState:UIControlStateNormal];
    [self.reloadButton centerImageAndTitle];
    
    [self.addFavoriteButton setTitle:NSLS(@"kAddFavoriteButtonTitle") forState:UIControlStateNormal];
    [self.addFavoriteButton setImage:FAVOURITE_IMAGE forState:UIControlStateNormal];
    [self.addFavoriteButton centerImageAndTitle];
    
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
    [self showActivityWithText:NSLS(@"kLoadingURL")];
    
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
    [self setBackButton:nil];
    [self setStopButton:nil];
    [self setReloadButton:nil];
    [self setAddFavoriteButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) clickBackButton{
    if (self.webView.canGoBack) {
        [self.webView stopLoading];
        [self.webView goBack];
    }
}
- (IBAction) clickForwardButton{
    if (self.webView.canGoForward) {
        [self.webView stopLoading];
        [self.webView goForward];
    }
}

- (IBAction) clickReloadButton{
    [self.webView stopLoading];
    [self.webView reload];
}

- (IBAction) clickStopButton{
    [self.webView stopLoading];
}

- (IBAction) clickAddFavorite:(id)sender
{
    [[TopSiteManager defaultManager] addFavoriteSite:[self.webView getTitle] 
                                             siteURL:self.currentURL];
}

- (void)longpressTouch:(UIWebView*)webView info:(HTMLLinkInfo*)linkInfo
{
    if ([linkInfo hasLink]){
//        [self popupHappyMessage:NSLS(@"kTryDownloadNow") title:@""];
//        [[DownloadService defaultService] downloadFile:linkInfo.href 
//                                               webSite:webSite 
//                                           webSiteName:[self.webView getTitle]
//                                               origUrl:currentURL];
        self.urlFileType = FILE_TYPE_UNKNOWN;
        [self askDownload:linkInfo.href];
    }
    else if ([linkInfo hasImage]){
        self.urlFileType = FILE_TYPE_IMAGE;
        [self askDownload:linkInfo.src];        
    }
}

- (BOOL)canDownload:(NSString*)urlString
{    
    NSString* pathExtension = [[urlString pathExtension] lowercaseString];
    if (pathExtension == nil)
        return NO;
    
    NSSet* fileTypeSet = [NSSet setWithObjects:@"mp3", @"mid", @"mp4", @"zip", @"3pg", @"mov", 
                          @"jpg", @"png", @"jpeg", 
                          @"avi", @"pdf", @"doc", @"txt", @"gif", @"xls", @"ppt", @"rtf",
                          @"rar", @"tar", @"gz", @"flv", @"rm", @"rmvb", @"ogg", @"wmv", @"m4v",
                          @"bmp", @"wav", @"caf", @"m4v", @"aac", @"aiff", @"dvix", @"epub",
                          nil];
    return [fileTypeSet containsObject:pathExtension];
}

- (void)askDownload:(NSString*)urlString
{
    self.urlForAction = urlString;
    self.openURLForAction = NO;
    
    NSString* title = [NSString stringWithFormat:NSLS(@"kDownloadURL"), urlString];
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:NSLS(@"Cancel") destructiveButtonTitle:NSLS(@"kYesDownload") otherButtonTitles:NSLS(@"kNoOpenURL"), nil];
    
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    enum BUTTON_INDEX {
        CLICK_DOWNLOAD = 0,
        CLICK_OPEN_URL = 1
    };
    
    switch (buttonIndex) {
        case CLICK_DOWNLOAD:
        {
            [[DownloadService defaultService] downloadFile:urlForAction 
                                                  fileType:urlFileType
                                                   webSite:webSite
                                               webSiteName:[self.webView getTitle]             
                                                   origUrl:currentURL];
        }
            break;
            
        case CLICK_OPEN_URL:
        {
            self.openURLForAction = YES;
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlForAction]]];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)isURLSkip:(NSString*)urlString
{
    if ([urlString rangeOfString:@":4022"].location != NSNotFound){
        PPDebug(@"URL(%@) contains 4022, skip it", urlString);
        return YES;
    }
    else
        return NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)requestURL navigationType:(UIWebViewNavigationType)navigationType{
    
    //    if ([[[requestURL URL] description] rangeOfString:@"tel"].location != NSNotFound){
    //        [UIUtils makeCall:[[requestURL URL] description]];
    //        return NO;
    //    }
    
    NSLog(@"Loading URL = %@", [[requestURL URL] absoluteURL]); 
        
    
    NSString* urlString = [[[requestURL URL] absoluteURL] description];
    if ([self isURLSkip:urlString]){
        return YES;
    }

    if (openURLForAction == YES && [self.urlForAction isEqualToString:urlString]){
        // it's already confirmed to open the URL by askDownload
        return YES;
    }

    // remove query parameter string
    NSString* baseURLString = [[[requestURL URL] absoluteURL] description];
    NSString* path = baseURLString;
    NSString* para = [[[requestURL URL] absoluteURL] query];
    if (para != nil){
        path = [path stringByReplacingOccurrencesOfString:[@"?" stringByAppendingString:para]
                                               withString:@""];
    }
    
    if ([self canDownload:baseURLString] || [self canDownload:path]){
        self.urlFileType = FILE_TYPE_UNKNOWN;
        [self askDownload:urlString];
        return NO;
    }
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    if (loadActivityIndicator.superview)
        [loadActivityIndicator removeFromSuperview];
        
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

//    [[[[UIApplication sharedApplication] delegate] window] make];
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

