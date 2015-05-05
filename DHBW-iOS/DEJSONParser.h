//
//  DEJSONParser.h
//  DHBW-iOS
//
//  Created by David Ehlen on 19.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DEJSONParser : NSObject

- (void)modelsFromURL:(NSURL*)url forClass:(Class)modelClass withCompletion:(void (^)(NSMutableArray *))callbackBlock;

@end