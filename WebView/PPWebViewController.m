
#import "PPWebViewController.h"

TTWebController* gWebController;

TTWebController* GlobalGetWebController()
{
    if (gWebController == nil){
        gWebController = [[TTWebController alloc] init];
    }
    
    return gWebController;
}


