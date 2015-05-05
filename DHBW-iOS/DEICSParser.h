//
//  DEICSParser.h
//  DHBW-iOS
//
//  Created by David Ehlen on 10.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

@interface DEICSParser : NSObject {
    KeychainItemWrapper *keychainWrapper;
}
- (void)modelsWithCompletion:(void (^)(NSMutableArray *))callbackBlock;
@end
