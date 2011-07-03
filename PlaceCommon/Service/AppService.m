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
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLS(@"kAskUpdateTitle") 
                                                        message:message
                                                       delegate:self 
                                              cancelButtonTitle:NSLS(@"Cancel") 
                                              otherButtonTitles:NSLS(@"Yes"), nil];

    [alertView show];
    [alertView release];    
}

- (void)startAppUpdate
{
    UserService* userService = GlobalGetUserService();
    NSString* userId = [[userService user] userId];
    NSString* appId = [AppManager getPlaceAppId];
    
    if ([userId length] == 0){
        NSLog(@"startAppUpdate but user id is null, maybe user is not registered yet");
        return;
    }
    
    dispatch_async(workingQueue, ^{
        
        GetAppUpdateOutput* output = [GetAppUpdateRequest send:SERVER_URL 
                                                        userId:userId 
                                                         appId:appId];        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS){               
                
                // check app key and secret and store in DB
//                [self storeAppKeySecret];
                
                // compare new version with current version, if higher than show a alert view        
                NSString* versionToCompare = nil;                
                if (self.newVersion == nil){
                    NSString* currentVersion = [PPApplication getAppVersion];  
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
