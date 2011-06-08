//
//  NetworkUtil.h
//  three20test
//
//  Created by qqn_pipi on 10-4-14.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HTTPResponseHandlerBlock)(NSString* responseText);

@interface NetworkUtil : NSObject {

}

+ (BOOL)connectedToNetwork;
+ (int)sendRequest:(NSURLRequest*)request respnoseHandlerBlock:(HTTPResponseHandlerBlock)respnoseHandlerBlock;

@end
