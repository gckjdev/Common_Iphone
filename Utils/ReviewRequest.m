#include "ReviewRequest.h"
#import  "UIUtils.h"

#define KeyReviewed						@"ReviewRequestReviewedForVersion"
#define KeyDontAsk						@"ReviewRequestDontAsk"
#define KeyNextTimeToAsk				@"ReviewRequestNextTimeToAsk"
#define KeySessionCountSinceLastAsked	@"ReviewRequestSessionCountSinceLastAsked"

#define kInfoAppName		NSLocalizedStringFromTable(@"kInfoAppName", @"ReviewRequest", nil)
#define kInfoAppDetails		NSLocalizedStringFromTable(@"kInfoAppDetails", @"ReviewRequest", nil)
#define kInfoRateIt			NSLocalizedStringFromTable(@"kInfoRateIt",@"ReviewRequest", nil)
#define kInfoRemindMe		NSLocalizedStringFromTable(@"kInfoRemindMe", @"ReviewRequest", nil)
#define kInfoAskAgain		NSLocalizedStringFromTable(@"kInfoAskAgain", @"ReviewRequest", nil)

#define kDefaultMinUsageCount	5			// 5 times
#define kDefaultPromptInterval	24			// 24 hours, every one day

@implementation ReviewRequest

@synthesize appId, appName, minUsageCount, promptInterval;

+ (ReviewRequest*)startReviewRequest:(NSString*)appIdValue appName:(NSString*)appNameValue isTest:(BOOL)isTest
{
	ReviewRequest* review = [[[ReviewRequest alloc] initWithAppId:appIdValue appName:appNameValue] autorelease];	
	if (isTest == YES){
		review.minUsageCount = 0;
		review.promptInterval = 0;
	}
	
	if ([review shouldAskForReviewAtLaunch]){
		[review askForReview];
	}	
    
    return review;
}

- (id)initWithAppId:(NSString*)appIdValue appName:(NSString*)appNameValue
{
	self = [super init];
    
    self.appId = appIdValue;
    self.appName = appNameValue;
    
    minUsageCount = kDefaultMinUsageCount;
    promptInterval = kDefaultPromptInterval;
	
	return self;
}

- (void)dealloc
{
	[appId release];
	[appName release];
	[super dealloc];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	switch (buttonIndex)
	{
		case 0: // remind me later
		{
			const double nextTime = CFAbsoluteTimeGetCurrent() + promptInterval * 3600; 
			[defaults setDouble:nextTime forKey:KeyNextTimeToAsk];
			break;
		}
			
		case 1: // rate it now
		{
			NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
			[defaults setValue:version forKey:KeyReviewed];
			
			[UIUtils openApp:appId];
			
			break;
		}
			
		case 2: // don't ask again
			[defaults setBool:TRUE forKey:KeyDontAsk];
			break;
		default:
			break;
	}
	
	[defaults setInteger:0 forKey:KeySessionCountSinceLastAsked];
	[self release];
}


- (BOOL)shouldAskForReview
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

	if ([defaults boolForKey:KeyDontAsk]){
		NSLog(@"<shouldAskForReview> KeyDontAsk=YES");
		return FALSE;
	}

	NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];		
	NSString* reviewedVersion = [defaults stringForKey:KeyReviewed];
	if ([reviewedVersion isEqualToString:version]){
		NSLog(@"<shouldAskForReview> Reviewed Version is %@, it's already reviewed", reviewedVersion);		
		return FALSE;
	}

	const double currentTime = CFAbsoluteTimeGetCurrent();
	if ([defaults objectForKey:KeyNextTimeToAsk] == nil)
	{
		const double nextTime = currentTime + promptInterval * 3600;  
		[defaults setDouble:nextTime forKey:KeyNextTimeToAsk];
		
		NSLog(@"<shouldAskForReview> set next review time to %.0f minutes", (nextTime / 60));		
		return FALSE;
	}
	
	const double nextTime = [defaults doubleForKey:KeyNextTimeToAsk];
	if (currentTime < nextTime){
		NSLog(@"<shouldAskForReview> not ready for review yet, try after %.0f minutes", (nextTime - currentTime)/60);		
		return FALSE;
	}

	return TRUE;
}


- (BOOL)shouldAskForReviewAtLaunch
{
	if ([self shouldAskForReview] == FALSE)
		return FALSE;
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	const int count = [defaults integerForKey:KeySessionCountSinceLastAsked];
	[defaults setInteger:count+1 forKey:KeySessionCountSinceLastAsked];
	
	if (count < minUsageCount){
		NSLog(@"next time count is %d", count);		
		return FALSE;
	}

	return TRUE;
}


- (void)askForReview
{
	NSString* title = [NSString stringWithFormat:kInfoAppName, appName];
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
					message:kInfoAppDetails
					delegate:self cancelButtonTitle:kInfoRemindMe otherButtonTitles:kInfoRateIt, kInfoAskAgain, nil];
	[alert show];
	[alert release];
}


@end
