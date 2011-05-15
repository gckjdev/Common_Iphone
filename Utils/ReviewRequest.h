
#import <Foundation/Foundation.h>

@interface ReviewRequest : NSObject <UIAlertViewDelegate>
{
	NSString* appId;
	NSString* appName;
	
	int		  minUsageCount;	// at least your users shall use this app for minmum times
	int		  promptInterval;	// after X hours, prompt review request again
}

// just call this method to create a standard review request, if for testing, set isTest to YES
+ (void)startReviewRequest:(NSString*)appIdValue appName:(NSString*)appNameValue isTest:(BOOL)isTest;

- (id)initWithAppId:(NSString*)appIdValue appName:(NSString*)appNameValue;
- (BOOL)shouldAskForReviewAtLaunch;
- (void)askForReview;


@property (nonatomic, retain) NSString* appId;
@property (nonatomic, retain) NSString* appName;
@property (nonatomic) int		  minUsageCount;	// at least your users shall use this app for minmum times
@property (nonatomic) int		  promptInterval;	// after X hours, prompt review request again


@end
