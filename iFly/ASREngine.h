//
//  ASREngine.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iFlyISR/IFlyRecognizeControl.h"

@interface ASREngine : NSObject {
    IFlyRecognizeControl    *iFlyRecognizeControl;
}

- (BOOL)initEngine;

@end
