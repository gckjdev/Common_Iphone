//
//  AppService.m
//  Dipan
//
//  Created by qqn_pipi on 11-7-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AppService.h"
#import "UserService.h"
#import "AppManager.h"
#import "PPApplication.h"
#import "UIUtils.h"

#import "GetAppUpdateRequest.h"

@implementation AppService

@synthesize newVersion;
@synthesize newAppURL;
@synthesize alertView;

- (id)init
{
    self = [super init];    
    workingQueue = dispatch_queue_create("app service queue", NULL);
    return self;
}

- (void)dealloc
{
    dispatch_release(workingQueue);
    workingQueue = NULL;
    
    [alertView release];
    [newAppURL release];
    [newVersion release];
    [super dealloc];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    enum {
        BUTTON_CANCEL = 0,
        BUTTON_YES
    };
    
    switch (buttonIndex) {
        case BUTTON_YES:
            [UIUtils openURL:newAppURL];
            break;
            
        default:
            break;
    }
}

- (void)askForUpdateNewVersion:(NSString*)version appURL:(NSString*)appURL
{
    self.newAppURL = appURL;
    self.newVersion = version;

    if ([newAppURL length] == 0 || [newVersion length] == 0){
        NSLog(@"askForUpdateNewVersion, but new app URL or new Version is null");
        return;
    }
    
    NSString* message = [NSString stringWithFormat:NSLS(@"kAskUpdateMsg"), newVersion];
    
    self.alertView = [[UIAlertView alloc] initWithTitle:NSLS(@"kAskUpdateTitle") 
                                                        message:message
                                                       delegate:self 
                                              cancelButtonTitle:NSLS(@"Cancel") 
                                              otherButtonTitles:NSLS(@"Yes"), nil];

    [alertView show];
}

- (void)startAppUpdate
{
    UserService* userService = GlobalGetUserService();
    NSString* userId = [[userService user] userId];
    NSString* appId = [AppManager getPlaceAppId];
    
    if ([appId length] == 0){
        NSLog(@"startAppUpdate but app id is null.");
    }
    
    dispatch_async(workingQueue, ^{
        GetAppUpdateOutput* output = [GetAppUpdateRequest send:SERVER_URL 
                                                        userId:userId 
                                                         appId:appId];    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS){               
                
                // check app key and secret and store in DB
                
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                if (output.sinaAppKey)
                    [userDefaults setObject:output.sinaAppKey forKey:USER_DEFAULT_SINA_KEY];
                if (output.sinaAppSecret)
                    [userDefaults setObject:output.sinaAppSecret forKey:USER_DEFAULT_SINA_SECRET];
                if (output.qqAppKey)
                    [userDefaults setObject:output.qqAppKey forKey:USER_DEFAULT_QQ_KEY];
                if (output.qqAppSecret)
                    [userDefaults setObject:output.qqAppSecret forKey:USER_DEFAULT_QQ_SECRET];                
                if (output.renrenAppKey)
                    [userDefaults setObject:output.renrenAppKey forKey:USER_DEFAULT_RENREN_KEY];
                if (output.renrenAppSecret)
                    [userDefaults setObject:output.renrenAppSecret forKey:USER_DEFAULT_RENREN_SECRET];                                
                
                // compare new version with current version, if higher than show a alert view        
                NSString* versionToCompare = nil;                
                if (self.newVersion == nil){
                    NSString* currentVersion = [PPApplication getAppVersion];  
                    NSLog(@"current version=%@", currentVersion);
                    versionToCompare = currentVersion;
                }
                else{
                    versionToCompare = self.newVersion;
                }
                if ([output.version compare:versionToCompare] != NSOrderedSame){
                    [self askForUpdateNewVersion:output.version appURL:output.appURL];
                }
            }
            else{
                NSLog(@"<startAppUpdate> fail to get app update, resultcode is %d", output.resultCode);
            } 
        });
    });
}


@end
