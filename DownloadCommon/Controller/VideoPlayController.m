//
//  MusicPlayController.m
//  Download
//
//  Created by Orange on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "VideoPlayController.h"
#import "DownloadItemManager.h"
#import "DownloadItem.h"
#import "DownloadResource.h"

@implementation VideoPlayController

@synthesize currentIndex;
@synthesize tipsLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)showTips:(NSString *)text
{ 
    if (self.tipsLabel == nil) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 40)];
        [label setFont:[UIFont systemFontOfSize:14]];
        self.tipsLabel = label;
        [label release];
        [self.tipsLabel setTextAlignment:UITextAlignmentCenter];
        [self.view addSubview:self.tipsLabel];
        [self.tipsLabel setBackgroundColor:[UIColor clearColor]];
        [self.tipsLabel setTextColor:BUTTON_TEXT_NORMAL_COLOR];

    }
    [self.tipsLabel setText:text];
    [self.tipsLabel setHidden:NO];
}

- (void)hideTips
{
    [self.tipsLabel setHidden:YES];
}

- (void)updateNavigationTitle:(NSString*)titleString
{
    UILabel* label = (UILabel *)self.navigationItem.titleView;
    label.text = titleString;
}

- (void)showVideoPlayer:(BOOL)play index:(int)indexValue
{
    if (indexValue >= 0) {
        currentIndex = indexValue;
    }
    
    NSArray *itemList = [self findAllRelatedItems];
    
    if ([itemList count] == 0) {

        [self showTips:NSLS(@"kNoVideo")];
        return;
    }
    
    if (self.player != nil && !play) {
        return;
    }
    
    [self hideTips];
    DownloadItem *item = [itemList objectAtIndex:indexValue];
    NSURL* url = [NSURL fileURLWithPath:item.localPath];    
    if (self.player == nil){
        
        [self setDownloadItem:item];
        
        self.player = [[[MPMoviePlayerController alloc] initWithContentURL:url] autorelease];
        self.view.frame = self.view.bounds;
        CGRect frame = [self.view bounds];
        [[self.player view] setFrame:frame]; // size to fit parent view exactly
        
      
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//            self.player.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
        }
        
        [self.view addSubview:self.player.view];
        
        
//        MPMoviePlayerViewController * vc = [[[MPMoviePlayerViewController alloc] initWithContentURL:url ] autorelease];
//        [self presentMoviePlayerViewControllerAnimated:vc];
//        [vc.moviePlayer play];
        
    }
    else{
        if (self.downloadItem != item){
            [self setDownloadItem:item];
            [self.player setContentURL:url];
        }
    }
    
    [self updateNavigationTitle:item.fileName];
    [self.player play];   
}

- (void)setPreviousButton
{
    float buttonHigh = 27.5;
    float backButtonLen = 60;
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 0, backButtonLen, buttonHigh)];
    [backButton setBackgroundImage:ITEM_NEXT_ICON_IMAGE forState:UIControlStateNormal];
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    [backButton.titleLabel setFont:font];
    [backButton setTitleColor:[UIColor colorWithRed:99/255.0 green:124/255.0 blue:141/255.0 alpha:1.0] forState:UIControlStateNormal];
    [backButton setTitle:NSLS(@"kPrevious") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickPrevious:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    [leftBarButton release];
    
}

static inline double radians (double degrees) {return degrees * M_PI/180;}
UIImage* rotate(UIImage* src, UIImageOrientation orientation)
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, radians(90));
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, radians(-90));
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, radians(90));
    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

UIImage* rotate2(UIImage* src)
{
    CGSize size =  src.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextRotateCTM(ctx, M_PI_2);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       CGRectMake(0,0,size.width, size.height),
                       src.CGImage);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setNextButton
{
    float buttonHigh = 27.5;
    float nextButtonLen = 60;
        
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(218, 0, nextButtonLen, buttonHigh)];
    
//    UIImage *rotatedImage = rotate(ITEM_BACK_ICON_IMAGE, UIImageOrientationDown);
//    UIImage *rotatedImage = [UIImage imageWithCGImage:(ITEM_BACK_ICON_IMAGE).CGImage scale:1.0 orientation:UIImageOrientationDown];
    
    [nextButton setBackgroundImage:ITEM_NEXT_ICON_IMAGE forState:UIControlStateNormal];
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    [nextButton.titleLabel setFont:font];
    [nextButton setTitleColor:[UIColor colorWithRed:99/255.0 green:124/255.0 blue:141/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [nextButton setTitle:NSLS(@"kNext") forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];    
}


- (void)clickPrevious:(id)sender
{
    if (currentIndex > 0) {
        [self setCurrentIndex:currentIndex-1];
        
        NSArray *itemList = [self findAllRelatedItems];
        DownloadItem *item = [itemList objectAtIndex:currentIndex];
        NSURL* url = [NSURL fileURLWithPath:item.localPath]; 
        [self.player setContentURL:url];
        [self.player play];
    } else {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLS(@"kTips") message:NSLS(@"kAlreadyFirst") delegate:self cancelButtonTitle:NSLS(@"kOK") otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
}

- (void)clickNext:(id)sender
{
    NSArray *itemList = [self findAllRelatedItems];
    int totalCount = [itemList count];
    if (currentIndex < totalCount-1) {
        [self setCurrentIndex:currentIndex+1];
        
        DownloadItem *item = [itemList objectAtIndex:currentIndex];
        NSURL* url = [NSURL fileURLWithPath:item.localPath]; 
        [self.player setContentURL:url];
        [self.player play];
    } else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLS(@"kTips") message:NSLS(@"kAlreadyLast") delegate:self cancelButtonTitle:NSLS(@"kOK") otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // Do any additional setup after loading the view from its nib.
    [self setPreviousButton];
    [self setNextButton];
    [self setBackgroundImageName:DOWNLOAD_BG];
    [self setDownloadNavigationTitle:NSLS(@"kVideo")];

    [super viewDidLoad];
       
}

- (void)viewDidAppear:(BOOL)animated
{
    [self showVideoPlayer:NO index:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
//    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
//        return(YES);
//    }
//    
//    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
//        return([self.player isFullscreen]);
//    }
//    
}

@end
